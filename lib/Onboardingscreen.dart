import 'package:bus_theme/role_selection.dart';
import 'package:bus_theme/role_selection.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pc = PageController();
  int _idx = 0;

  final _cards = const [
    _Card(
      icon: Icons.directions_bus_filled,
      title: 'Real‑time Tracking',
      desc: 'Locate buses and see ETA.',
    ),
    _Card(
      icon: Icons.shield_moon,
      title: 'Safety Alerts',
      desc: 'Parents & students receive notifications.',
    ),
    _Card(
      icon: Icons.speed,
      title: 'Driver Friendly',
      desc: 'Easy to share location & routes.',
    ),
  ];

  void goToRoleSelection() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RoleSelectionApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page View (Slides)
          PageView(
            controller: _pc,
            onPageChanged: (i) => setState(() => _idx = i),
            children: _cards,
          ),

          // Skip Button (Top-right)
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: goToRoleSelection,
              child: const Text(
                'Skip',
                style: TextStyle(fontSize: 16, color: Color(0xFFFECF4C)),
              ),
            ),
          ),

          // Bottom Button (Next or Start)
          Positioned(
            right: 20,
            bottom: 40,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Color(0xFFFECF4C),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (_idx < _cards.length - 1) {
                  _pc.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                } else {
                  goToRoleSelection();
                }
              },
              child: Text(
                _idx == _cards.length - 1 ? 'Start' : 'Next',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.icon, required this.title, required this.desc});

  final IconData icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 96,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
