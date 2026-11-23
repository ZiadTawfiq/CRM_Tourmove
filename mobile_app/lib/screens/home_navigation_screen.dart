import 'package:flutter/material.dart';
import '../services/crm_repository.dart';
import 'pipeline_screen.dart';
import 'leads_list_screen.dart';
import 'duplicates_screen.dart';
import 'projects_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';

class HomeNavigationScreen extends StatefulWidget {
  const HomeNavigationScreen({Key? key}) : super(key: key);

  @override
  State<HomeNavigationScreen> createState() => _HomeNavigationScreenState();
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  int _currentIndex = 0;
  final CrmRepository _repo = CrmRepository();

  final List<Widget> _screens = const [
    PipelineScreen(),
    LeadsListScreen(),
    DuplicatesScreen(),
    ProjectsScreen(),
    AnalyticsScreen(),
  ];

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = _repo.currentUser;
    final dupCount = _repo.duplicateCount;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
              child: Text(
                currentUser?.name.isNotEmpty == true ? currentUser!.name[0] : 'U',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser?.name ?? 'Tourmove CRM',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currentUser?.employeeRole.title.split('(').first.trim() ?? '',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Demo Mode indicator pill
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _repo.isDemoMode
                    ? Colors.amber.withOpacity(0.18)
                    : Colors.green.withOpacity(0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _repo.isDemoMode ? Colors.amber.shade700 : Colors.green.shade600,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _repo.isDemoMode ? Icons.bolt : Icons.cloud_done,
                    size: 13,
                    color: _repo.isDemoMode ? Colors.amber.shade800 : Colors.green.shade700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _repo.isDemoMode ? 'وضع تجريبي' : 'متصل بالـ API',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _repo.isDemoMode ? Colors.amber.shade900 : Colors.green.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'الإعدادات',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        indicatorColor: theme.colorScheme.primary.withOpacity(0.18),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.view_kanban_outlined),
            selectedIcon: Icon(Icons.view_kanban, color: Color(0xFF4F46E5)),
            label: 'المسار',
          ),
          const NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: Color(0xFF4F46E5)),
            label: 'العملاء',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: dupCount > 0,
              label: Text('$dupCount'),
              backgroundColor: Colors.red,
              child: const Icon(Icons.security_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: dupCount > 0,
              label: Text('$dupCount'),
              backgroundColor: Colors.red,
              child: const Icon(Icons.security, color: Color(0xFF4F46E5)),
            ),
            label: 'التكرار',
          ),
          const NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business, color: Color(0xFF4F46E5)),
            label: 'المشاريع',
          ),
          const NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights, color: Color(0xFF4F46E5)),
            label: 'التحليلات',
          ),
        ],
      ),
    );
  }
}
