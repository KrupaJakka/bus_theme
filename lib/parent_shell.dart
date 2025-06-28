import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:bus_theme/alertpage.dart';
import 'package:bus_theme/parent_profile.dart';
import 'package:bus_theme/parent_track_page.dart';

class ParentShell extends StatefulWidget {
  const ParentShell({super.key});

  @override
  State<ParentShell> createState() => _ParentShellState();
}

class _ParentShellState extends State<ParentShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    ParentTrackPage(),
    ParentHomePage(),
    ParentSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color yellow = Color(0xFFFECF4C);
    const Color black = Colors.black;

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: CurvedNavigationBar(
        index: _index,
        backgroundColor: Colors.transparent,
        color: Color(0xFFFECF4C),
        buttonBackgroundColor: yellow,
        animationDuration: const Duration(milliseconds: 300),
        height: 60,
        items: const [
          Icon(Icons.location_on, color: Colors.black),
          Icon(Icons.notifications, color: Colors.black),
          Icon(Icons.settings, color: Colors.black),
        ],
        onTap: (i) {
          setState(() => _index = i);
        },
      ),
    );
  }
}
