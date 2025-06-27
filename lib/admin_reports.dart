import 'package:flutter/material.dart';

class AdminIssueBoardPage extends StatefulWidget {
  const AdminIssueBoardPage({super.key});
  @override
  State<AdminIssueBoardPage> createState() => _AdminIssueBoardPageState();
}

class _AdminIssueBoardPageState extends State<AdminIssueBoardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  // Mock dataset – in real app fetch from backend
  final List<Map<String, dynamic>> _issues = [
    {
      'id': '1',
      'desc': 'Flat tyre reported',
      'prio': 'Urgent',
      'status': 'Pending',
      'driver': 'John Doe',
      'bus': 'BUS‑45',
      'date': '2025‑06‑26',
    },
    {
      'id': '2',
      'desc': 'AC not working',
      'prio': 'Medium',
      'status': 'In Progress',
      'driver': 'Priya S.',
      'bus': 'BUS‑32',
      'date': '2025‑06‑25',
    },
    {
      'id': '3',
      'desc': 'Schedule delay submitted',
      'prio': 'Low',
      'status': 'Resolved',
      'driver': 'John Doe',
      'bus': 'BUS‑45',
      'date': '2025‑06‑24',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  // -------------------------------- Helper -------------------------------
  Color _prioColor(String p) => p == 'Urgent'
      ? Colors.red
      : p == 'Medium'
      ? Colors.orange
      : Colors.green;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Issue Board'),
      bottom: TabBar(
        controller: _tab,
        tabs: const [
          Tab(text: 'Pending'),
          Tab(text: 'In Progress'),
          Tab(text: 'Resolved'),
        ],
      ),
    ),
    body: TabBarView(
      controller: _tab,
      children: [
        _buildList('Pending'),
        _buildList('In Progress'),
        _buildList('Resolved'),
      ],
    ),
  );

  Widget _buildList(String status) {
    final list = _issues.where((e) => e['status'] == status).toList();
    if (list.isEmpty) {
      return const Center(child: Text('No issues'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) => ListTile(
        leading: Icon(Icons.bug_report, color: _prioColor(list[i]['prio'])),
        title: Text(list[i]['desc']),
        subtitle: Text('Driver: ${list[i]['driver']} • ${list[i]['date']}'),
        trailing: PopupMenuButton<String>(
          onSelected: (val) => _updateStatus(list[i]['id'], val),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'Pending', child: Text('Mark Pending')),
            PopupMenuItem(
              value: 'In Progress',
              child: Text('Mark In Progress'),
            ),
            PopupMenuItem(value: 'Resolved', child: Text('Mark Resolved')),
          ],
          icon: const Icon(Icons.more_vert),
        ),
      ),
    );
  }

  void _updateStatus(String id, String newStatus) {
    setState(() {
      final idx = _issues.indexWhere((e) => e['id'] == id);
      if (idx != -1) _issues[idx]['status'] = newStatus;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Status updated to $newStatus')));
  }
}
