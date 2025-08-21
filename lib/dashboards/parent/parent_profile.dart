import 'package:bus_theme/login_screens/parent_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentSettingsPage extends StatefulWidget {
  const ParentSettingsPage({super.key});
  @override
  State<ParentSettingsPage> createState() => _ParentSettingsPageState();
}

class _ParentSettingsPageState extends State<ParentSettingsPage> {
  bool arrivalAlerts = true;
  bool delayAlerts = false;
  bool broadcastAlerts = true;
  bool darkMode = true;
  String language = 'English';

  final _languages = ['English', 'Hindi', 'Tamil', 'Kannada'];

  Color get primaryColor => const Color(0xFFFECF4C);
  Color get secondaryColor => Colors.black;
  Color get bgColor => Colors.white;

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      ),
    ),
  );

  Future<void> _callDriver() async {
    const tel = 'tel:+919876543210';
    if (await canLaunchUrl(Uri.parse(tel))) {
      await launchUrl(Uri.parse(tel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Settings', style: TextStyle(color: secondaryColor)),
        iconTheme: IconThemeData(color: secondaryColor),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: secondaryColor),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ParentLogin()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: primaryColor,
              child: Text(
                'AJ', // Initials for Alex Johnson
                style: TextStyle(
                  color: bgColor,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Alex Johnson',
              style: TextStyle(
                color: secondaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Center(
            child: Text(
              'ID: P1234567',
              style: TextStyle(
                color: secondaryColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
          _section('Preferences'),
          SwitchListTile.adaptive(
            value: darkMode,
            onChanged: (v) => setState(() => darkMode = v),
            title: Text('Dark Mode', style: TextStyle(color: secondaryColor)),
            secondary: Icon(Icons.dark_mode, color: primaryColor),
          ),
          ListTile(
            leading: Icon(Icons.language, color: primaryColor),
            title: Text('Language', style: TextStyle(color: secondaryColor)),
            subtitle: Text(language, style: TextStyle(color: secondaryColor)),
            trailing: Icon(Icons.chevron_right, color: secondaryColor),
            onTap: () async {
              final sel = await showModalBottomSheet<String>(
                context: context,
                builder: (ctx) => Container(
                  color: bgColor,
                  child: ListView(
                    children: _languages
                        .map(
                          (lang) => ListTile(
                            title: Text(
                              lang,
                              style: TextStyle(color: secondaryColor),
                            ),
                            onTap: () => Navigator.pop(ctx, lang),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
              if (sel != null) setState(() => language = sel);
            },
          ),
          _section('Notifications'),
          SwitchListTile.adaptive(
            value: arrivalAlerts,
            onChanged: (v) => setState(() => arrivalAlerts = v),
            title: Text(
              'Bus Arrival Alerts',
              style: TextStyle(color: secondaryColor),
            ),
            secondary: Icon(Icons.directions_bus, color: primaryColor),
          ),
          SwitchListTile.adaptive(
            value: delayAlerts,
            onChanged: (v) => setState(() => delayAlerts = v),
            title: Text(
              'Delay Notifications',
              style: TextStyle(color: secondaryColor),
            ),
            secondary: Icon(Icons.access_time, color: primaryColor),
          ),
          SwitchListTile.adaptive(
            value: broadcastAlerts,
            onChanged: (v) => setState(() => broadcastAlerts = v),
            title: Text(
              'Broadcast Announcements',
              style: TextStyle(color: secondaryColor),
            ),
            secondary: Icon(Icons.campaign, color: primaryColor),
          ),
          _section('Support'),
          ListTile(
            leading: Icon(Icons.contact_phone, color: primaryColor),
            title: Text(
              'Driver Contact',
              style: TextStyle(color: secondaryColor),
            ),
            subtitle: Text(
              '+91 98765 43210',
              style: TextStyle(color: secondaryColor),
            ),
            trailing: IconButton(
              icon: Icon(Icons.call, color: primaryColor),
              onPressed: _callDriver,
            ),
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: primaryColor),
            title: Text('Help & FAQs', style: TextStyle(color: secondaryColor)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: primaryColor),
            title: Text('About App', style: TextStyle(color: secondaryColor)),
            subtitle: Text(
              'Version 1.0.0',
              style: TextStyle(color: secondaryColor),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
