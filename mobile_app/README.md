# Tourmove CRM - Mobile Application (Flutter) 📱

تطبيق جوال متكامل بنظام **Flutter (Cross-Platform)** لإدارة علاقات العملاء (CRM) ومتابعة مسار مبيعات الشركات العقارية (Real Estate Sales Pipeline)، مبني بتطابق تام 100% مع نماذج الباك إند (.NET C# Core).

---

## 🚀 المميزات الرئيسية للتطبيق (Features)

1. **مسار المبيعات التفاعلي (Sales Pipeline):**
   - استعراض مراحل البيع مع عدادات ومجموع الميزانيات لكل مرحلة:
     - `FreshLead (1)`: عميل مسجل جديد.
     - `FollowUp (2)`: جاري المتابعة والتواصل.
     - `Orientation (5)`: معاينة ميدانية أو اجتماع.
     - `Reservation (4)`: حجز مؤكد ومبيعات ناجحة.
     - `Cancellation (3)`: طلب ملغي مع تحديد سبب الإلغاء.

2. **التواصل السريع بنقرة واحدة (1-Tap Contact):**
   - زر اتصال هاتفي فوري عبر تطبيق الهاتف الافتراضي.
   - زر مراسلة فورية عبر **WhatsApp** مع نص محادثة مجهز تلقائياً باسم العميل.

3. **نظام كشف الأرقام المكررة (Duplicate Lead Alert):**
   - تنبيه لحظي عند كتابة رقم هاتف مسجل مسبقاً لأي عميل في النظام لحماية مندوبي المبيعات من تكرار تسجيل نفس العميل.

4. **إدارة تفاصيل العميل والملاحظات (Lead Details & Activity Log):**
   - تغيير مرحلة العميل مع فتح نافذة أسباب الإلغاء في حال اختيار الإلغاء (`CancellationReason`).
   - إسناد العميل لمسؤول مبيعات آخر (`Assign Sales Rep`).
   - إضافة وقراءة الملاحظات ومحاضر الاتصال بشكل تسلسلي زمني (**Timeline**).

5. **المشاريع العقارية (Projects Catalog):**
   - عرض أسعار البداية، الموقع الجغرافي، وإجمالي ميزانيات العملاء المهتمين بكل كمبوند/مشروع.

6. **التحليلات ومعدلات التحويل (Analytics & KPIs):**
   - حساب معدل التحويل المئوي (`Conversion Rate %`).
   - نسب مراحل المسار.
   - توزيع وإنجاز مسؤولي المبيعات.

---

## 📁 هيكلية المشروع (Project Architecture)

```
mobile_app/
├── pubspec.yaml
├── README.md
└── lib/
    ├── main.dart
    ├── models/
    │   ├── crm_enums.dart       # مطابقة enums الـ Backend (Status, TypeLead, Role)
    │   ├── crm_models.dart      # نماذج Comment, Project, Channel, Employee
    │   └── lead_model.dart      # نموذج العميل Lead كامل الخصائص
    ├── services/
    │   └── crm_repository.dart  # طبقة البيانات وإدارة الحالة وكشف التكرار
    ├── theme/
    │   └── app_theme.dart       # نظام التصميم (Dark & Light) والألوان
    ├── widgets/
    │   ├── status_badge.dart    # شارات المراحل الملونة
    │   └── lead_card.dart       # بطاقة العميل التفاعلية
    └── screens/
        ├── home_navigation_screen.dart # شريط التنقل السفلي المطور
        ├── pipeline_screen.dart        # شاشة مسار المبيعات التفاعلية
        ├── leads_list_screen.dart      # دليل العملاء والبحث والفلاتر
        ├── lead_details_screen.dart    # شاشة تفاصيل وملاحظات العميل
        ├── create_lead_screen.dart     # نموذج إضافة عميل جديد
        ├── projects_screen.dart        # دليل المشاريع العقارية
        └── analytics_screen.dart       # شاشة التحليلات والتقارير
```

---

## 🛠️ كيفية تشغيل التطبيق (How to Run)

عند تثبيت حزمة **Flutter SDK** على جهازك، يمكنك تشغيل التطبيق بالأمر:

```bash
cd mobile_app
flutter pub get
flutter run
```
