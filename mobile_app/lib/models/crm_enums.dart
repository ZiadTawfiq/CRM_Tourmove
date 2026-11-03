import 'package:flutter/material.dart';

enum LeadStatus {
  freshLead(1, 'عميل جديد', 'Fresh Lead', Color(0xFF3B82F6), Color(0x1E3B82F6)),
  followUp(2, 'متابعة', 'Follow-Up', Color(0xFFF59E0B), Color(0x1EF59E0B)),
  cancellation(3, 'ملغي', 'Cancellation', Color(0xFFEF4444), Color(0x1EEF4444)),
  reservation(4, 'حجز مؤكد', 'Reservation', Color(0xFF10B981), Color(0x2210B981)),
  orientation(5, 'معاينة / مقابلة', 'Orientation', Color(0xFF8B5CF6), Color(0x1E8B5CF6));

  final int id;
  final String labelAr;
  final String labelEn;
  final Color color;
  final Color bgColor;

  const LeadStatus(this.id, this.labelAr, this.labelEn, this.color, this.bgColor);

  static LeadStatus fromId(int? id) {
    return LeadStatus.values.firstWhere(
      (s) => s.id == id,
      orElse: () => LeadStatus.freshLead,
    );
  }
}

enum TypeLead {
  rent(1, 'إيجار', 'Rent', Color(0xFF06B6D4)),
  sale(2, 'شراء / بيع', 'Sale', Color(0xFF4F46E5));

  final int id;
  final String labelAr;
  final String labelEn;
  final Color color;

  const TypeLead(this.id, this.labelAr, this.labelEn, this.color);

  static TypeLead fromId(int? id) {
    return TypeLead.values.firstWhere(
      (t) => t.id == id,
      orElse: () => TypeLead.sale,
    );
  }
}

enum EmployeeRole {
  admin(1, 'مدير النظام (Admin)'),
  salesRep(2, 'مسؤول مبيعات (Sales Rep)'),
  teamLeader(3, 'قائد فريق (Team Leader)'),
  marketer(4, 'مسؤول تسويق (Marketer)');

  final int id;
  final String title;

  const EmployeeRole(this.id, this.title);

  static EmployeeRole fromId(int? id) {
    return EmployeeRole.values.firstWhere(
      (r) => r.id == id,
      orElse: () => EmployeeRole.salesRep,
    );
  }
}
