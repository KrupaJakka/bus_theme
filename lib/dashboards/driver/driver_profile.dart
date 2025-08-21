import 'package:bus_theme/login_screens/driver_login.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DevicePreview(builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Tracking',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFECF4C)),
      home: const DriverProfileScreen(),
    );
  }
}

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text('Driver Profile'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: const [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.black),
                ),

                SizedBox(height: 10),
                Text(
                  'Ravi Kumar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),

            _buildCard('👤 Personal Information', [
              _buildTile('Full Name', 'Ravi Kumar'),
              _buildTile('Contact Number', '+91 9876543210'),
              _buildTile('Email Address', 'ravi.kumar@college.com'),
              _buildTile('Address', '15/6 East Street, Hyderabad'),
            ]),

            _buildCard('📄 Driver Credentials & Licensing', [
              _buildTile('License No.', 'AP-123456789'),
              _buildTile('Validity', '12/12/2028'),
              _buildTile('Type', 'Commercial'),
              _buildTile('Issuing Authority', 'RTO Hyderabad'),
            ]),

            _buildCard('🚌 Vehicle Details', [
              _buildTile('Bus ID/Number', 'BUS-21'),
              _buildTile('Registration No.', 'AP09BN8726'),
              _buildTile('Capacity', '45'),
              _buildTile('Capacity Utilization', '80%'),
            ]),

            _buildCard('🎓 Experience & Qualifications', [
              _buildTile('Years of Experience', '8'),
              _buildTile('Past Records', 'Clean'),
              _buildTile('Certifications', 'Defensive Driving, First Aid'),
            ]),

            _buildCard('🔐 Profile Security', [
              _buildTile('Username', 'ravi_driver'),
              _buildTile('Password', 'Encrypted'),
              _buildTile('2FA Status', 'Enabled'),
            ]),

            _buildCard('💼 Employment Details', [
              _buildTile('Hiring Date', '01/04/2018'),
              _buildTile('Department', 'Transportation'),
              _buildTile('Shift', 'Morning: 6am - 2pm'),
              _buildTile('Supervisor', 'Mr. Srinivas Rao'),
            ]),
          ],
        ),
      ),
    );
  }

  static Widget _buildTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.black87)),
      dense: true,
    );
  }

  static Widget _buildCard(String heading, List<Widget> children) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}
