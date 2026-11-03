import 'package:flutter/foundation.dart';
import '../models/crm_enums.dart';
import '../models/crm_models.dart';
import '../models/lead_model.dart';

class CrmRepository extends ChangeNotifier {
  static final CrmRepository _instance = CrmRepository._internal();
  factory CrmRepository() => _instance;
  CrmRepository._internal() {
    _initDefaultData();
  }

  List<LeadModel> _leads = [];
  List<ProjectModel> _projects = [];
  List<ChannelModel> _channels = [];
  List<EmployeeModel> _employees = [];

  List<LeadModel> get leads => List.unmodifiable(_leads);
  List<ProjectModel> get projects => List.unmodifiable(_projects);
  List<ChannelModel> get channels => List.unmodifiable(_channels);
  List<EmployeeModel> get employees => List.unmodifiable(_employees);

  int get duplicateCount => _leads.where((l) => l.isDuplicated).length;

  void _initDefaultData() {
    _projects = [
      ProjectModel(id: 1, name: 'كمبوند بالم هيلز التجمع', location: 'القاهرة الجديدة', startingPrice: 6500000),
      ProjectModel(id: 2, name: 'زد إيست التجمع الخامس', location: 'التجمع الخامس', startingPrice: 8200000),
      ProjectModel(id: 3, name: 'ماونتن فيو أي سيتي', location: 'التجمع الخامس', startingPrice: 5400000),
      ProjectModel(id: 4, name: 'سول تاون فيلا فاخرة', location: 'الشيخ زايد', startingPrice: 12500000),
      ProjectModel(id: 5, name: 'أبراج العلمين الشاطئية', location: 'الساحل الشمالي', startingPrice: 9800000),
    ];

    _channels = [
      ChannelModel(id: 1, name: 'إعلانات فيسبوك (Facebook Ads)'),
      ChannelModel(id: 2, name: 'إعلانات جوجل (Google Ads)'),
      ChannelModel(id: 3, name: 'توصية وترشيح (Referral)'),
      ChannelModel(id: 4, name: 'زيارة المعرض (Walk-in)'),
      ChannelModel(id: 5, name: 'الموقع الإلكتروني (Website)'),
      ChannelModel(id: 6, name: 'إنستجرام (Instagram)'),
    ];

    _employees = [
      EmployeeModel(id: 'emp-101', name: 'أحمد ممدوح', email: 'ahmed@tourmove.com', phone: '+201011223344', role: 2),
      EmployeeModel(id: 'emp-102', name: 'سارة عبد الرحمن', email: 'sara@tourmove.com', phone: '+201022334455', role: 2),
      EmployeeModel(id: 'emp-103', name: 'عمر الشناوي', email: 'omar@tourmove.com', phone: '+201033445566', role: 3),
      EmployeeModel(id: 'emp-104', name: 'نورهان طارق', email: 'nourhan@tourmove.com', phone: '+201044556677', role: 4),
      EmployeeModel(id: 'emp-100', name: 'خالد توفيق (مدير)', email: 'khaled@tourmove.com', phone: '+201099887766', role: 1),
    ];

    final now = DateTime.now();

    _leads = [
      LeadModel(
        id: 1001,
        name: 'م. طارق كمال المنشاوي',
        phoneNumber: '01001234567',
        projectId: 1,
        projectName: 'كمبوند بالم هيلز التجمع',
        employeeId: 'emp-101',
        employeeName: 'أحمد ممدوح',
        channelId: 1,
        channelName: 'إعلانات فيسبوك (Facebook Ads)',
        budget: 7500000,
        status: LeadStatus.freshLead,
        typeLead: TypeLead.sale,
        isDuplicated: false,
        created: now.subtract(const Duration(hours: 2)),
        updated: now.subtract(const Duration(hours: 2)),
        assigned: now.subtract(const Duration(hours: 1)),
        comments: [
          CommentModel(
            id: 1,
            comment: 'سجل اهتمامه عبر نموذج فيسبوك يطلب وحدة 3 غرف نوم بموقع مميز.',
            createdAt: now.subtract(const Duration(hours: 2)),
            author: 'System',
          ),
        ],
      ),
      LeadModel(
        id: 1002,
        name: 'د. منى عبد العزيز العوضي',
        phoneNumber: '01123456789',
        projectId: 2,
        projectName: 'زد إيست التجمع الخامس',
        employeeId: 'emp-102',
        employeeName: 'سارة عبد الرحمن',
        channelId: 2,
        channelName: 'إعلانات جوجل (Google Ads)',
        budget: 9500000,
        status: LeadStatus.followUp,
        typeLead: TypeLead.sale,
        isDuplicated: false,
        created: now.subtract(const Duration(hours: 24)),
        updated: now.subtract(const Duration(hours: 4)),
        assigned: now.subtract(const Duration(hours: 20)),
        comments: [
          CommentModel(
            id: 2,
            comment: 'تم الاتصال بالعميلة، مهتمة بزد إيست وتطلب جدول أقساط 8 سنوات.',
            createdAt: now.subtract(const Duration(hours: 18)),
            author: 'سارة عبد الرحمن',
          ),
        ],
      ),
      LeadModel(
        id: 1003,
        name: 'أ/ شريف حسام الدين',
        phoneNumber: '01234567890',
        projectId: 3,
        projectName: 'ماونتن فيو أي سيتي',
        employeeId: 'emp-101',
        employeeName: 'أحمد ممدوح',
        channelId: 3,
        channelName: 'توصية وترشيح (Referral)',
        budget: 6200000,
        status: LeadStatus.orientation,
        typeLead: TypeLead.sale,
        isDuplicated: false,
        created: now.subtract(const Duration(hours: 48)),
        updated: now.subtract(const Duration(hours: 8)),
        orientationDate: now.add(const Duration(days: 2)),
        comments: [
          CommentModel(
            id: 3,
            comment: 'تم تحديد موعد معاينة ميدانية للمشروع يوم السبت القادم.',
            createdAt: now.subtract(const Duration(hours: 8)),
            author: 'أحمد ممدوح',
          ),
        ],
      ),
      LeadModel(
        id: 1004,
        name: 'م/ ياسمين فاروق المهدي',
        phoneNumber: '01509876543',
        projectId: 4,
        projectName: 'سول تاون فيلا فاخرة',
        employeeId: 'emp-102',
        employeeName: 'سارة عبد الرحمن',
        channelId: 5,
        channelName: 'الموقع الإلكتروني (Website)',
        budget: 14000000,
        status: LeadStatus.reservation,
        typeLead: TypeLead.sale,
        isDuplicated: false,
        created: now.subtract(const Duration(hours: 120)),
        updated: now.subtract(const Duration(hours: 12)),
        reservationDate: now.subtract(const Duration(hours: 12)),
        comments: [
          CommentModel(
            id: 4,
            comment: 'تم توقيع استمارة الحجز ودفع دفعة المقدم لدى الحسابات بنجاح.',
            createdAt: now.subtract(const Duration(hours: 12)),
            author: 'سارة عبد الرحمن',
          ),
        ],
      ),
      LeadModel(
        id: 1005,
        name: 'حازم الدسوقي',
        phoneNumber: '01001234567', // Duplicate demo phone
        projectId: 5,
        projectName: 'أبراج العلمين الشاطئية',
        employeeId: 'emp-103',
        employeeName: 'عمر الشناوي',
        channelId: 4,
        channelName: 'زيارة المعرض (Walk-in)',
        budget: 10500000,
        status: LeadStatus.freshLead,
        typeLead: TypeLead.sale,
        isDuplicated: true,
        created: now.subtract(const Duration(hours: 6)),
        updated: now.subtract(const Duration(hours: 6)),
        comments: [
          CommentModel(
            id: 5,
            comment: 'تنبيه أمان: تم رصد رقم هاتف مكرر مسجل مسبقاً لدى العميل م. طارق كمال.',
            createdAt: now.subtract(const Duration(hours: 6)),
            author: 'نظام الحماية من التكرار',
          ),
        ],
      ),
      LeadModel(
        id: 1006,
        name: 'أ/ ماجد حسني ناصف',
        phoneNumber: '01287654321',
        projectId: 3,
        projectName: 'ماونتن فيو أي سيتي',
        employeeId: 'emp-101',
        employeeName: 'أحمد ممدوح',
        channelId: 1,
        channelName: 'إعلانات فيسبوك (Facebook Ads)',
        budget: 4500000,
        status: LeadStatus.cancellation,
        typeLead: TypeLead.sale,
        isDuplicated: false,
        cancellationReasonId: 1,
        cancellationReason: 'الميزانية غير ملائمة (Budget Out of Range)',
        cancellationDate: now.subtract(const Duration(hours: 18)),
        created: now.subtract(const Duration(hours: 70)),
        updated: now.subtract(const Duration(hours: 18)),
        comments: [
          CommentModel(
            id: 6,
            comment: 'تم تحويل الطلب للإلغاء بسبب عدم تناسب الأسعار المطروحة مع ميزانيته.',
            createdAt: now.subtract(const Duration(hours: 18)),
            author: 'أحمد ممدوح',
          ),
        ],
      ),
    ];
  }

