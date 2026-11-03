import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/lead_model.dart';
import 'status_badge.dart';

class LeadCard extends StatelessWidget {
  final LeadModel lead;
  final VoidCallback onTap;

  const LeadCard({
    Key? key,
    required this.lead,
    required this.onTap,
  }) : super(key: key);

  String _formatBudget(double? budget) {
    if (budget == null || budget == 0) return 'غير محدد';
    if (budget >= 1000000) {
      return '${(budget / 1000000).toStringAsFixed(1)} مليون ج.م';
    }
    return '${budget.toInt().toString()} ج.م';
  }

  void _makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openWhatsApp(String phoneNumber, String name) async {
    String clean = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    if (clean.startsWith('0')) {
      clean = '+20${clean.substring(1)}';
    }
    final encodedMsg = Uri.encodeComponent('مرحباً $name، بخصوص استفسارك عن العقار...');
    final uri = Uri.parse('https://wa.me/$clean?text=$encodedMsg');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Name, Status & Duplicate Alert
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (lead.isDuplicated)
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.red.withOpacity(0.4)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.warning_amber_rounded, size: 13, color: Colors.red),
                                SizedBox(width: 4),
                                Text(
                                  'رقم هاتف مكرر مسجل مسبقاً',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Text(
                          lead.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusBadge(status: lead.status, isSmall: true),
                      const SizedBox(height: 4),
                      TypeLeadBadge(type: lead.typeLead),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Project & Budget Info
              Row(
                children: [
                  Icon(Icons.business_outlined, size: 15, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      lead.projectName ?? 'مشروع عام',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[300] : const Color(0xFF475569),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _formatBudget(lead.budget),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // Bottom Actions: Sales Rep & Direct Call/WhatsApp
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  // Sales Rep info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                        child: Text(
                          lead.employeeName?.isNotEmpty == true ? lead.employeeName![0] : '؟',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        lead.employeeName ?? 'غير مسند',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  // Call & WhatsApp quick icon buttons
                  Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.phone, size: 18, color: Colors.blue),
                        onPressed: () => _makePhoneCall(lead.phoneNumber),
                        tooltip: 'اتصال هاتفي',
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.chat_bubble_outline, size: 18, color: Color(0xFF10B981)),
                        onPressed: () => _openWhatsApp(lead.phoneNumber, lead.name),
                        tooltip: 'واتساب',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
