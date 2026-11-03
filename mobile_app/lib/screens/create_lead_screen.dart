import 'package:flutter/material.dart';
import '../models/crm_enums.dart';
import '../services/crm_repository.dart';

class CreateLeadScreen extends StatefulWidget {
  const CreateLeadScreen({Key? key}) : super(key: key);

  @override
  State<CreateLeadScreen> createState() => _CreateLeadScreenState();
}

class _CreateLeadScreenState extends State<CreateLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  final CrmRepository _repo = CrmRepository();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _budgetCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  late int _selectedProjectId;
  late int _selectedChannelId;
  String? _selectedEmployeeId;
  TypeLead _selectedType = TypeLead.sale;
  String? _duplicateWarning;

  @override
  void initState() {
    super.initState();
    _selectedProjectId = _repo.projects.isNotEmpty ? _repo.projects.first.id : 1;
    _selectedChannelId = _repo.channels.isNotEmpty ? _repo.channels.first.id : 1;

    _phoneCtrl.addListener(_checkDuplicatePhone);
  }

  @override
  void dispose() {
    _phoneCtrl.removeListener(_checkDuplicatePhone);
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _budgetCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _checkDuplicatePhone() {
    final phone = _phoneCtrl.text.trim();
    final dup = _repo.findDuplicatePhone(phone);
    setState(() {
      if (dup != null) {
        _duplicateWarning = 'تنبيه: هذا الرقم مسجل بالفعل للعميل (${dup.name}) في مشروع (${dup.projectName})!';
      } else {
        _duplicateWarning = null;
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final budgetVal = double.tryParse(_budgetCtrl.text.trim());

    _repo.createLead(
      name: _nameCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      projectId: _selectedProjectId,
      channelId: _selectedChannelId,
      employeeId: _selectedEmployeeId,
      budget: budgetVal,
      typeLead: _selectedType,
      note: _noteCtrl.text.trim().isNotEmpty ? _noteCtrl.text.trim() : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تسجيل العميل بنجاح في مسار المبيعات'),
        backgroundColor: Color(0xFF10B981),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة عميل جديد'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Live Duplicate Alert Banner
              if (_duplicateWarning != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _duplicateWarning!,
                          style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

              // Customer Name
              const Text('اسم العميل *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  hintText: 'مثال: م. طارق كمال',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'يرجى إدخال اسم العميل';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Phone Number
              const Text('رقم الهاتف *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(
                  hintText: '01012345678',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'يرجى إدخال رقم الهاتف';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Project
              const Text('المشروع العقاري *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<int>(
                value: _selectedProjectId,
                isExpanded: true,
                items: _repo.projects.map((p) {
                  return DropdownMenuItem<int>(
                    value: p.id,
                    child: Text(p.name, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedProjectId = val);
                },
              ),

              const SizedBox(height: 16),

              // Channel (Source)
              const Text('قناة الاستقطاب (Marketing Channel)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<int>(
                value: _selectedChannelId,
                isExpanded: true,
                items: _repo.channels.map((c) {
                  return DropdownMenuItem<int>(
                    value: c.id,
                    child: Text(c.name, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedChannelId = val);
                },
              ),

              const SizedBox(height: 16),

              // Type (Sale / Rent)
              const Text('نوع الطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('شراء (Sale)')),
                      selected: _selectedType == TypeLead.sale,
                      selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedType = TypeLead.sale);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('إيجار (Rent)')),
                      selected: _selectedType == TypeLead.rent,
                      selectedColor: const Color(0xFF06B6D4).withOpacity(0.2),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedType = TypeLead.rent);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Budget
              const Text('الميزانية المقترحة (ج.م)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _budgetCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'مثال: 5000000',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
              ),

              const SizedBox(height: 16),

              // Sales Rep
              const Text('إسناد إلى مسؤول مبيعات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String?>(
                value: _selectedEmployeeId,
                isExpanded: true,
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('بدون إسناد حالياً (غير مسند)', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ),
                  ..._repo.employees.map((e) {
                    return DropdownMenuItem<String?>(
                      value: e.id,
                      child: Text('${e.name} (${e.phone})', style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                ],
                onChanged: (val) {
                  setState(() => _selectedEmployeeId = val);
                },
              ),

              const SizedBox(height: 16),

              // Initial Note
              const Text('ملاحظة أولية (اختياري)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _noteCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'تفاصيل إضافية عن رغبة العميل ومواصفات الوحدة...',
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check),
                  label: const Text('حفظ وتسجيل العميل'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
