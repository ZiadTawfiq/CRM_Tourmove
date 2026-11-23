import 'package:flutter/foundation.dart';
import '../models/crm_enums.dart';
import '../models/crm_models.dart';
import '../models/lead_model.dart';
import 'api_config.dart';
import 'auth_service.dart';
import 'channel_service.dart';
import 'comment_service.dart';
import 'employee_service.dart';
import 'lead_duplicate_service.dart';
import 'lead_service.dart';
import 'project_service.dart';

class CrmRepository extends ChangeNotifier {
  static final CrmRepository _instance = CrmRepository._internal();
  factory CrmRepository() => _instance;

  final ApiConfig apiConfig = ApiConfig();
  final AuthService authService = AuthService();
  final LeadService leadService = LeadService();
  final ProjectService projectService = ProjectService();
  final ChannelService channelService = ChannelService();
  final EmployeeService employeeService = EmployeeService();
  final CommentService commentService = CommentService();
  final LeadDuplicateService duplicateService = LeadDuplicateService();

  List<LeadModel> _leads = [];
  List<ProjectModel> _projects = [];
  List<ChannelModel> _channels = [];
  List<EmployeeModel> _employees = [];
  List<LeadDuplicateRecord> _duplicates = [];

  List<LeadModel> get leads => List.unmodifiable(_leads);
  List<ProjectModel> get projects => List.unmodifiable(_projects);
  List<ChannelModel> get channels => List.unmodifiable(_channels);
  List<EmployeeModel> get employees => List.unmodifiable(_employees);
  List<LeadDuplicateRecord> get duplicateRecords => List.unmodifiable(_duplicates);

  int get duplicateCount => _duplicates.where((d) => d.status == DuplicateStatus.pending).length +
      _leads.where((l) => l.isDuplicated).length;

  EmployeeModel? get currentUser => authService.currentUser;
  bool get isDemoMode => apiConfig.isDemoMode;

  CrmRepository._internal() {
    _loadInitialData();
  }

  void _loadInitialData() async {
    _leads = await leadService.getAll();
    _projects = await projectService.getAll();
    _channels = await channelService.getAll();
    _employees = await employeeService.getAll();
    _duplicates = await duplicateService.getDuplicateRecords();
    notifyListeners();
  }

  /// Real-time duplicate phone checking (powered by LeadDuplicateService)
  LeadModel? findDuplicatePhone(String phone, {int? excludeId}) {
    return duplicateService.checkDuplicatePhone(_leads, phone, excludeLeadId: excludeId);
  }

  /// Create new lead with duplicate phone detection & duplicate registration
  Future<LeadModel> createLead({
    required String name,
    required String phoneNumber,
    required int projectId,
    required int channelId,
    String? employeeId,
    double? budget,
    LeadStatus status = LeadStatus.freshLead,
    TypeLead typeLead = TypeLead.sale,
    String? note,
  }) async {
    final cleanPhone = phoneNumber.trim().replaceAll(RegExp(r'\s+'), '');
    final existingDuplicate = findDuplicatePhone(cleanPhone);
    final isDup = existingDuplicate != null;

    final project = _projects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => _projects.first,
    );
    final channel = _channels.firstWhere(
      (c) => c.id == channelId,
      orElse: () => _channels.first,
    );
    final currentEmp = currentUser;
    final assignedEmp = employeeId != null
        ? _employees.firstWhere((e) => e.id == employeeId, orElse: () => currentEmp ?? _employees.first)
        : currentEmp;

    final now = DateTime.now();

