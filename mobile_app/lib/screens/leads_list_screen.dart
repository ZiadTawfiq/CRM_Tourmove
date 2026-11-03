import 'package:flutter/material.dart';
import '../models/crm_enums.dart';
import '../models/lead_model.dart';
import '../services/crm_repository.dart';
import '../widgets/lead_card.dart';
import 'lead_details_screen.dart';

class LeadsListScreen extends StatefulWidget {
  const LeadsListScreen({Key? key}) : super(key: key);

  @override
  State<LeadsListScreen> createState() => _LeadsListScreenState();
}

class _LeadsListScreenState extends State<LeadsListScreen> {
  final CrmRepository _repo = CrmRepository();
  final TextEditingController _searchCtrl = TextEditingController();

  LeadStatus? _filterStatus;
  int? _filterProjectId;
  bool _filterDuplicatesOnly = false;

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  List<LeadModel> _getFilteredLeads() {
    final query = _searchCtrl.text.trim().toLowerCase();
    return _repo.leads.where((l) {
      if (query.isNotEmpty) {
        final matchName = l.name.toLowerCase().contains(query);
        final matchPhone = l.phoneNumber.contains(query);
        final matchProj = (l.projectName ?? '').toLowerCase().contains(query);
        if (!matchName && !matchPhone && !matchProj) return false;
      }

      if (_filterStatus != null && l.status != _filterStatus) return false;
      if (_filterProjectId != null && l.projectId != _filterProjectId) return false;
      if (_filterDuplicatesOnly && !l.isDuplicated) return false;

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _getFilteredLeads();

    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل العملاء (Leads Directory)'),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'بحث برقم الهاتف أو اسم العميل أو المشروع...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchCtrl.clear(),
                      )
                    : null,
              ),
            ),
          ),

          // Filter Chips Horizontal List
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('المكررين فقط'),
                  selected: _filterDuplicatesOnly,
                  selectedColor: Colors.red.withOpacity(0.2),
                  checkmarkColor: Colors.red,
                  onSelected: (val) => setState(() => _filterDuplicatesOnly = val),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('جميع المراحل'),
                  selected: _filterStatus == null,
                  onSelected: (val) => setState(() => _filterStatus = null),
                ),
                ...LeadStatus.values.map((s) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(s.labelAr),
                      selected: _filterStatus == s,
                      selectedColor: s.color.withOpacity(0.2),
                      onSelected: (val) {
                        setState(() => _filterStatus = val ? s : null);
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Count Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عدد النتائج: ${filtered.length}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.bold),
                ),
                if (_filterDuplicatesOnly || _filterStatus != null || _searchCtrl.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _filterDuplicatesOnly = false;
                        _filterStatus = null;
                        _filterProjectId = null;
                        _searchCtrl.clear();
                      });
                    },
                    child: Text(
                      'إلغاء كل الفلاتر',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),

          // Leads List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد نتائج تطابق خيارات البحث المحددة',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final lead = filtered[index];
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
      ),
    );
  }
}
