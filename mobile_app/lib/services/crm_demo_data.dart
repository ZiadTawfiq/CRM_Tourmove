import '../models/crm_enums.dart';
import '../models/crm_models.dart';
import '../models/lead_model.dart';

class CrmDemoData {
  static List<ProjectModel> getProjects() {
    return [
      ProjectModel(id: 1, name: 'كمبوند بالم هيلز التجمع - Palm Hills', location: 'القاهرة الجديدة', startingPrice: 6500000),
      ProjectModel(id: 2, name: 'زد إيست التجمع الخامس - Zed East', location: 'التجمع الخامس', startingPrice: 8200000),
      ProjectModel(id: 3, name: 'ماونتن فيو أي سيتي - Mountain View iCity', location: 'التجمع الخامس', startingPrice: 5400000),
      ProjectModel(id: 4, name: 'سول تاون فيلا فاخرة - Soul Town Villas', location: 'الشيخ زايد', startingPrice: 12500000),
      ProjectModel(id: 5, name: 'أبراج العلمين الشاطئية - North Coast Towers', location: 'الساحل الشمالي', startingPrice: 9800000),
    ];
  }

  static List<ChannelModel> getChannels() {
    return [
      ChannelModel(id: 1, name: 'إعلانات فيسبوك (Facebook Ads)'),
      ChannelModel(id: 2, name: 'إعلانات جوجل (Google Search & Ads)'),
      ChannelModel(id: 3, name: 'توصية وترشيح (Referral)'),
      ChannelModel(id: 4, name: 'زيارة المعرض / المقر (Walk-in)'),
      ChannelModel(id: 5, name: 'الموقع الإلكتروني (Web Form)'),
      ChannelModel(id: 6, name: 'إنستجرام وريلز (Instagram)'),
    ];
  }

  static List<EmployeeModel> getEmployees() {
    return [
      EmployeeModel(id: 'emp-100', name: 'خالد توفيق (مدير النظام)', email: 'khaled@tourmove.com', phone: '+201099887766', role: 1, activeLeads: 2),
      EmployeeModel(id: 'emp-101', name: 'أحمد ممدوح (مسؤول مبيعات)', email: 'ahmed@tourmove.com', phone: '+201011223344', role: 2, activeLeads: 8),
      EmployeeModel(id: 'emp-102', name: 'سارة عبد الرحمن (مسؤولة مبيعات)', email: 'sara@tourmove.com', phone: '+201022334455', role: 2, activeLeads: 12),
      EmployeeModel(id: 'emp-103', name: 'عمر الشناوي (قائد فريق)', email: 'omar@tourmove.com', phone: '+201033445566', role: 3, activeLeads: 5),
      EmployeeModel(id: 'emp-104', name: 'نورهان طارق (مسؤولة تسويق)', email: 'nourhan@tourmove.com', phone: '+201044556677', role: 4, activeLeads: 0),
    ];
  }

  static List<CancellationReasonModel> getCancellationReasons() {
    return [
      CancellationReasonModel(id: 1, reason: 'الميزانية غير ملائمة (Budget Out of Range)'),
      CancellationReasonModel(id: 2, reason: 'الموقع الجغرافي لا يناسب العميل (Location Mismatch)'),
      CancellationReasonModel(id: 3, reason: 'اشترى من كمبوند منافس (Bought from Competitor)'),
      CancellationReasonModel(id: 4, reason: 'تراجع عن قرار الشراء حالياً (Deferred Decision)'),
      CancellationReasonModel(id: 5, reason: 'رقم غير صحيح أو لا يجيب نهائياً (Wrong / No Answer)'),
    ];
  }

