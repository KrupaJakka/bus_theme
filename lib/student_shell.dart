import 'package:bus_theme/map_holder.dart';
import 'package:flutter/material.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});
  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int idx = 0;
  final pages = [
    const StudentHome(),
    const MapPlaceholder(),
    const AttendancePage(),
    const NotificationPage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext c) => Scaffold(
    body: IndexedStack(index: idx, children: pages),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: idx,
      onTap: (i) => setState(() => idx = i),
      backgroundColor: Colors.grey[900],
      selectedItemColor: Theme.of(c).colorScheme.primary,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Track',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.check_circle),
          label: 'Attendance',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ),
  );
}

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});
  @override
  Widget build(BuildContext c) => Center(
    child: Text(
      'Student Dashboard',
      style: Theme.of(c).textTheme.headlineMedium,
    ),
  );
}

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});
  @override
  Widget build(BuildContext c) => Center(
    child: Text('Attendance', style: Theme.of(c).textTheme.headlineMedium),
  );
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});
  @override
  Widget build(BuildContext c) => Center(
    child: Text('Notifications', style: Theme.of(c).textTheme.headlineMedium),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext c) => Center(
    child: Text('Profile', style: Theme.of(c).textTheme.headlineMedium),
  );
}
