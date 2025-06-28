import 'package:bus_theme/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminShell(),
    );
  }
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    AdminDashboard(),
    Admin(),
    AdminProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: CurvedNavigationBar(
        index: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: Colors.white,
        color: const Color(0xFFFECF4C),
        buttonBackgroundColor: const Color(0xFFFECF4C),
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.dashboard, color: Colors.black, size: 30),
          Icon(Icons.directions_bus, color: Colors.black, size: 30),
          Icon(Icons.analytics, color: Colors.black, size: 30),
        ],
      ),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<Map<String, dynamic>> buses = [
    {
      "busNumber": "Bus RJY-101",
      "driver": "Ram Mohan",
      "phone": "+919876543210",
      "location": LatLng(17.0052, 81.7774),
    },
    {
      "busNumber": "Bus RJY-102",
      "driver": "Lakshmi Rao",
      "phone": "+919876543211",
      "location": LatLng(17.0080, 81.7830),
    },
  ];

  Map<String, dynamic>? selectedBus;

  Future<void> _makeCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not launch dialer')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Overview'),
        backgroundColor: const Color(0xFFFECF4C),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.015,
          ),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black),
                ),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(16.5, 81.5),
                    initialZoom: 7.0,
                    onTap: (_, __) => setState(() => selectedBus = null),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: buses.map((bus) {
                        return Marker(
                          point: bus['location'],
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () => setState(() => selectedBus = bus),
                            child: const Icon(
                              Icons.directions_bus,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: const Color(0xFFFECF4C).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black),
                ),
                child: selectedBus != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bus Number: ${selectedBus!['busNumber']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                          Text('Driver: ${selectedBus!['driver']}'),
                          Text('Phone: ${selectedBus!['phone']}'),
                          Text(
                            'Location: ${selectedBus!['location'].latitude}, ${selectedBus!['location'].longitude}',
                          ),
                        ],
                      )
                    : Text(
                        'Select a bus marker to see driver details.',
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFECF4C),
        child: const Icon(Icons.call, color: Colors.black),
        onPressed: () {
          if (selectedBus != null) {
            _makeCall(selectedBus!['phone']);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a driver first')),
            );
          }
        },
      ),
    );
  }
}

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  final String adminName = "Admin User";
  final String adminEmail = "admin@example.com";
  final String adminPhone = "+91 9876543210";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white, // Entire screen background is white
      body: Stack(
        children: [
          // Header section with Yellow background
          Container(
            height: size.height * 0.35,
            decoration: const BoxDecoration(
              color: Color(0xFFFECF4C), // Primary yellow
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),

                // Profile Avatar
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.white, Color(0xFFFECF4C)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.person, size: 60, color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Admin Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 40),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    child: ListView(
                      children: [
                        _infoCard(Icons.person, "Name", adminName),
                        const SizedBox(height: 16),
                        _infoCard(Icons.email, "Email", adminEmail),
                        const SizedBox(height: 16),
                        _infoCard(Icons.phone, "Mobile", adminPhone),
                        const SizedBox(height: 30),

                        ElevatedButton.icon(
                          icon: const Icon(Icons.lock_outline),
                          label: const Text("Change Password"),
                          onPressed: () => _showChangePasswordDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFECF4C),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        OutlinedButton.icon(
                          icon: const Icon(Icons.logout, color: Colors.black87),
                          label: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.black87),
                          ),
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                              color: Colors.black87,
                              width: 1.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFFECF4C), // Primary color border
          width: 1.6,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.black),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Old Password"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final oldPass = oldPasswordController.text;
              final newPass = newPasswordController.text;

              if (oldPass.isNotEmpty && newPass.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Password successfully changed."),
                  ),
                );
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
