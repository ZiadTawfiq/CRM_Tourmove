# Tourmove CRM - Mobile Application (Flutter) 📱

تطبيق جوال متكامل بنظام **Flutter (Cross-Platform)** لإدارة علاقات العملاء (CRM) ومتابعة مسار مبيعات الشركات العقارية (Real Estate Sales Pipeline)، مبني بتطابق تام ومكتمل مع كافة الخدمات والبنية التحتية البرمجية للباك إند (.NET C# Core Services & Handlers).

---

## 🏛️ طبقة الخدمات المتكاملة (Integrated Services Architecture)

تم بناء التطبيق على هيكل خدمات معياري يطابق واجهات الباك إند (.NET Core Services) بدقة 100% مع دعم وضعين للتشغيل:
1. **وضع العرض التجريبي الفوري (Demo Mode / Offline Mock)**: محمل مسبقاً ببيانات واقعية من السوق العقاري المصري، ويتيح تجربة وفحص كافة السيناريوهات مباشرة دون الحاجة لأي إعدادات خارجية.
2. **وضع الاتصال المباشر (Live Backend API Mode)**: يتصل بالخادم ASP.NET Core Web API عبر JWT Bearer Authentication وHTTP REST endpoints.

| الخدمة في Flutter | الواجهة المطابقة في الباك إند (.NET) | الوظيفة والمسؤولية |
|---|---|---|
| `AuthService` | `IAuthService` / `TokenService` | تسجيل الدخول، إدارة توكن الـ JWT، صلاحيات الأدوار (Admin, Sales Rep, Team Leader) والتبديل السريع بين الحسابات. |
| `LeadService` | `ILeadService` / `LeadService` | عمليات CRUD، تحويل المراحل، إسناد العملاء لمسؤولي المبيعات، البحث برقم الهاتف والفلترة المتقدمة. |
| `LeadDuplicateService` | `IleadDuplicateService` & `LeadDuplicationHandler` | كشف تكرار أرقام الهواتف لحظياً، وتنفيذ الـ Strategy Pattern: `ReassignLeadHandler` و `CreateNewleadHandelr`. |
| `ProjectService` | `IProjectService` / `ProjectService` | استعراض وإضافة المشاريع والكمبوندات العقارية، أسعار البداية وإجمالي ميزانيات العملاء المهتمين. |
| `ChannelService` | `IChannelService` / `ChannelService` | إدارة قنوات التسويق (Facebook, Google Ads, Referral, Walk-in, Website, Instagram). |
| `EmployeeService` | `IEmployeeService` / `EmployeeService` | دليل فريق المبيعات، الأدوار والصلاحيات، وإحصائيات العملاء النشطين لكل موظف. |
| `CommentService` | `ICommentService` / `CommentService` | تسجيل الملاحظات ومحاضر الاتصال في الخط الزمني (Timeline) لكل عميل. |
| `CrmRepository` | State Management & Coordinator | المركز الرئيسي لإدارة الحالة (ChangeNotifier) والتنسيق اللحظي بين كافة الخدمات وواجهات المستخدم. |
| `ApiClient` & `ApiConfig` | HTTP Networking Layer | عميل HTTP متكامل يتولى الـ Headers، التوكن، والـ Timeout والتبديل بين عناوين الخادم (Localhost / Android Emulator). |

---

## 🚀 شاشات ومميزات التطبيق (Screens & Features)

1. **شاشة الدخول (Login Screen):**
   - واجهة دخول أنيقة مع خاصية **الدخول السريع بنقرة واحدة (1-Tap Demo Login)** لتجربة النظام كمدير، أو مندوب مبيعات، أو قائد فريق.

2. **مسار المبيعات التفاعلي (Sales Pipeline):**
   - تبويبات لمراحل البيع الخمس:
     - `FreshLead (1)`: عميل مسجل جديد.
     - `FollowUp (2)`: جاري المتابعة والتواصل.
     - `Orientation (5)`: معاينة ميدانية أو اجتماع مع تسجيل الموعد.
     - `Reservation (4)`: حجز مؤكد ومبيعات ناجحة مع تاريخ الحجز.
     - `Cancellation (3)`: طلب ملغي مع تحديد سبب الإلغاء (`CancellationReason`).

3. **شاشة إدارة التكرار (Lead Duplication Strategy Screen):**
   - شاشة متخصصة تبرز عمل الـ **Strategy Pattern** المعتمد في الباك إند:
     - 🔄 **ReassignLeadHandler**: إعادة إسناد العميل الأصلي لمسؤول مبيعات جديد وتحديث الخط الزمني.
     - ➕ **CreateNewleadHandelr**: إنشاء عميل جديد مستقل بالمشروع المطلوب مع الحفاظ على سجل العميل السابق.

4. **التواصل السريع بنقرة واحدة (1-Tap Contact):**
   - زر اتصال هاتفي فوري عبر تطبيق الهاتف.
   - زر مراسلة فورية عبر **WhatsApp** بنص محادثة مجهز تلقائياً باسم العميل.

5. **إضافة عميل مع فحص التكرار اللحظي (Duplicate Alert):**
   - تنبيه فوري يظهر أثناء كتابة رقم الهاتف إذا كان مسجلاً مسبقاً، لحماية مندوبي المبيعات من النزاعات.

6. **شاشة الإعدادات ووضع النظام (Settings & API Config Screen):**
   - التبديل بنقرة واحدة بين **Demo Mode** و **Live API Mode**.
   - تغيير واختبار رابط الخادم (Test Connectivity).
   - إعادة تعيين البيانات الافتراضية (Reset Demo Data).

---

## 📁 هيكلية مجلدات المشروع (Project Structure)

```
mobile_app/
├── pubspec.yaml
├── README.md
└── lib/
    ├── main.dart
    ├── models/
    │   ├── crm_enums.dart          # مطابقة كاملة للـ Enums (Status, DuplicateAction, DuplicateStatus, Role)
    │   ├── crm_models.dart         # نماذج Comment, Project, Channel, Employee, DuplicateRecord
    │   └── lead_model.dart         # نموذج العميل Lead كامل الخصائص
    ├── services/
    │   ├── api_config.dart         # تكوين الـ API وعناوين الخادم
    │   ├── api_client.dart         # عميل الاتصال الشبكي HTTP
    │   ├── auth_service.dart       # خدمة المصادقة وتوكن JWT
    │   ├── lead_service.dart       # خدمة إدارة العملاء والمسار
    │   ├── lead_duplicate_service.dart # خدمة كشف ومعالجة التكرار بالـ Strategy Pattern
    │   ├── project_service.dart    # خدمة المشاريع العقارية
    │   ├── channel_service.dart    # خدمة قنوات التسويق
    │   ├── employee_service.dart   # خدمة الموظفين وفريق المبيعات
    │   ├── comment_service.dart    # خدمة الملاحظات والـ Timeline
    │   ├── crm_demo_data.dart      # البيانات الافتراضية المصرية للعرض التجريبي
    │   └── crm_repository.dart     # مستودع إدارة الحالة الرئيسي (ChangeNotifier)
    ├── theme/
    │   └── app_theme.dart          # نظام التصميم والألوان الداعمة للعربية
    ├── widgets/
    │   ├── status_badge.dart       # شارات الحالات
    │   └── lead_card.dart          # بطاقة العميل مع أزرار الاتصال والواتساب
    └── screens/
        ├── login_screen.dart       # شاشة تسجيل الدخول
        ├── home_navigation_screen.dart # شريط التنقل السفلي والـ AppBar
        ├── pipeline_screen.dart    # شاشة مسار المبيعات التفاعلية
        ├── leads_list_screen.dart  # دليل العملاء والبحث
        ├── duplicates_screen.dart  # شاشة مراجعة حالات التكرار وتطبيق الاستراتيجيات
        ├── lead_details_screen.dart# تفاصيل العميل والملاحظات ومراحل البيع
        ├── create_lead_screen.dart # نموذج إضافة عميل جديد مع كشف التكرار
        ├── projects_screen.dart    # دليل المشاريع العقارية
        ├── analytics_screen.dart   # التحليلات ومعدلات التحويل
        └── settings_screen.dart    # إعدادات النظام وعنوان الخادم
```

---

## 🛠️ كيفية تشغيل التطبيق (How to Run)

### 1. عبر حزمة Flutter SDK:
```bash
cd mobile_app
flutter pub get
flutter run
```

### 2. تجربة المحاكي التفاعلي الفوري (Interactive Web Demo Simulator):
يمكن لأي عضو في الفريق فتح نسخة العرض التجريبية التفاعلية مباشرة في المتصفح عبر تطبيق الويب:
```bash
cd frontend
npm run dev
```
ثم التبديل إلى تبويب **📱 محاكي فلاتر (Flutter Demo)** من القائمة الجانبية لتجربة كافة مميزات تطبيق الجوال بنظام إطار الهاتف الحقيقي!
