import 'package:bus_theme/map_holder.dart';
import 'package:bus_theme/trip_control_page.dart';
import 'package:flutter/material.dart';
// MapPlaceholder & NotificationPage

// =============================== DRIVER ===============================
class DriverShell extends StatefulWidget {
  const DriverShell({super.key});
  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _index = 0;
  final _pages = const [
    TripControlPage(),
    MapPlaceholder(),
    ReportPage(),
    ProfilePage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: 'Trip'),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Live Map',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Driver Reports')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.warning),
          title: Text('Flat tyre reported'),
        ),
        ListTile(
          leading: Icon(Icons.schedule),
          title: Text('Schedule delay submitted'),
        ),
      ],
    ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Driver Profile')),
    body: const Center(child: Text('Profile details coming soon')),
  );
}
