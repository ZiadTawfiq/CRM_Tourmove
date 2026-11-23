import '../models/crm_enums.dart';
import '../models/crm_models.dart';
import '../models/lead_model.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'crm_demo_data.dart';

class LeadService {
  final ApiClient _client = ApiClient();
  final ApiConfig _config = ApiConfig();

  List<LeadModel> _cachedLeads = [];

  LeadService() {
    _cachedLeads = CrmDemoData.getLeads();
  }

  Future<List<LeadModel>> getAll() async {
    if (_config.isDemoMode) {
      return List.unmodifiable(_cachedLeads);
    }

    try {
      final res = await _client.get('/Lead');
      if (res is List) {
        _cachedLeads = res.map((l) => LeadModel.fromJson(l)).toList();
      }
      return List.unmodifiable(_cachedLeads);
    } catch (_) {
      return List.unmodifiable(_cachedLeads);
    }
  }

  Future<LeadModel?> getById(int id) async {
    final list = await getAll();
    try {
      return list.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<LeadModel> create(LeadModel lead) async {
    if (_config.isDemoMode) {
      _cachedLeads.insert(0, lead);
      return lead;
    }

    try {
      final res = await _client.post('/Lead', lead.toJson());
      final created = LeadModel.fromJson(res);
      _cachedLeads.insert(0, created);
      return created;
    } catch (_) {
      _cachedLeads.insert(0, lead);
      return lead;
    }
  }

  Future<void> update(LeadModel lead) async {
    final index = _cachedLeads.indexWhere((l) => l.id == lead.id);
    if (index != -1) {
      _cachedLeads[index] = lead;
    }

    if (!_config.isDemoMode) {
      try {
        await _client.put('/Lead/${lead.id}', lead.toJson());
      } catch (_) {}
    }
  }

  Future<void> delete(int id) async {
    _cachedLeads.removeWhere((l) => l.id == id);

    if (!_config.isDemoMode) {
      try {
        await _client.delete('/Lead/$id');
      } catch (_) {}
    }
  }

  /// Assign list of leads to a sales representative
  Future<void> assignLeadsToSalesRep(List<int> leadIds, EmployeeModel salesRep) async {
    final now = DateTime.now();
    for (final id in leadIds) {
      final index = _cachedLeads.indexWhere((l) => l.id == id);
      if (index != -1) {
        final lead = _cachedLeads[index];
        lead.employeeId = salesRep.id;
        lead.employeeName = salesRep.name;
        lead.assigned = now;
        lead.updated = now;
        lead.comments.insert(
          0,
          CommentModel(
            id: DateTime.now().millisecondsSinceEpoch,
            comment: 'تم إسناد العميل إلى المندوب: ${salesRep.name}',
            createdAt: now,
            author: 'مدير النظام',
          ),
        );
      }
    }

    if (!_config.isDemoMode) {
      try {
        await _client.post('/Lead/assign', {
          'leadIds': leadIds,
          'salesRepId': salesRep.id,
        });
      } catch (_) {}
    }
  }

  /// Status transitions matching LeadStatusHandler:
  /// - CancellationStatusHandler
  /// - ReservationStatusHandler
  /// - OrientationStatusHandler
  /// - FollowUpStatusHandler
  Future<void> updateLeadStatus(
    int leadId,
    LeadStatus newStatus, {
    int? cancellationReasonId,
    String? cancellationReasonText,
    DateTime? orientationDate,
    DateTime? reservationDate,
    String? note,
    String author = 'المستخدم',
  }) async {
    final index = _cachedLeads.indexWhere((l) => l.id == leadId);
    if (index == -1) return;

    final lead = _cachedLeads[index];
    final now = DateTime.now();

    lead.status = newStatus;
    lead.updated = now;

    if (newStatus == LeadStatus.cancellation) {
      lead.cancellationReasonId = cancellationReasonId;
      lead.cancellationReason = cancellationReasonText ?? 'تم الإلغاء';
      lead.cancellationDate = now;
    } else if (newStatus == LeadStatus.reservation) {
      lead.reservationDate = reservationDate ?? now;
    } else if (newStatus == LeadStatus.orientation) {
      lead.orientationDate = orientationDate ?? now.add(const Duration(days: 2));
    }

    String commentText = 'تحديث الحالة عبر LeadStatusHandler إلى: ${newStatus.labelAr}';
    if (cancellationReasonText != null && cancellationReasonText.isNotEmpty) {
      commentText += ' - سبب الإلغاء: $cancellationReasonText';
    }
    if (note != null && note.trim().isNotEmpty) {
      commentText += ' | ملاحظة: ${note.trim()}';
    }

    lead.comments.insert(
      0,
      CommentModel(
        id: DateTime.now().millisecondsSinceEpoch,
        comment: commentText,
        createdAt: now,
        author: author,
      ),
    );

    if (!_config.isDemoMode) {
      try {
        await _client.post('/Lead/update-status', {
          'leadId': leadId,
          'status': newStatus.id,
          'cancellationReasonId': cancellationReasonId,
          'notes': note ?? '',
        });
      } catch (_) {}
    }
  }

  List<LeadModel> searchByPhoneNumber(String phone) {
    final clean = phone.trim().replaceAll(RegExp(r'\s+'), '');
    return _cachedLeads.where((l) => l.phoneNumber.contains(clean)).toList();
  }

  void reset() {
    _cachedLeads = CrmDemoData.getLeads();
  }
}