  // Check duplicate phone
  LeadModel? findDuplicatePhone(String phone, {int? excludeId}) {
    final clean = phone.trim().replaceAll(RegExp(r'\s+'), '');
    if (clean.length < 7) return null;
    try {
      return _leads.firstWhere(
        (l) => (excludeId == null || l.id != excludeId) &&
            l.phoneNumber.trim().replaceAll(RegExp(r'\s+'), '') == clean,
      );
    } catch (_) {
      return null;
    }
  }

  // Add new lead
  LeadModel createLead({
    required String name,
    required String phoneNumber,
    required int projectId,
    required int channelId,
    String? employeeId,
    double? budget,
    LeadStatus status = LeadStatus.freshLead,
    TypeLead typeLead = TypeLead.sale,
    String? note,
  }) {
    final cleanPhone = phoneNumber.trim().replaceAll(RegExp(r'\s+'), '');
    final isDup = findDuplicatePhone(cleanPhone) != null;

    final project = _projects.firstWhere((p) => p.id == projectId, orElse: () => _projects.first);
    final channel = _channels.firstWhere((c) => c.id == channelId, orElse: () => _channels.first);
    final employee = employeeId != null ? _employees.firstWhere((e) => e.id == employeeId, orElse: () => _employees.first) : null;

    final newLead = LeadModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name.trim(),
      phoneNumber: cleanPhone,
      projectId: projectId,
      projectName: project.name,
      channelId: channelId,
      channelName: channel.name,
      employeeId: employee?.id,
      employeeName: employee?.name ?? 'غير مسند',
      budget: budget,
      status: status,
      typeLead: typeLead,
      isDuplicated: isDup,
      created: DateTime.now(),
      updated: DateTime.now(),
      assigned: employee != null ? DateTime.now() : null,
      comments: [
        if (note != null && note.trim().isNotEmpty)
          CommentModel(
            id: DateTime.now().millisecondsSinceEpoch,
            comment: note.trim(),
            createdAt: DateTime.now(),
            author: 'المستخدم',
          ),
        CommentModel(
          id: DateTime.now().millisecondsSinceEpoch + 1,
          comment: isDup ? 'تم تسجيل العميل مع رصد تنبيه برقم هاتف مكرر.' : 'تم إضافة العميل بنجاح للمسار.',
          createdAt: DateTime.now(),
          author: 'System',
        ),
      ],
    );

