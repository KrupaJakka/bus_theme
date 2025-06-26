import 'package:bus_theme/alertpage.dart';
import 'package:bus_theme/parent_settings.dart';

import 'package:flutter/material.dart';
import 'package:bus_theme/parent_track_page.dart'; // <-- add this
// NotificationPage
// MapPlaceholder no longer needed

class ParentShell extends StatefulWidget {
  const ParentShell({super.key});
  @override
  State<ParentShell> createState() => _ParentShellState();
}

class _ParentShellState extends State<ParentShell> {
  int _index = 0;

  // ▼ use final (not const) because the first page isn’t const-constructible
  final List<Widget> _pages = const [
    ParentTrackPage(), // ← replaces MapPlaceholder()
    ParentHomePage(),
    ParentSettingsPage(),
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
            icon: Icon(Icons.location_on),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
