import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart'; 

class TripControlPage extends StatefulWidget {
  const TripControlPage({super.key});

  @override
  State<TripControlPage> createState() => _TripControlPageState();
}

class _TripControlPageState extends State<TripControlPage> {
  bool _tripOn = false;
  String? _selectedSource;
  String? _selectedDestination;

  List<String> _sources = [];
  List<String> _destinations = [];

  Timer? _timer;
  Color primaryColor = const Color(0xFFFECF4C);

  LatLng _currentLocation = LatLng(17.000, 81.804); 

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// ✅ Permissions
  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  /// ✅ Fetch Source/Destination from API
  Future<void> _fetchLocations() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost/busapp_api/get_locations.php"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _sources = List<String>.from(data["sources"].map((s) => s["name"]));
          _destinations = List<String>.from(
            data["destinations"].map((d) => d["name"]),
          );
        });
      }
    } catch (e) {
      debugPrint("Error fetching locations: $e");
    }
  }

  /// ✅ Start/Stop Trip
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

    _timer = Timer.periodic(
      const Duration(seconds: 8),
      (_) => _sendLiveLocation(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trip started – live location ON')),
    );
  }

  void _stopRide() {
    _timer?.cancel();
    setState(() => _tripOn = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Trip ended.')));
  }

  /// ✅ Send location to backend
  Future<void> _sendLiveLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(pos.latitude, pos.longitude);
      });

      await http.post(
        Uri.parse("http://localhost/busapp_api/update_location.php"),
        body: {
          "driver_id": "D123", // you can fetch from login
          "lat": pos.latitude.toString(),
          "lng": pos.longitude.toString(),
          "source": _selectedSource,
          "destination": _selectedDestination,
        },
      );
    } catch (e) {
      debugPrint("Error sending location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Trip Control",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Lottie.asset(
              _tripOn ? 'assets/bus_running.json' : 'assets/bus_idle.json',
              height: 150,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    "Select Source",
                    _selectedSource,
                    _sources,
                    (v) => setState(() => _selectedSource = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    "Select Destination",
                    _selectedDestination,
                    _destinations,
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
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[300],
        labelStyle: const TextStyle(color: Colors.black),
      ),
      value: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: _tripOn ? null : onChanged,
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _tripOn ? Icons.play_circle : Icons.stop_circle,
                  color: primaryColor,
                ),
                const SizedBox(width: 10),
                Text(_tripOn ? "Trip In Progress" : "Trip Stopped"),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _tripOn ? "Streaming live location..." : "Press START when ready",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenStreetMap() {
    return SizedBox(
      height: 250,
      child: fm.FlutterMap(
        options: fm.MapOptions(
          initialCenter: _currentLocation,
          initialZoom: 16,
        ),
        children: [
          fm.TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
        ],
      ),
    );
  }
}
