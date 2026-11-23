import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/crm_models.dart';
import '../services/crm_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final CrmRepository _repo = CrmRepository();
  late TextEditingController _urlCtrl;
  bool _isTestingConnection = false;
  String? _testResult;

  @override
  void initState() {
    super.initState();
    _urlCtrl = TextEditingController(text: _repo.apiConfig.baseUrl);
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  void _testConnection() async {
    setState(() {
      _isTestingConnection = true;
      _testResult = null;
    });

    try {
      final uri = Uri.parse(_urlCtrl.text.trim());
      final res = await http.get(uri).timeout(const Duration(seconds: 4));
      setState(() {
        _testResult = 'تم الاتصال بنجاح! كود الاستجابة: ${res.statusCode}';
      });
    } catch (e) {
      setState(() {
        _testResult = 'تعذر الاتصال بالخادم: $e';
      });
    } finally {
      setState(() => _isTestingConnection = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = _repo.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات ووضع النظام'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current User Profile Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                    child: Icon(Icons.person, size: 32, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser?.name ?? 'المستخدم الحالي',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentUser?.email ?? '',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            currentUser?.employeeRole.title ?? '',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // User Switcher (For Demo purposes)
          const Text('تبديل المستخدم الحالي (Demo User Switcher):', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _repo.employees.map((emp) {
              final isSelected = emp.id == currentUser?.id;
              return ChoiceChip(
                label: Text(emp.name),
                selected: isSelected,
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                onSelected: (val) {
                  if (val) _repo.switchUser(emp);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Mode Selection: Demo vs Live API
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _repo.isDemoMode ? Icons.offline_bolt : Icons.cloud_done,
                        color: _repo.isDemoMode ? Colors.orange : Colors.green,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _repo.isDemoMode ? 'وضع العرض التجريبي (Demo Mode)' : 'متصل بالخادم المباشر (.NET Core API)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _repo.isDemoMode
                        ? 'يعمل التطبيق ببيانات عقارية مصرية متكاملة وسيناريوهات فحص التكرار دون الحاجة لتشغيل قاعدة بيانات خارجية.'
                        : 'يتم إرسال واستقبال كافة الطلبات مباشرة من خادم ASP.NET Core Web API عبر الشبكة.',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Divider(height: 24),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('تفعيل وضع العرض التجريبي (Demo Data Mode)', style: TextStyle(fontSize: 14)),
                    value: _repo.isDemoMode,
                    onChanged: (val) => _repo.setDemoMode(val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Backend API URL Configuration
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('عنوان الخادم (Backend Base URL):', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _urlCtrl,
                    decoration: InputDecoration(
                      hintText: 'http://localhost:5000/api',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () => _repo.setBaseUrl(_urlCtrl.text),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _urlCtrl.text = 'http://localhost:5000/api';
                          _repo.setBaseUrl(_urlCtrl.text);
                        },
                        child: const Text('Localhost (5000)'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          _urlCtrl.text = 'http://10.0.2.2:5000/api';
                          _repo.setBaseUrl(_urlCtrl.text);
                        },
                        child: const Text('Android (10.0.2.2)'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: _isTestingConnection
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.network_check, size: 18),
                    label: const Text('اختبار الاتصال بالخادم'),
                    onPressed: _isTestingConnection ? null : _testConnection,
                  ),
                  if (_testResult != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _testResult!.contains('بنجاح')
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _testResult!,
                        style: TextStyle(
                          fontSize: 12,
                          color: _testResult!.contains('بنجاح') ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Reset Demo Data Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.restore),
            label: const Text(
              'إعادة تعيين البيانات الافتراضية (Reset Demo Data)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              _repo.resetDemoData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم استعادة البيانات الافتراضية بنجاح.')),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