  static List<LeadModel> getLeads() {
    final now = DateTime.now();
    return [
      LeadModel(
        id: 1001,
        name: 'م. طارق كمال المنشاوي',
        phoneNumber: '01001234567',
        projectId: 1,
        projectName: 'كمبوند بالم هيلز التجمع - Palm Hills',
        employeeId: 'emp-101',
        employeeName: 'أحمد ممدوح (مسؤول مبيعات)',
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
            employeeId: 'emp-101',
          ),
        ],
      ),
      LeadModel(
        id: 1002,
        name: 'د. منى عبد العزيز العوضي',
        phoneNumber: '01123456789',
        projectId: 2,
        projectName: 'زد إيست التجمع الخامس - Zed East',
        employeeId: 'emp-102',
        employeeName: 'سارة عبد الرحمن (مسؤولة مبيعات)',
        channelId: 2,
        channelName: 'إعلانات جوجل (Google Search & Ads)',
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
            comment: 'تم الاتصال بالعميلة، مهتمة جداً بزد إيست وتطلب جدول أقساط 8 سنوات.',
            createdAt: now.subtract(const Duration(hours: 18)),
            author: 'سارة عبد الرحمن',
            employeeId: 'emp-102',
          ),
          CommentModel(
            id: 3,
            comment: 'تم إرسال بروشور المشروع والأسعار على تطبيق واتساب، بانتظار تحديد موعد المعاينة.',
            createdAt: now.subtract(const Duration(hours: 4)),
            author: 'سارة عبد الرحمن',
            employeeId: 'emp-102',
          ),
        ],
      ),
      LeadModel(
        id: 1003,
        name: 'أ/ شريف حسام الدين',
        phoneNumber: '01234567890',
        projectId: 3,
        projectName: 'ماونتن فيو أي سيتي - Mountain View iCity',
        employeeId: 'emp-101',
        employeeName: 'أحمد ممدوح (مسؤول مبيعات)',
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
            id: 4,
            comment: 'توصية من عميل سابق، تم التنسيق لمقابلة ومعاينة ميدانية في موقع المشروع يوم السبت القادم.',
            createdAt: now.subtract(const Duration(hours: 8)),
            author: 'أحمد ممدوح',
            employeeId: 'emp-101',
          ),
        ],
      ),
      LeadModel(
        id: 1004,
        name: 'م/ ياسمين فاروق المهدي',
        phoneNumber: '01509876543',
        projectId: 4,
        projectName: 'سول تاون فيلا فاخرة - Soul Town Villas',
        employeeId: 'emp-102',
        employeeName: 'سارة عبد الرحمن (مسؤولة مبيعات)',
        channelId: 5,
        channelName: 'الموقع الإلكتروني (Web Form)',
        budget: 14000000,
        status: LeadStatus.reservation,
        typeLead: TypeLead.sale,
        isDuplicated: false,
        created: now.subtract(const Duration(hours: 120)),
        updated: now.subtract(const Duration(hours: 12)),
        reservationDate: now.subtract(const Duration(hours: 12)),
        comments: [
          CommentModel(
            id: 5,
            comment: 'تم توقيع استمارة الحجز ودفع دفعة المقدم لدى الحسابات بنجاح.',
            createdAt: now.subtract(const Duration(hours: 12)),
            author: 'سارة عبد الرحمن',
            employeeId: 'emp-102',
          ),
        ],
      ),
      LeadModel(
        id: 1005,
        name: 'حازم الدسوقي',
        phoneNumber: '01001234567', // Duplicate phone with 1001
        projectId: 5,
        projectName: 'أبراج العلمين الشاطئية - North Coast Towers',
        employeeId: 'emp-103',
        employeeName: 'عمر الشناوي (قائد فريق)',
        channelId: 4,
        channelName: 'زيارة المعرض / المقر (Walk-in)',
        budget: 10500000,
        status: LeadStatus.freshLead,
        typeLead: TypeLead.sale,
        isDuplicated: true,
        created: now.subtract(const Duration(hours: 6)),
        updated: now.subtract(const Duration(hours: 6)),
        comments: [
          CommentModel(
            id: 6,
            comment: 'تنبيه أمان: تم رصد رقم هاتف مكرر مسجل مسبقاً لدى العميل م. طارق كمال (مسند إلى أحمد ممدوح). تم إرسال طلب مراجعة.',
            createdAt: now.subtract(const Duration(hours: 6)),
            author: 'LeadDuplicateService',
            employeeId: 'emp-103',
          ),
        ],
      ),
      LeadModel(
        id: 1006,
        name: 'أ/ ماجد حسني ناصف',
        phoneNumber: '01287654321',
        projectId: 3,
        projectName: 'ماونتن فيو أي سيتي - Mountain View iCity',
        employeeId: 'emp-101',
        employeeName: 'أحمد ممدوح (مسؤول مبيعات)',
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
            id: 7,
            comment: 'تم تحويل الطلب للإلغاء عبر CancellationStatusHandler لعدم ملائمة الأسعار لميزانيته الحالية.',
            createdAt: now.subtract(const Duration(hours: 18)),
            author: 'أحمد ممدوح',
            employeeId: 'emp-101',
          ),
        ],
      ),
    ];
  }

  static List<LeadDuplicateRecord> getDuplicateRecords() {
    final now = DateTime.now();
    return [
      LeadDuplicateRecord(
        id: 1,
        leadId: 1001,
        leadName: 'م. طارق كمال المنشاوي',
        phoneNumber: '01001234567',
        projectId: 5,
        projectName: 'أبراج العلمين الشاطئية - North Coast Towers',
        originalSalesRepId: 'emp-101',
        originalSalesRepName: 'أحمد ممدوح',
        attemptedByEmployeeId: 'emp-103',
        attemptedByEmployeeName: 'عمر الشناوي',
        createdAt: now.subtract(const Duration(hours: 6)),
        status: DuplicateStatus.pending,
      ),
    ];
  }
}

