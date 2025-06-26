import 'package:bus_theme/map_holder.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Parent‑side live‑tracking page
/// — tap map or FAB opens Google Maps at bus location
/// — Call button opens native dialer with driver number pre‑filled
/// — Stylish vertical route timeline
class ParentTrackPage extends StatelessWidget {
  const ParentTrackPage({super.key});

  // 🔧 Replace with real‑time coords & phone pulled from backend
  static const double _busLat = 12.9716;
  static const double _busLng = 77.5946;

  /* Open Google Maps in external app */
  Future<void> _openMap() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$_busLat,$_busLng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /* Bring up dial‑pad with driver number filled in */
  Future<void> _callDriver(BuildContext ctx) async {
    final uri = Uri(scheme: 'tel', path: '+919876543210'); // no “tel://”
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      ); // opens dial-pad
    } else {
      ScaffoldMessenger.of(
        ctx,
      ).showSnackBar(const SnackBar(content: Text('Could not open dialer')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final timeline = [
      ('Main Gate', 'Departed 8:15 AM', _PointState.past),
      ('Park Street', 'Current 8:25 AM', _PointState.current),
      ('College Campus', 'ETA 8:35 AM', _PointState.future),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Track My Child')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Map Card ---------------------------------------------------
          GestureDetector(
            onTap: _openMap,
            child: Card(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: MapPlaceholder(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // --- Child & Bus Row -------------------------------------------
          Row(
            children: [
              const CircleAvatar(radius: 28, child: Icon(Icons.school)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Child: Alex Johnson',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Text(
                      'Bus: BUS‑45 (Route A‑1)',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'ETA to stop: 5 min',
                      style: TextStyle(color: cs.secondary),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => _callDriver(context),
                icon: const Icon(Icons.call),
                label: const Text('Call'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // --- Timeline ----------------------------------------------------
          Text('Route Timeline', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _VerticalTimeline(items: timeline),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openMap,
        icon: const Icon(Icons.map),
        label: const Text('Open in Maps'),
      ),
    );
  }
}

// =================== Vertical Timeline Component ===================
enum _PointState { past, current, future }

class _VerticalTimeline extends StatelessWidget {
  final List<(String, String, _PointState)> items;
  const _VerticalTimeline({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (i) {
        final (title, subtitle, state) = items[i];
        final isLast = i == items.length - 1;
        Color dotColor;
        switch (state) {
          case _PointState.past:
            dotColor = Colors.green;
            break;
          case _PointState.current:
            dotColor = Theme.of(context).colorScheme.primary;
            break;
          case _PointState.future:
            dotColor = Colors.grey;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 2,
                  height: 10,
                  color: i == 0 ? Colors.transparent : Colors.grey,
                ),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 2,
                  height: isLast ? 10 : 40,
                  color: isLast ? Colors.transparent : Colors.grey,
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
