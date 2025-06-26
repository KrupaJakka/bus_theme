import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StudentShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const StudentHome(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: const Color.fromARGB(255, 207, 186, 3),
      ),
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        height: 60.0,
        backgroundColor: Colors.transparent,
        color: Colors.yellow[900]!,
        buttonBackgroundColor: Theme.of(context).colorScheme.primary,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.dashboard, size: 30, color: Colors.white),
          Icon(Icons.notifications, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final List<Map<String, dynamic>> buses = [
    {
      'id': 'bus1',
      'location': LatLng(37.7749, -122.4194),
      'driver': {
        'driver_id': 'D001',
        'name': 'John Doe',
        'experience': '5 years',
        'phone': '+1234567890',
        'route_id': 'R01',
        'stop_location': 'Main Street Stop',
        'profile_image': 'https://randomuser.me/api/portraits/men/1.jpg',
      },
    },
    {
      'id': 'bus2',
      'location': LatLng(37.7755, -122.4180),
      'driver': {
        'driver_id': 'D002',
        'name': 'Alice Smith',
        'experience': '3 years',
        'phone': '+1987654321',
        'route_id': 'R02',
        'stop_location': 'Central Park Stop',
        'profile_image': 'https://randomuser.me/api/portraits/women/2.jpg',
      },
    },
    {
      'id': 'bus3',
      'location': LatLng(37.7760, -122.4200),
      'driver': {
        'driver_id': 'D003',
        'name': 'Michael Johnson',
        'experience': '4 years',
        'phone': '+1122334455',
        'route_id': 'R03',
        'stop_location': 'Downtown Stop',
        'profile_image': 'https://randomuser.me/api/portraits/men/3.jpg',
      },
    },
  ];

  Map<String, dynamic>? selectedDriver;

  Future<void> _openDialer(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cannot open dialer')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Map Container
            Container(
              height: 430,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.yellow.withOpacity(0.3),
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(37.7750, -122.4194),
                  initialZoom: 14.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: buses.map((bus) {
                      return Marker(
                        point: bus['location'],
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDriver = bus['driver'];
                            });
                          },
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 36,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Driver Details with WhatsApp-style profile pic
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow[200],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: selectedDriver != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            selectedDriver!['profile_image'],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedDriver!['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text('ID: ${selectedDriver!['driver_id']}'),
                              Text('Exp: ${selectedDriver!['experience']}'),
                              Text('Phone: ${selectedDriver!['phone']}'),
                              Text('Route: ${selectedDriver!['route_id']}'),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text('Tap a bus marker to view driver details'),
                    ),
            ),
          ],
        ),
      ),

      // Floating Action Button (Call Button)
      floatingActionButton: selectedDriver != null
          ? FloatingActionButton.extended(
              onPressed: () => _openDialer(selectedDriver!['phone']),
              label: const Text('Call Driver'),
              icon: const Icon(Icons.call),
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tooltip: 'Call ${selectedDriver!['name']}',
            )
          : null,
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Notifications',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
