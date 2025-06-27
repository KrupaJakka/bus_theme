import 'package:flutter/material.dart';
import 'package:bus_theme/student_details.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  static const Color primaryColor = Color(0xFFFECF4C);
  static const Color textColor = Colors.black;
  static const Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              DashboardBox(
                title: "Students",
                description: "Manage student profiles",
                icon: Icons.person,
              ),
              SizedBox(height: 20),
              DashboardBox(
                title: "Drivers",
                description: "Manage driver accounts",
                icon: Icons.directions_bus_filled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardBox extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const DashboardBox({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  static const Color primaryColor = Color(0xFFFECF4C);
  static const Color textColor = Colors.black;
  static const Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: primaryColor.withOpacity(0.2),
            child: Icon(icon, size: 30, color: primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentApp()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              "View Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
