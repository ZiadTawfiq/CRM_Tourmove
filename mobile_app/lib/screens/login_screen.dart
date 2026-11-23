import 'package:flutter/material.dart';
import '../services/crm_repository.dart';
import 'home_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final CrmRepository _repo = CrmRepository();
  final TextEditingController _emailCtrl = TextEditingController(text: 'khaled@tourmove.com');
  final TextEditingController _passCtrl = TextEditingController(text: 'Password123!');
  bool _isLoading = false;
  bool _obscurePass = true;
  String? _errorMessage;

  void _handleLogin([String? email, String? password]) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final targetEmail = email ?? _emailCtrl.text;
      final targetPass = password ?? _passCtrl.text;
      await _repo.authService.login(targetEmail, targetPass);
      _repo.notifyListeners();

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeNavigationScreen()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'فشل تسجيل الدخول: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo & Header
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxStyle(
                          color: const Color(0xFF4F46E5).withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.apartment, size: 44, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tourmove CRM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'نظام إدارة علاقات العملاء ومبيعات العقارات',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 36),

                // Email field
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Password field
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),

                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                  const SizedBox(height: 16),
                ],

                // Submit Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : () => _handleLogin(),
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('تسجيل الدخول', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 28),

                // Quick Demo Accounts Section
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('أو دخول سريع للتجربة (Demo)', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.admin_panel_settings, size: 16, color: Color(0xFF4F46E5)),
                      label: const Text('خالد (مدير النظام)'),
                      onPressed: () => _handleLogin('khaled@tourmove.com', 'Pass123!'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.person, size: 16, color: Color(0xFF10B981)),
                      label: const Text('أحمد (مندوب مبيعات)'),
                      onPressed: () => _handleLogin('ahmed@tourmove.com', 'Pass123!'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.person, size: 16, color: Color(0xFFEC4899)),
                      label: const Text('سارة (مندوبة مبيعات)'),
                      onPressed: () => _handleLogin('sara@tourmove.com', 'Pass123!'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.groups, size: 16, color: Color(0xFF8B5CF6)),
                      label: const Text('عمر (قائد فريق)'),
                      onPressed: () => _handleLogin('omar@tourmove.com', 'Pass123!'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

