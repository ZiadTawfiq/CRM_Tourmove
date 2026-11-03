export const STATUS = {
  FreshLead: 1,
  FollowUp: 2,
  Cancellation: 3,
  Reservation: 4,
  Orientation: 5,
};

export const STATUS_META = {
  [STATUS.FreshLead]: {
    id: STATUS.FreshLead,
    key: 'FreshLead',
    labelAr: 'عميل جديد (Fresh)',
    labelEn: 'Fresh Lead',
    color: '#3b82f6',
    bgColor: 'rgba(59, 130, 246, 0.12)',
    badgeClass: 'badge-fresh',
    description: 'عميل مسجل جديد لم يتم التواصل معه بعد'
  },
  [STATUS.FollowUp]: {
    id: STATUS.FollowUp,
    key: 'FollowUp',
    labelAr: 'متابعة (Follow-Up)',
    labelEn: 'Follow-Up',
    color: '#f59e0b',
    bgColor: 'rgba(245, 158, 11, 0.12)',
    badgeClass: 'badge-followup',
    description: 'تم التواصل وجاري المتابعة وتقديم العروض'
  },
  [STATUS.Orientation]: {
    id: STATUS.Orientation,
    key: 'Orientation',
    labelAr: 'معاينة / مقابلة (Orientation)',
    labelEn: 'Orientation',
    color: '#8b5cf6',
    bgColor: 'rgba(139, 92, 246, 0.12)',
    badgeClass: 'badge-orientation',
    description: 'تم تحديد موعد زيارة للموقع أو اجتماع تفصيلي'
  },
  [STATUS.Reservation]: {
    id: STATUS.Reservation,
    key: 'Reservation',
    labelAr: 'حجز مؤكد (Reservation)',
    labelEn: 'Reservation',
    color: '#10b981',
    bgColor: 'rgba(16, 185, 129, 0.15)',
    badgeClass: 'badge-reservation',
    description: 'تم دفع الحجز وتأكيد الصفقة بنجاح'
  },
  [STATUS.Cancellation]: {
    id: STATUS.Cancellation,
    key: 'Cancellation',
    labelAr: 'ملغي (Cancellation)',
    labelEn: 'Cancellation',
    color: '#ef4444',
    bgColor: 'rgba(239, 68, 68, 0.12)',
    badgeClass: 'badge-cancellation',
    description: 'تم إلغاء الطلب مع ذكر سبب الإلغاء'
  },
};

export const TYPE_LEAD = {
  Rent: 1,
  Sale: 2,
};

export const TYPE_LEAD_META = {
  [TYPE_LEAD.Sale]: {
    id: TYPE_LEAD.Sale,
    key: 'Sale',
    labelAr: 'شراء / بيع (Sale)',
    labelEn: 'Sale',
    badgeClass: 'badge-type-sale'
  },
  [TYPE_LEAD.Rent]: {
    id: TYPE_LEAD.Rent,
    key: 'Rent',
    labelAr: 'إيجار (Rent)',
    labelEn: 'Rent',
    badgeClass: 'badge-type-rent'
  }
};

export const ROLES = {
  Admin: 1,
  SalesRep: 2,
  TeamLeader: 3,
  Marketer: 4,
};

export const ROLE_LABELS = {
  [ROLES.Admin]: 'مدير النظام (Admin)',
  [ROLES.SalesRep]: 'مسؤول مبيعات (Sales Rep)',
  [ROLES.TeamLeader]: 'قائد فريق (Team Leader)',
  [ROLES.Marketer]: 'مسؤول تسويق (Marketer)',
};

export const CANCELLATION_REASONS = [
  { id: 1, reason: 'الميزانية غير ملائمة (Budget Out of Range)' },
  { id: 2, reason: 'الموقع الجغرافي لا يناسب العميل (Location Mismatch)' },
  { id: 3, reason: 'اشترى من منافس آخر (Bought from Competitor)' },
  { id: 4, reason: 'تراجع عن قرار الشراء في الوقت الحالي (Deferred Decision)' },
  { id: 5, reason: 'رقم غير صحيح أو لا يجيب نهائياً (Wrong / No Answer)' },
  { id: 6, reason: 'مواصفات العقار غير مناسبة (Property Spec Mismatch)' },
];
