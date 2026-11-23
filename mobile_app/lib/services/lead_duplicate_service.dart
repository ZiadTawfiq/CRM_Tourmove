import '../models/crm_enums.dart';
import '../models/crm_models.dart';
import '../models/lead_model.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'crm_demo_data.dart';

class LeadDuplicateService {
  final ApiClient _client = ApiClient();
  final ApiConfig _config = ApiConfig();

  List<LeadDuplicateRecord> _cachedRecords = [];

  LeadDuplicateService() {
    _cachedRecords = CrmDemoData.getDuplicateRecords();
  }

  /// Clean phone format for robust comparison
  String _normalizePhone(String phone) {
    String clean = phone.trim().replaceAll(RegExp(r'\s+|-|\+'), '');
    if (clean.startsWith('20')) clean = clean.substring(2);
    if (clean.startsWith('0')) clean = clean.substring(1);
    return clean;
  }

  /// Real-time phone duplication check matching backend DuplicateHandler logic
  LeadModel? checkDuplicatePhone(List<LeadModel> leads, String phone, {int? excludeLeadId}) {
    final clean = _normalizePhone(phone);
    if (clean.length < 7) return null;

    try {
      return leads.firstWhere(
        (l) => (excludeLeadId == null || l.id != excludeLeadId) &&
            _normalizePhone(l.phoneNumber) == clean,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get list of duplicate alerts for review
  Future<List<LeadDuplicateRecord>> getDuplicateRecords() async {
    if (_config.isDemoMode) {
      return List.unmodifiable(_cachedRecords);
    }

    try {
      final res = await _client.get('/LeadDuplicate');
      if (res is List) {
        _cachedRecords = res.map((r) => LeadDuplicateRecord.fromJson(r)).toList();
      }
      return List.unmodifiable(_cachedRecords);
    } catch (_) {
      return List.unmodifiable(_cachedRecords);
    }
  }

  /// Register a duplicate alert when a sales rep attempts to add an existing customer
  LeadDuplicateRecord registerDuplicateAttempt({
    required LeadModel originalLead,
    required EmployeeModel attemptedByEmployee,
    required ProjectModel project,
  }) {
    final record = LeadDuplicateRecord(
      id: DateTime.now().millisecondsSinceEpoch,
      leadId: originalLead.id,
      leadName: originalLead.name,
      phoneNumber: originalLead.phoneNumber,
      projectId: project.id,
      projectName: project.name,
      originalSalesRepId: originalLead.employeeId ?? '',
      originalSalesRepName: originalLead.employeeName ?? 'غير مسند',
      attemptedByEmployeeId: attemptedByEmployee.id,
      attemptedByEmployeeName: attemptedByEmployee.name,
      createdAt: DateTime.now(),
      status: DuplicateStatus.pending,
    );

    _cachedRecords.insert(0, record);
    return record;
  }

  /// Executes Strategy Pattern handlers:
  /// - DuplicateAction.reassignToAnotherSalesRep (ReassignLeadHandler)
  /// - DuplicateAction.createNewLead (CreateNewleadHandelr)
  Future<void> reviewDuplicateLead({
    required int recordId,
    required DuplicateAction action,
    required String newSalesRepId,
    required List<EmployeeModel> employees,
    required List<LeadModel> leadsList,
    required Function(LeadModel newLead) onNewLeadCreated,
  }) async {
    final recordIndex = _cachedRecords.indexWhere((r) => r.id == recordId);
    if (recordIndex == -1) return;

    final record = _cachedRecords[recordIndex];
    final newRep = employees.firstWhere(
      (e) => e.id == newSalesRepId,
      orElse: () => employees.first,
    );

    if (action == DuplicateAction.reassignToAnotherSalesRep) {
      // ReassignLeadHandler Strategy:
      final leadIndex = leadsList.indexWhere((l) => l.id == record.leadId);
      if (leadIndex != -1) {
        final lead = leadsList[leadIndex];
        lead.employeeId = newRep.id;
        lead.employeeName = newRep.name;
        lead.assigned = DateTime.now();
        lead.updated = DateTime.now();
        lead.comments.insert(
          0,
          CommentModel(
            id: DateTime.now().millisecondsSinceEpoch,
            comment: 'إجراء مراجعة التكرار (ReassignLeadHandler): تم نقل العميل وإسناده إلى المندوب: ${newRep.name}.',
            createdAt: DateTime.now(),
            author: 'مدير النظام',
          ),
        );
      }
      record.status = DuplicateStatus.reassigned;
    } else {
      // CreateNewleadHandelr Strategy:
      final leadIndex = leadsList.indexWhere((l) => l.id == record.leadId);
      final existingLead = leadIndex != -1 ? leadsList[leadIndex] : null;

      final brandNewLead = LeadModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: existingLead?.name ?? record.leadName,
        phoneNumber: existingLead?.phoneNumber ?? record.phoneNumber,
        projectId: record.projectId,
        projectName: record.projectName,
        employeeId: newRep.id,
        employeeName: newRep.name,
        channelId: existingLead?.channelId ?? 1,
        channelName: existingLead?.channelName ?? 'مباشر',
        budget: existingLead?.budget,
        status: LeadStatus.freshLead,
        typeLead: existingLead?.typeLead ?? TypeLead.sale,
        isDuplicated: false, // Resolved as a distinct lead
        created: DateTime.now(),
        updated: DateTime.now(),
        assigned: DateTime.now(),
        comments: [
          CommentModel(
            id: DateTime.now().millisecondsSinceEpoch,
            comment: 'إجراء مراجعة التكرار (CreateNewleadHandelr): تم اعتماد وتسجيل طلب جديد منفصل للمندوب: ${newRep.name}.',
            createdAt: DateTime.now(),
            author: 'مدير النظام',
          ),
        ],
      );

      leadsList.insert(0, brandNewLead);
      onNewLeadCreated(brandNewLead);
      record.status = DuplicateStatus.created;
    }

    if (!_config.isDemoMode) {
      try {
        await _client.post('/LeadDuplicate/review', {
          'duplicateLeadId': recordId,
          'action': action.actionName,
          'newSalesRepId': newSalesRepId,
        });
      } catch (_) {}
    }
  }

  void reset() {
    _cachedRecords = CrmDemoData.getDuplicateRecords();
  }
}

