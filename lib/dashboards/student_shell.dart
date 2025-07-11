import 'package:bus_theme/login_screens/student_login.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        height: 60.0,
        backgroundColor: Colors.transparent,
        color: Color(0xFFFECF4C),
        buttonBackgroundColor: Color(0xFFFECF4C),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items: <Widget>[
          Icon(
            Icons.dashboard,
            size: 30,
            color: selectedIndex == 0 ? Colors.black : Colors.black,
          ),
          Icon(
            Icons.notifications,
            size: 30,
            color: selectedIndex == 1 ? Colors.black : Colors.black,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: selectedIndex == 2 ? Colors.black : Colors.black,
          ),
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
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: const Color(0xFFFECF4C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
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
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'ID: ${selectedDriver!['driver_id']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Exp: ${selectedDriver!['experience']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Phone: ${selectedDriver!['phone']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Route: ${selectedDriver!['route_id']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFFFECF4C),
      ),
      body: Center(
        child: Text(
          'Notifications',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool arrivalNotifications = true;
  bool delayAlerts = true;
  bool generalUpdates = false;

  String name = 'Krupa';
  String studentId = '22MH1A4922';
  String email = 'krup@gmail.com';
  String phone = '+91 9876543210';

  Color primaryColor = const Color(0xFFFECF4C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const StudentLogin()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Student ID: $studentId',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            _sectionTitle("Contact Information"),
            _infoTile("Phone", phone),
            _infoTile("Email", email),
            const SizedBox(height: 20),
            _sectionTitle("Bus Information"),
            _infoTile("Bus Route", "Route 5 - College to Home"),
            _infoTile("Bus Number", "DL 1A 2345"),
            _infoTile("Stop Location", "Green Park - Bus Stop"),
            const SizedBox(height: 20),
            _sectionTitle("Notifications"),
            _switchTile(
              "Arrival Notifications",
              arrivalNotifications,
              (val) => setState(() => arrivalNotifications = val),
            ),
            _switchTile(
              "Delay Alerts",
              delayAlerts,
              (val) => setState(() => delayAlerts = val),
            ),
            _switchTile(
              "General Updates",
              generalUpdates,
              (val) => setState(() => generalUpdates = val),
            ),
            const SizedBox(height: 20),
            _sectionTitle("Emergency Contact"),
            _infoTile("Parent Contact", "+91 9123456780"),
            const SizedBox(height: 20),
            _sectionTitle("Settings"),
            ListTile(
              leading: Icon(Icons.lock, color: primaryColor),
              title: const Text(
                "Change Password",
                style: TextStyle(color: Colors.black),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.edit, color: primaryColor),
              title: const Text(
                "Update Profile",
                style: TextStyle(color: Colors.black),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black,
              ),
              onTap: () async {
                final updatedProfile = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      name: name,
                      email: email,
                      phone: phone,
                    ),
                  ),
                );
                if (updatedProfile != null) {
                  setState(() {
                    name = updatedProfile['name'];
                    email = updatedProfile['email'];
                    phone = updatedProfile['phone'];
                  });
                }
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.warning),
                label: const Text(
                  "SOS",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
      title: Text(
        label,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }

  Widget _switchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      activeColor: primaryColor,
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(color: Colors.black)),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  Color primaryColor = const Color(0xFFFECF4C);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField("Name", nameController),
            const SizedBox(height: 12),
            _buildTextField("Email", emailController),
            const SizedBox(height: 12),
            _buildTextField(
              "Phone",
              phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': nameController.text,
                  'email': emailController.text,
                  'phone': phoneController.text,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Save Changes",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber.shade700),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