    final newLead = LeadModel(
      id: now.millisecondsSinceEpoch,
      name: name.trim(),
      phoneNumber: cleanPhone,
      projectId: projectId,
      projectName: project.name,
      channelId: channelId,
      channelName: channel.name,
      employeeId: assignedEmp?.id,
      employeeName: assignedEmp?.name ?? 'غير مسند',
      budget: budget,
      status: status,
      typeLead: typeLead,
      isDuplicated: isDup,
      created: now,
      updated: now,
      assigned: assignedEmp != null ? now : null,
      comments: [
        if (note != null && note.trim().isNotEmpty)
          CommentModel(
            id: now.millisecondsSinceEpoch,
            comment: note.trim(),
            createdAt: now,
            author: currentEmp?.name ?? 'المستخدم',
            employeeId: currentEmp?.id,
          ),
        CommentModel(
          id: now.millisecondsSinceEpoch + 1,
          comment: isDup
              ? 'تنبيه: تم تسجيل هذا العميل برقم هاتف مسجل مسبقاً لدى العميل (${existingDuplicate.name}).'
              : 'تم تسجيل العميل بنجاح في النظام وإسناده إلى: ${assignedEmp?.name ?? "غير محدد"}.',
          createdAt: now,
          author: 'System',
        ),
      ],
    );

    // If duplicate detected, register it in the duplicate review queue
    if (isDup && currentEmp != null) {
      final record = duplicateService.registerDuplicateAttempt(
        originalLead: existingDuplicate,
        attemptedByEmployee: currentEmp,
        project: project,
      );
      _duplicates.insert(0, record);
    }

    await leadService.create(newLead);
    _leads.insert(0, newLead);
    notifyListeners();
    return newLead;
  }

  /// Update Lead status using LeadStatusHandler logic
  Future<void> updateLeadStatus(
    int leadId,
    LeadStatus newStatus, {
    int? reasonId,
    String? reasonText,
    DateTime? orientationDate,
    DateTime? reservationDate,
    String? note,
  }) async {
    await leadService.updateLeadStatus(
      leadId,
      newStatus,
      cancellationReasonId: reasonId,
      cancellationReasonText: reasonText,
      orientationDate: orientationDate,
      reservationDate: reservationDate,
      note: note,
      author: currentUser?.name ?? 'المستخدم',
    );
    notifyListeners();
  }

  /// Assign lead to a sales representative
  Future<void> assignSalesRep(int leadId, String employeeId) async {
    final emp = _employees.firstWhere((e) => e.id == employeeId);
    await leadService.assignLeadsToSalesRep([leadId], emp);
    notifyListeners();
  }

  /// Add comment / timeline note to lead
  Future<void> addComment(int leadId, String text, {String? author}) async {
    final lead = _leads.firstWhere((l) => l.id == leadId);
    final commentAuthor = author ?? currentUser?.name ?? 'المستخدم';
    final comment = await commentService.createComment(
      leadId: leadId,
      text: text,
      employeeId: currentUser?.id,
      author: commentAuthor,
    );
    lead.comments.insert(0, comment);
    lead.updated = DateTime.now();
    notifyListeners();
  }

  /// Delete lead
  Future<void> deleteLead(int leadId) async {
    await leadService.delete(leadId);
    _leads.removeWhere((l) => l.id == leadId);
    notifyListeners();
  }

  /// Review duplicate lead using Strategy Pattern:
  /// - DuplicateAction.reassignToAnotherSalesRep (ReassignLeadHandler)
  /// - DuplicateAction.createNewLead (CreateNewleadHandelr)
  Future<void> reviewDuplicateLead({
    required int recordId,
    required DuplicateAction action,
    required String newSalesRepId,
  }) async {
    await duplicateService.reviewDuplicateLead(
      recordId: recordId,
      action: action,
      newSalesRepId: newSalesRepId,
      employees: _employees,
      leadsList: _leads,
      onNewLeadCreated: (newLead) {
        // Newly generated lead added by CreateNewleadHandelr
      },
    );
    notifyListeners();
  }

  /// Switch active logged-in user
  void switchUser(EmployeeModel employee) {
    authService.switchDemoUser(employee);
    notifyListeners();
  }

  /// Toggle Live API mode vs Demo mode
  void setDemoMode(bool isDemo) {
    apiConfig.isDemoMode = isDemo;
    _loadInitialData();
  }

  /// Update backend base URL
  void setBaseUrl(String url) {
    apiConfig.baseUrl = url.trim();
    notifyListeners();
  }

  /// Reset demo data to default clean seed
  void resetDemoData() {
    leadService.reset();
    projectService.reset();
    channelService.reset();
    employeeService.reset();
    duplicateService.reset();
    _loadInitialData();
  }
}
