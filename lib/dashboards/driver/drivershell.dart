import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'driver_login.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  static const Color primaryColor = Color(0xFFFECF4C);
  static const Color textColor = Colors.black;
  static const Color cardBgColor = Colors.white;
  static const Color tileBgColor = Color(0xFFF7F7F7);

  Map<String, dynamic>? driverData;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fetchDriverData();
  }

  Future<void> _fetchDriverData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("drivers")
        .doc(uid)
        .get();

    setState(() {
      driverData = doc.data() as Map<String, dynamic>?;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // TODO: upload to Firebase Storage and save URL in Firestore
    }
  }

  @override
  Widget build(BuildContext context) {
    if (driverData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
        onPressed: _pickImage,
        backgroundColor: primaryColor,
        child: const Icon(Icons.edit, color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(),

          const SizedBox(height: 16),

          _buildSection('Personal Information', [
            _buildTile('Full Name', driverData!['name'] ?? 'N/A'),
            _buildTile('Contact Number', driverData!['phone'] ?? 'N/A'),
            _buildTile('Email Address', driverData!['email'] ?? 'N/A'),
            _buildTile('Address', driverData!['address'] ?? 'N/A'),
          ]),

          _buildSection('Driver Credentials & Licensing', [
            _buildTile('License No.', driverData!['licenseNo'] ?? 'N/A'),
            _buildTile('Validity', driverData!['licenseValidity'] ?? 'N/A'),
            _buildTile('Type', driverData!['licenseType'] ?? 'N/A'),
            _buildTile('Issuing Authority', driverData!['rto'] ?? 'N/A'),
          ]),

          _buildSection('Vehicle Details', [
            _buildTile('Bus ID', driverData!['busId'] ?? 'N/A'),
            _buildTile('Registration No.', driverData!['regNo'] ?? 'N/A'),
            _buildTile('Capacity', driverData!['capacity'] ?? 'N/A'),
            _buildTile(
              'Capacity Utilization',
              driverData!['capacityUtilization'] ?? 'N/A',
            ),
          ]),

          _buildSection('Experience & Qualifications', [
            _buildTile(
              'Years of Experience',
              driverData!['experienceYears']?.toString() ?? 'N/A',
            ),
            _buildTile('Past Records', driverData!['pastRecords'] ?? 'N/A'),
            _buildTile(
              'Certifications',
              driverData!['certifications'] ?? 'N/A',
            ),
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
          CircleAvatar(
            radius: 35,
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile!)
                : (driverData!['photoUrl'] != null
                          ? NetworkImage(driverData!['photoUrl'])
                          : null)
                      as ImageProvider?,
            backgroundColor: Colors.black,
            child: driverData!['photoUrl'] == null && _imageFile == null
                ? const Icon(Icons.person, size: 35, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driverData!['name'] ?? 'N/A',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
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
