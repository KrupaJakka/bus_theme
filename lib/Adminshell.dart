import 'package:flutter/material.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;
  final _pages = const [
    AdminDashboard(),
    BusListPage(),
    DriverListPage(),
    AnalyticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: Colors.grey[900],
        selectedItemColor: cs.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Buses',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Drivers'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Admin Overview')),
    body: const Center(child: Text('Bus stats, active routes, alerts etc.')),
  );
}

class BusListPage extends StatelessWidget {
  const BusListPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Manage Buses')),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.add),
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.directions_bus),
          title: Text('Bus A-1'),
          subtitle: Text('Route A'),
        ),
        ListTile(
          leading: Icon(Icons.directions_bus),
          title: Text('Bus B-2'),
          subtitle: Text('Route B'),
        ),
      ],
    ),
  );
}

class DriverListPage extends StatelessWidget {
  const DriverListPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Manage Drivers')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('John Doe'),
          subtitle: Text('Bus A-1'),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Priya S.'),
          subtitle: Text('Bus B-2'),
        ),
      ],
    ),
  );
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Analytics')),
    body: const Center(child: Text('Charts and KPIs coming soon')),
  );
}
