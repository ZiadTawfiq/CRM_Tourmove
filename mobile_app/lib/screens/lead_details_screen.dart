import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' as intl;
import '../models/crm_enums.dart';
import '../models/lead_model.dart';
import '../services/crm_repository.dart';
import '../widgets/status_badge.dart';

class LeadDetailsScreen extends StatefulWidget {
  final LeadModel lead;

  const LeadDetailsScreen({Key? key, required this.lead}) : super(key: key);

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  final CrmRepository _repo = CrmRepository();
  final TextEditingController _commentCtrl = TextEditingController();
  late LeadModel _lead;

  final List<Map<String, dynamic>> _cancellationReasons = [
    {'id': 1, 'reason': 'الميزانية غير ملائمة (Budget Out of Range)'},
    {'id': 2, 'reason': 'الموقع الجغرافي لا يناسب العميل (Location Mismatch)'},
    {'id': 3, 'reason': 'اشترى من منافس آخر (Bought from Competitor)'},
    {'id': 4, 'reason': 'تراجع عن قرار الشراء حالياً (Deferred Decision)'},
    {'id': 5, 'reason': 'رقم غير صحيح أو لا يجيب نهائياً (Wrong / No Answer)'},
  ];

  @override
  void initState() {
    super.initState();
    _lead = widget.lead;
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    try {
      final updated = _repo.leads.firstWhere((l) => l.id == _lead.id);
      if (mounted) setState(() => _lead = updated);
    } catch (_) {}
  }

  void _makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _openWhatsApp(String phoneNumber, String name) async {
    String clean = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    if (clean.startsWith('0')) clean = '+20${clean.substring(1)}';
    final uri = Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent("مرحباً $name")}');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showCancellationDialog() {
    int selectedReasonId = 1;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 22),
              SizedBox(width: 8),
              Text('تحديد سبب الإلغاء', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('يرجى اختيار سبب الإلغاء لتوثيق تقرير المبيعات:', style: TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: selectedReasonId,
                isExpanded: true,
                items: _cancellationReasons.map((r) {
                  return DropdownMenuItem<int>(
                    value: r['id'] as int,
                    child: Text(r['reason'] as String, style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedReasonId = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('رجوع'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                final reasonObj = _cancellationReasons.firstWhere((r) => r['id'] == selectedReasonId);
                _repo.updateLeadStatus(
                  _lead.id,
                  LeadStatus.cancellation,
                  reasonId: selectedReasonId,
                  reasonText: reasonObj['reason'] as String,
                );
                Navigator.pop(ctx);
              },
              child: const Text('تأكيد الإلغاء'),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'تحديث مرحلة العميل',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            ...LeadStatus.values.map((s) {
              return ListTile(
                leading: CircleAvatar(radius: 6, backgroundColor: s.color),
                title: Text(s.labelAr, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: _lead.status == s ? Icon(Icons.check, color: s.color) : null,
                onTap: () {
                  Navigator.pop(ctx);
                  if (s == LeadStatus.cancellation) {
                    _showCancellationDialog();
                  } else {
                    _repo.updateLeadStatus(_lead.id, s);
                  }
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showAssignPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'إسناد العميل لمسؤول مبيعات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            ..._repo.employees.map((emp) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  child: Text(emp.name[0]),
                ),
                title: Text(emp.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(emp.phone, textDirection: TextDirection.ltr),
                trailing: _lead.employeeId == emp.id
                    ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                    : null,
                onTap: () {
                  _repo.assignSalesRep(_lead.id, emp.id);
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _addComment() {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;
    _repo.addComment(_lead.id, text, author: 'خالد توفيق (المستخدم)');
    _commentCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_lead.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'حذف العميل',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('تأكيد الحذف'),
                  content: Text('هل أنت متأكد من رغبتك في حذف العميل "${_lead.name}"؟'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        _repo.deleteLead(_lead.id);
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      child: const Text('حذف'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Duplicate warning if any
            if (_lead.isDuplicated)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'تنبيه: تم رصد رقم هاتف مكرر مسجل في النظام مسبقاً!',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            // Main Info Card
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusBadge(status: _lead.status),
                        TypeLeadBadge(type: _lead.typeLead),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _lead.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'رقم الهاتف: ${_lead.phoneNumber}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textDirection: TextDirection.ltr,
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.phone, size: 18),
                            label: const Text('اتصال مباشر'),
                            onPressed: () => _makePhoneCall(_lead.phoneNumber),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.chat_bubble_outline, size: 18),
                            label: const Text('واتساب'),
                            onPressed: () => _openWhatsApp(_lead.phoneNumber, _lead.name),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Status & Sales Rep Quick Setters
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.stairs_outlined, color: Colors.blue),
                    title: const Text('المرحلة في المسار', style: TextStyle(fontSize: 13)),
                    subtitle: Text(_lead.status.labelAr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: _showStatusPicker,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.person_pin_outlined, color: Colors.purple),
                    title: const Text('مسؤول المبيعات المسند', style: TextStyle(fontSize: 13)),
                    subtitle: Text(_lead.employeeName ?? 'غير مسند', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: _showAssignPicker,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.business_outlined, color: Colors.indigo),
                    title: const Text('المشروع العقاري', style: TextStyle(fontSize: 13)),
                    subtitle: Text(_lead.projectName ?? 'مشروع عام', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  if (_lead.budget != null) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.monetization_on_outlined, color: Colors.amber),
                      title: const Text('الميزانية المقدرة', style: TextStyle(fontSize: 13)),
                      subtitle: Text('${_lead.budget!.toStringAsFixed(0)} ج.م', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ],
                  if (_lead.status == LeadStatus.cancellation && _lead.cancellationReason != null) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.cancel_outlined, color: Colors.red),
                      title: const Text('سبب الإلغاء المسجل', style: TextStyle(fontSize: 13, color: Colors.red)),
                      subtitle: Text(_lead.cancellationReason!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Timeline / Comments Section
            const Text(
              'سجل الملاحظات والمتابعات',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Add note box
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentCtrl,
                    decoration: const InputDecoration(
                      hintText: 'أضف ملاحظة أو نتيجة اتصال...',
                      hintStyle: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addComment,
                  icon: const Icon(Icons.send),
                  tooltip: 'إرسال',
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Comments List
            if (_lead.comments.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('لا توجد ملاحظات مسجلة بعد لهذا العميل', style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _lead.comments.length,
                itemBuilder: (context, index) {
                  final c = _lead.comments[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              c.author,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              intl.DateFormat('yyyy/MM/dd - hh:mm a').format(c.createdAt),
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                              textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          c.comment,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[200] : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
