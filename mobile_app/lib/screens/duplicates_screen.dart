import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../models/crm_enums.dart';
import '../models/crm_models.dart';
import '../services/crm_repository.dart';

class DuplicatesScreen extends StatefulWidget {
  const DuplicatesScreen({Key? key}) : super(key: key);

  @override
  State<DuplicatesScreen> createState() => _DuplicatesScreenState();
}

class _DuplicatesScreenState extends State<DuplicatesScreen> {
  final CrmRepository _repo = CrmRepository();

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  void _showResolveDialog(LeadDuplicateRecord record) {
    String selectedRepId = record.attemptedByEmployeeId;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollable: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.security, color: Colors.red),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'معالجة تكرار العميل (Duplicate Strategy)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'اختيار نمط الإجراء المعتمد في نظام CRM',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('اسم العميل: ${record.leadName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('رقم الهاتف: ${record.phoneNumber}'),
                        Text('المسؤول الأصلي: ${record.originalSalesRepName}'),
                        Text('المسؤول الراغب بالتسجيل: ${record.attemptedByEmployeeName}'),
                        Text('المشروع المطلوب: ${record.projectName}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('إسناد إلى المندوب:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedRepId,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: _repo.employees.map((emp) {
                      return DropdownMenuItem(
                        value: emp.id,
                        child: Text('${emp.name} (${emp.employeeRole.title.split(' ').first})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedRepId = val);
                    },
                  ),
                  const SizedBox(height: 20),
                  // Strategy 1: Reassign
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text(
                      'استراتيجية 1: إعادة إسناد العميل الأصلي (Reassign)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await _repo.reviewDuplicateLead(
                        recordId: record.id,
                        action: DuplicateAction.reassignToAnotherSalesRep,
                        newSalesRepId: selectedRepId,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تنفيذ ReassignLeadHandler وإعادة إسناد العميل بنجاح.'),
                            backgroundColor: Color(0xFF3B82F6),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  // Strategy 2: Create Separate Lead
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF10B981),
                      side: const BorderSide(color: Color(0xFF10B981), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text(
                      'استراتيجية 2: إنشاء عميل جديد منفصل (Create New)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await _repo.reviewDuplicateLead(
                        recordId: record.id,
                        action: DuplicateAction.createNewLead,
                        newSalesRepId: selectedRepId,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تنفيذ CreateNewleadHandelr وإنشاء عميل جديد بالمشروع بنجاح.'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duplicates = _repo.duplicateRecords;
    final dateFmt = intl.DateFormat('dd/MM/yyyy HH:mm', 'ar');

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة التكرار (Lead Duplication)'),
      ),
      body: duplicates.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user, size: 64, color: Colors.green.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text('لا توجد حالات تكرار معلقة حالياً', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text('نظام الكشف التلقائي يفحص أرقام الهواتف لحظياً.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: duplicates.length,
              itemBuilder: (context, index) {
                final rec = duplicates[index];
                final isPending = rec.status == DuplicateStatus.pending;

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isPending ? Colors.red.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
                      width: isPending ? 1.5 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: rec.status.color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                rec.status.labelAr,
                                style: TextStyle(
                                  color: rec.status.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              dateFmt.format(rec.createdAt),
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          rec.leadName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(rec.phoneNumber, style: const TextStyle(fontFamily: 'monospace')),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.business, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(child: Text(rec.projectName, style: const TextStyle(color: Colors.grey))),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('المسؤول الأصلي:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  Text(rec.originalSalesRepName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('المحاولة بواسطة:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  Text(rec.attemptedByEmployeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (isPending) ...[
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.rule, size: 18),
                              label: const Text('مراجعة واتخاذ إجراء (Review Strategy)'),
                              onPressed: () => _showResolveDialog(rec),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

