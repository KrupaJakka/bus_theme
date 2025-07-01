import 'package:bus_theme/login_screens/admin_login.dart';
import 'package:bus_theme/login_screens/driver_login.dart';
import 'package:bus_theme/login_screens/parent_login.dart';
import 'package:bus_theme/login_screens/student_login.dart';
import 'package:flutter/material.dart';
import 'package:bus_theme/dashboards/Adminshell.dart';

void main() {
  runApp(const RoleSelectionApp());
}

class RoleSelectionApp extends StatelessWidget {
  const RoleSelectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const RoleSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String selectedRole = '';

  void selectRole(String role) {
    setState(() {
      selectedRole = role;
    });

    // Navigate to the correct screen based on role
    switch (role) {
      case 'Driver':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DriverLogin()),
        );
        break;
      case 'Parent':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ParentLogin()),
        );
        break;
      case 'Student':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StudentLogin()),
        );
        break;
      case 'Admin':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminLogin()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Section: Role Selection
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFFFECF4C),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose your ROLE',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),

                  RoleOption(
                    icon: Icons.directions_bus,
                    title: 'Driver',
                    selected: selectedRole == 'Driver',
                    onTap: () => selectRole('Driver'),
                  ),
                  const SizedBox(height: 16),

                  RoleOption(
                    icon: Icons.people_alt,
                    title: 'Parent',
                    selected: selectedRole == 'Parent',
                    onTap: () => selectRole('Parent'),
                  ),
                  const SizedBox(height: 16),

                  RoleOption(
                    icon: Icons.school,
                    title: 'Student',
                    selected: selectedRole == 'Student',
                    onTap: () => selectRole('Student'),
                  ),
                  const SizedBox(height: 16),

                  RoleOption(
                    icon: Icons.badge,
                    title: 'Admin',
                    selected: selectedRole == 'Admin',
                    onTap: () => selectRole('Admin'),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              width: 300,
              height: 900,
              child: Image.asset("assets/b1.jpg", fit: BoxFit.fill),
            ),
          ),
        ],
      ),
    );
  }
}

class RoleOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const RoleOption({
    super.key,
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFCE7A0) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.black),
            const SizedBox(height: 12),
            const Text(
              'Continue as',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
