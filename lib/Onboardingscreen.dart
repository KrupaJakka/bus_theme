import 'package:bus_theme/routes.dart';
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
  @override
  Widget build(BuildContext c) => Scaffold(
    body: Stack(
      children: [
        PageView(
          controller: _pc,
          onPageChanged: (i) => setState(() => _idx = i),
          children: _cards,
        ),
        Positioned(
          right: 20,
          bottom: 40,
          child: FilledButton(
            onPressed: () => _idx < _cards.length - 1
                ? _pc.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  )
                : Navigator.pushReplacementNamed(context, Routes.roles),
            child: Text(_idx == _cards.length - 1 ? 'Start' : 'Next'),
          ),
        ),
      ],
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.icon, required this.title, required this.desc});
  final IconData icon;
  final String title;
  final String desc;
  @override
  Widget build(BuildContext c) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 96, color: Theme.of(c).colorScheme.secondary),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
