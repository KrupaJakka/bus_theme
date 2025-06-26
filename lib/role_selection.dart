import 'package:bus_theme/routes.dart';
import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});
  @override
  Widget build(BuildContext c) {
    final items = [
      ('Student', Routes.student, Icons.school),
      ('Parent', Routes.parent, Icons.family_restroom),
      ('Driver', Routes.driver, Icons.bus_alert),
      ('Admin', Routes.admin, Icons.admin_panel_settings),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Role'),
        leading: BackButton(onPressed: () => Navigator.pop(c)),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(24),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: .9,
        children: items
            .map((e) => _RoleCard(label: e.$1, route: e.$2, icon: e.$3))
            .toList(),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String label, route;
  final IconData icon;
  const _RoleCard({
    required this.label,
    required this.route,
    required this.icon,
  });
  @override
  Widget build(BuildContext c) => InkWell(
    onTap: () => Navigator.pushReplacementNamed(c, route),
    borderRadius: BorderRadius.circular(16),
    child: Ink(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Theme.of(c).colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}
