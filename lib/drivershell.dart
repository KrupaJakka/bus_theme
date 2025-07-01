import 'package:bus_theme/driver_reports.dart';
import 'package:bus_theme/login_screens/driver_login.dart';
import 'package:bus_theme/trip_control_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DriverShell extends StatefulWidget {
  const DriverShell({super.key});
  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _index = 0;
  final _pages = const [
    TripControlPage(),
    DriverReportPage(),
    DriverProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: CurvedNavigationBar(
        index: _index,
        backgroundColor: Colors.transparent, // Transparent behind the nav bar
        color: Color(0xFFFECF4C), // Your Yellow Theme
        buttonBackgroundColor: Color(
          0xFFFECF4C,
        ), // Same yellow for the active button
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.play_arrow, color: Colors.black),
          Icon(Icons.report, color: Colors.black),
          Icon(Icons.person, color: Colors.black),
        ],
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  static const Color primaryColor = Color(0xFFFECF4C); // Yellow
  static const Color textColor = Colors.black;
  static const Color cardBgColor = Colors.white;
  static const Color tileBgColor = Color(
    0xFFF7F7F7,
  ); // Light grey tile background

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DriverLogin()),
              );
            },
          ),
        ],
        title: const Text(
          'Driver Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example action like Edit Profile or Settings
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.edit, color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(),

          const SizedBox(height: 16),

          _buildSection('Personal Information', [
            _buildTile('Full Name', 'Ravi Kumar'),
            _buildTile('Contact Number', '+91 9876543210'),
            _buildTile('Email Address', 'ravi.kumar@college.com'),
            _buildTile('Address', '15/6 East Street, Hyderabad'),
          ]),

          _buildSection('Driver Credentials & Licensing', [
            _buildTile('License No.', 'AP-123456789'),
            _buildTile('Validity', '12/12/2028'),
            _buildTile('Type', 'Commercial'),
            _buildTile('Issuing Authority', 'RTO Hyderabad'),
          ]),

          _buildSection('Vehicle Details', [
            _buildTile('Bus ID', 'BUS-21'),
            _buildTile('Registration No.', 'AP09BN8726'),
            _buildTile('Capacity', '45 Seats'),
            _buildTile('Capacity Utilization', '80%'),
          ]),

          _buildSection('Experience & Qualifications', [
            _buildTile('Years of Experience', '8'),
            _buildTile('Past Records', 'Clean'),
            _buildTile('Certifications', 'Defensive Driving, First Aid'),
          ]),

          _buildSection('Profile Security', [
            _buildTile('Username', 'ravi_driver'),
            _buildTile('Password', '**********'),
            _buildTile('2FA Status', 'Enabled'),
          ]),

          _buildSection('Employment Details', [
            _buildTile('Hiring Date', '01/04/2018'),
            _buildTile('Department', 'Transportation'),
            _buildTile('Shift', 'Morning: 6am - 2pm'),
            _buildTile('Supervisor', 'Mr. Srinivas Rao'),
          ]),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.black,
            child: Icon(Icons.person, size: 35, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Ravi Kumar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Professional Bus Driver',
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: cardBgColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tileBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