    _leads.insert(0, newLead);
    notifyListeners();
    return newLead;
  }

  // Update lead status
  void updateLeadStatus(int leadId, LeadStatus newStatus, {int? reasonId, String? reasonText}) {
    final index = _leads.indexWhere((l) => l.id == leadId);
    if (index == -1) return;

    final lead = _leads[index];
    lead.status = newStatus;
    lead.updated = DateTime.now();

    if (newStatus == LeadStatus.cancellation) {
      lead.cancellationReasonId = reasonId;
      lead.cancellationReason = reasonText ?? 'تم الإلغاء';
      lead.cancellationDate = DateTime.now();
    } else if (newStatus == LeadStatus.reservation) {
      lead.reservationDate = DateTime.now();
    } else if (newStatus == LeadStatus.orientation) {
      lead.orientationDate = DateTime.now();
    }

    lead.comments.insert(
      0,
      CommentModel(
        id: DateTime.now().millisecondsSinceEpoch,
        comment: 'تم تحديث حالة العميل إلى: ${newStatus.labelAr} ${reasonText != null ? "($reasonText)" : ""}',
        createdAt: DateTime.now(),
        author: 'المستخدم',
      ),
    );

    notifyListeners();
  }

  // Assign sales rep
  void assignSalesRep(int leadId, String employeeId) {
    final index = _leads.indexWhere((l) => l.id == leadId);
    if (index == -1) return;

    final emp = _employees.firstWhere((e) => e.id == employeeId);
    _leads[index].employeeId = emp.id;
    _leads[index].employeeName = emp.name;
    _leads[index].assigned = DateTime.now();
    _leads[index].updated = DateTime.now();

    _leads[index].comments.insert(
      0,
      CommentModel(
        id: DateTime.now().millisecondsSinceEpoch,
        comment: 'تم إسناد العميل إلى مسؤول المبيعات: ${emp.name}',
        createdAt: DateTime.now(),
        author: 'مدير النظام',
      ),
    );

    notifyListeners();
  }

  // Add comment
  void addComment(int leadId, String text, {String author = 'المستخدم'}) {
    final index = _leads.indexWhere((l) => l.id == leadId);
    if (index == -1) return;

    _leads[index].comments.insert(
      0,
      CommentModel(
        id: DateTime.now().millisecondsSinceEpoch,
        comment: text,
        createdAt: DateTime.now(),
        author: author,
      ),
    );
    _leads[index].updated = DateTime.now();
    notifyListeners();
  }

  // Delete lead
  void deleteLead(int leadId) {
    _leads.removeWhere((l) => l.id == leadId);
    notifyListeners();
  }
}
