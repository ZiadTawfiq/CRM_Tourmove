import 'package:flutter/material.dart';
import '../models/crm_enums.dart';
import '../services/crm_repository.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  String _formatCurrency(double val) {
    if (val >= 1000000) {
      return '${(val / 1000000).toStringAsFixed(1)} م ج.م';
    }
    return '${val.toInt()} ج.م';
  }

  @override
  Widget build(BuildContext context) {
    final repo = CrmRepository();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final total = repo.leads.isNotEmpty ? repo.leads.length : 1;
    final wonCount = repo.leads.where((l) => l.status == LeadStatus.reservation).length;
    final conversionRate = ((wonCount / total) * 100).toStringAsFixed(1);
    final totalBudget = repo.leads.fold<double>(0, (sum, item) => sum + (item.budget ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('التحليلات ومعدلات التحويل'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Overview Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('إجمالي قيمة المسار', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(
                            _formatCurrency(totalBudget),
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text('معدل التحويل', style: TextStyle(color: Colors.white, fontSize: 11)),
                            Text('$conversionRate%', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatMini(title: 'إجمالي العملاء', value: '${repo.leads.length}'),
                      _StatMini(title: 'حجوزات مؤكدة', value: '$wonCount'),
                      _StatMini(title: 'أرقام مكررة', value: '${repo.duplicateCount}'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Pipeline Stages Breakdown
            const Text(
              'توزيع مراحل المسار',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: LeadStatus.values.map((s) {
                    final count = repo.leads.where((l) => l.status == s).length;
                    final pct = (count / total);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(s.labelAr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('$count (${(pct * 100).toStringAsFixed(0)}%)', style: TextStyle(color: s.color, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: pct,
                            backgroundColor: s.color.withOpacity(0.12),
                            valueColor: AlwaysStoppedAnimation<Color>(s.color),
                            borderRadius: BorderRadius.circular(10),
                            minHeight: 8,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Sales Reps Workload
            const Text(
              'كفاءة مسؤولي المبيعات',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Card(
              margin: EdgeInsets.zero,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: repo.employees.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final emp = repo.employees[index];
                  final empLeads = repo.leads.where((l) => l.employeeId == emp.id).toList();
                  final empWon = empLeads.where((l) => l.status == LeadStatus.reservation).length;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                      child: Text(emp.name[0]),
                    ),
                    title: Text(emp.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('${empLeads.length} عميل مسند', style: const TextStyle(fontSize: 12)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$empWon حجز ناجح',
                        style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatMini extends StatelessWidget {
  final String title;
  final String value;

  const _StatMini({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}
