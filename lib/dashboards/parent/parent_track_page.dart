import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentTrackPage extends StatelessWidget {
  const ParentTrackPage({super.key});

  static const double _busLat = 12.9716;
  static const double _busLng = 77.5946;

  static const Color yellow = Color(0xFFFECF4C);
  static const Color black = Colors.black;

  Future<void> _openMap() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$_busLat,$_busLng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callDriver(BuildContext ctx) async {
    final uri = Uri(scheme: 'tel', path: '+919876543210');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        ctx,
      ).showSnackBar(const SnackBar(content: Text('Could not open dialer')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeline = [
      ('Main Gate', 'Departed 8:15 AM', _PointState.past),
      ('Park Street', 'Current 8:25 AM', _PointState.current),
      ('College Campus', 'ETA 8:35 AM', _PointState.future),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: yellow,
        foregroundColor: black,
        title: const Text('Track My Child'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- OpenStreetMap Widget -------------------------------------
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: yellow, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(_busLat, _busLng),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.bus_theme',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 50,
                        height: 50,
                        point: LatLng(_busLat, _busLng),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Bus Location'),
                                content: const Text(
                                  'The bus is here on the map.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: yellow,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.directions_bus,
                              color: black,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- Child & Bus Info ------------------------------------------
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: yellow,
                child: Icon(Icons.school, color: black),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Child: Alex Johnson',
                      style: TextStyle(fontSize: 16, color: black),
                    ),
                    const Text(
                      'Bus: BUS‑45 (Route A‑1)',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Text(
                      'ETA to stop: 5 min',
                      style: TextStyle(color: black),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellow,
                  foregroundColor: black,
                ),
                onPressed: () => _callDriver(context),
                icon: const Icon(Icons.call),
                label: const Text('Call'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Timeline ----------------------------------------------------
          Text(
            'Route Timeline',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: black),
          ),
          const SizedBox(height: 12),
          _VerticalTimeline(items: timeline),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: yellow,
        foregroundColor: black,
        onPressed: _openMap,
        icon: const Icon(Icons.map),
        label: const Text('Open in Maps'),
      ),
    );
  }
}

enum _PointState { past, current, future }

class _VerticalTimeline extends StatelessWidget {
  final List<(String, String, _PointState)> items;
  const _VerticalTimeline({required this.items});

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFFECF4C);
    const black = Colors.black;

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
            dotColor = yellow;
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: black,
                    ),
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
