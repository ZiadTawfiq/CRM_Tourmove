import 'package:flutter/material.dart';
import '../models/crm_enums.dart';

class StatusBadge extends StatelessWidget {
  final LeadStatus status;
  final bool isSmall;

  const StatusBadge({
    Key? key,
    required this.status,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: status.bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withOpacity(0.35)),
      ),
      child: Text(
        status.labelAr,
        style: TextStyle(
          color: status.color,
          fontSize: isSmall ? 11 : 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class TypeLeadBadge extends StatelessWidget {
  final TypeLead type;

  const TypeLeadBadge({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: type.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: type.color.withOpacity(0.3)),
      ),
      child: Text(
        type.labelAr,
        style: TextStyle(
          color: type.color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
