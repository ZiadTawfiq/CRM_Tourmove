import 'package:flutter/material.dart';
import '../models/crm_enums.dart';
import '../models/lead_model.dart';
import '../services/crm_repository.dart';
import '../widgets/lead_card.dart';
import 'lead_details_screen.dart';
import 'create_lead_screen.dart';

class PipelineScreen extends StatefulWidget {
  const PipelineScreen({Key? key}) : super(key: key);

  @override
  State<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends State<PipelineScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CrmRepository _repo = CrmRepository();

  final List<LeadStatus> _stages = [
    LeadStatus.freshLead,
    LeadStatus.followUp,
    LeadStatus.orientation,
    LeadStatus.reservation,
    LeadStatus.cancellation,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _stages.length, vsync: this);
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  String _formatBudget(double budget) {
    if (budget >= 1000000) {
      return '${(budget / 1000000).toStringAsFixed(1)} م ج.م';
    }
    return '${(budget / 1000).toStringAsFixed(0)} ألف ج.م';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('مسار المبيعات (Pipeline)'),
        actions: [
          if (_repo.duplicateCount > 0)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Chip(
                avatar: const Icon(Icons.warning, size: 14, color: Colors.white),
                label: Text(
                  '${_repo.duplicateCount} مكرر',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.red,
                visualDensity: VisualDensity.compact,
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: theme.colorScheme.primary,
          indicatorWeight: 3,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'),
          tabs: _stages.map((stage) {
            final stageLeads = _repo.leads.where((l) => l.status == stage).toList();
            return Tab(
              child: Row(
                children: [
                  Text(stage.labelAr),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: stage.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${stageLeads.length}',
                      style: TextStyle(
                        color: stage.color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _stages.map((stage) {
          final stageLeads = _repo.leads.where((l) => l.status == stage).toList();
          final totalBudget = stageLeads.fold<double>(0, (sum, item) => sum + (item.budget ?? 0));

          return Column(
            children: [
              // Summary Banner for current stage
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: stage.bgColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'إجمالي عدد الطلبات: ${stageLeads.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: stage.color,
                      ),
                    ),
                    Text(
                      'الميزانية الإجمالية: ${_formatBudget(totalBudget)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: stage.color,
                      ),
                    ),
                  ],
                ),
              ),

              // Leads list
              Expanded(
                child: stageLeads.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 12),
                            Text(
                              'لا توجد طلبات في مرحلة (${stage.labelAr})',
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 80),
                        itemCount: stageLeads.length,
                        itemBuilder: (context, index) {
                          final lead = stageLeads[index];
                          return LeadCard(
                            lead: lead,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LeadDetailsScreen(lead: lead),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateLeadScreen()),
          );
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('عميل جديد', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
