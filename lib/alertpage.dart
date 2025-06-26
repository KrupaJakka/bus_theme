import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({super.key});

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  final ColorScheme _cs = const ColorScheme.dark();

  // ——— Mock data (wire these from Firestore) ———
  static const String _childName = 'Alex Johnson';
  static const String _busNumber = 'BUS‑45';
  static const String _routeName = 'Route A‑1';
  static const String _driverPhone = '+91 98765 43210';

  bool _busActive = true;

  // ——— Map / Polyline data ———
  final Completer<GoogleMapController> _mapController = Completer();
  // Dummy route coordinates (replace with your real route points)
  final List<LatLng> _routeCoords = const [
    LatLng(12.9716, 77.5946),
    LatLng(12.9742, 77.6010),
    LatLng(12.9771, 77.6080),
    LatLng(12.9804, 77.6175),
  ];
  // Current bus coordinate (simulate / stream from backend)
  LatLng get _busPos => _routeCoords[1]; // quick demo

  Set<Polyline> get _polyline => {
    Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.tealAccent,
      width: 6,
      points: _routeCoords,
    ),
  };

  Set<Marker> get _markers => {
    Marker(
      markerId: const MarkerId('bus'),
      position: _busPos,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(title: 'Current Bus Position'),
    ),
  };

  Future<void> _callDriver() async {
    final uri = Uri(scheme: 'tel', path: _driverPhone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This device cannot place calls.')),
      );
    }
  }

  void _triggerSOS() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('SOS Sent'),
        content: const Text(
          'Your emergency alert has been sent to school authorities and the driver.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    // TODO: hit your backend / Cloud Function to publish an SOS event.
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: _cs.primary),
              const SizedBox(height: 4),
              Text(label),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ——— Child & Bus status card ———
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(radius: 34, child: Icon(Icons.school)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _childName,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bus: $_busNumber  •  $_routeName',
                        style: textTheme.bodyMedium?.copyWith(
                          color: _cs.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('Status:'),
                          const SizedBox(width: 4),
                          Text(
                            _busActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: _busActive
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ——— Quick Actions ———
          Row(
            children: [
              Expanded(
                child: _quickAction(Icons.location_on, 'Track', () async {
                  // Smoothly animate camera to bus marker
                  final controller = await _mapController.future;
                  controller.animateCamera(
                    CameraUpdate.newLatLngZoom(_busPos, 15),
                  );
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _quickAction(
                  _busActive ? Icons.check_circle : Icons.error,
                  _busActive ? 'Active' : 'Inactive',
                  () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _quickAction(Icons.call, 'Call', _callDriver)),
            ],
          ),
          const SizedBox(height: 24),

          // ——— Live Map ———
          Text('Live Bus Route', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GoogleMap(
                onMapCreated: (c) => _mapController.complete(c),
                initialCameraPosition: CameraPosition(
                  target: _routeCoords.first,
                  zoom: 13,
                ),
                polylines: _polyline,
                markers: _markers,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ——— Recent Alerts preview (static demo) ———
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Alerts', style: textTheme.titleMedium),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ListTile(
              leading: Icon(Icons.access_time, color: Colors.orange),
              title: Text('Bus delayed by 10 min'),
              subtitle: Text('2 min ago'),
            ),
          ),
          const SizedBox(height: 16),

          // ——— SOS button ———
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: _cs.error),
            onPressed: _triggerSOS,
            icon: const Icon(Icons.report_gmailerrorred),
            label: const Text('SOS - Emergency'),
          ),
        ],
      ),
    );
  }
}
