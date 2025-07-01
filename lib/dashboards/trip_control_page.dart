import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';

class TripControlPage extends StatefulWidget {
  const TripControlPage({super.key});

  @override
  State<TripControlPage> createState() => _TripControlPageState();
}

class _TripControlPageState extends State<TripControlPage> {
  bool _tripOn = false;
  String? _selectedSource;
  String? _selectedDestination;
  final _locations = ['School A', 'School B', 'School C', 'School D'];

  Timer? _timer;
  Color primaryColor = const Color(0xFFFECF4C);

  List<LatLng> _dummyRoute = [
    LatLng(37.427961, -122.085749),
    LatLng(37.428961, -122.084749),
    LatLng(37.429961, -122.083749),
  ];

  LatLng _currentLocation = LatLng(37.427961, -122.085749);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTrip() {
    if (!_tripOn) {
      if (_selectedSource == null || _selectedDestination == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select source & destination first')),
        );
        return;
      }
      _startRide();
    } else {
      _stopRide();
    }
  }

  void _startRide() {
    setState(() => _tripOn = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Trip started – students can now track you.'),
      ),
    );
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _simulateMove());
  }

  void _stopRide() {
    _timer?.cancel();
    setState(() => _tripOn = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Trip ended.')));
  }

  void _simulateMove() {
    final currentIndex = _dummyRoute.indexOf(_currentLocation);
    final nextIndex = (currentIndex + 1) % _dummyRoute.length;
    setState(() {
      _currentLocation = _dummyRoute[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Trip Control',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Lottie animation stays
            Lottie.asset(
              _tripOn ? 'assets/bus_idle.json' : 'assets/bus_running.json',
              height: 150,
              repeat: true,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'Select Source',
                    _selectedSource,
                    (v) => setState(() => _selectedSource = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    'Select Destination',
                    _selectedDestination,
                    (v) => setState(() => _selectedDestination = v),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            _buildStatusCard(),
            const SizedBox(height: 16),

            if (_tripOn) _buildOpenStreetMap(),

            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _toggleTrip,
              style: FilledButton.styleFrom(
                backgroundColor: _tripOn ? Colors.red : primaryColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: Icon(_tripOn ? Icons.stop : Icons.play_arrow),
              label: Text(_tripOn ? 'End Trip' : 'Start Trip'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[300],
        labelStyle: const TextStyle(color: Colors.black),
      ),
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      value: value,
      items: _locations
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: _tripOn ? null : onChanged,
      iconEnabledColor: Colors.black,
    );
  }

  Widget _buildStatusCard() {
    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _tripOn ? Icons.play_circle : Icons.stop_circle,
                  color: primaryColor,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  _tripOn ? 'Trip In Progress' : 'Trip Stopped',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: _tripOn ? null : 0,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              color: primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              _tripOn
                  ? 'Streaming live location to server...'
                  : 'Press START when ready to depart.',
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenStreetMap() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 250,
        child: fm.FlutterMap(
          options: fm.MapOptions(
            initialCenter: _currentLocation,
            initialZoom: 16,
          ),
          children: [
            fm.TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            fm.MarkerLayer(
              markers: [
                fm.Marker(
                  width: 40,
                  height: 40,
                  point: _currentLocation,
                  child: const Icon(
                    Icons.directions_bus,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
              ],
            ),
            fm.PolylineLayer(
              polylines: [
                fm.Polyline(
                  points: _dummyRoute,
                  strokeWidth: 4,
                  color: primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
