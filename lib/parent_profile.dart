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
  Widget _section(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    ),
  );

  Future<void> _callDriver() async {
    const tel = 'tel:+919876543210';
    if (await canLaunchUrl(Uri.parse(tel))) await launchUrl(Uri.parse(tel));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
          _section('Account'),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('Alex Johnson'),
            subtitle: const Text('alex.parent@example.com'),
            trailing: TextButton(onPressed: () {}, child: const Text('Edit')),
          ),
          _section('Preferences'),
          SwitchListTile.adaptive(
            value: darkMode,
            onChanged: (v) => setState(() => darkMode = v),
            title: const Text('Dark Mode'),
            secondary: Icon(Icons.dark_mode, color: cs.secondary),
          ),
          ListTile(
            leading: Icon(Icons.language, color: cs.secondary),
            title: const Text('Language'),
            subtitle: Text(language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final sel = await showModalBottomSheet<String>(
                context: context,
                builder: (ctx) => ListView(
                  children: _languages
                      .map(
                        (lang) => ListTile(
                          title: Text(lang),
                          onTap: () => Navigator.pop(ctx, lang),
                        ),
                      )
                      .toList(),
                ),
              );
              if (sel != null) setState(() => language = sel);
            },
          ),
          _section('Notifications'),
          SwitchListTile.adaptive(
            value: arrivalAlerts,
            onChanged: (v) => setState(() => arrivalAlerts = v),
            title: const Text('Bus Arrival Alerts'),
            secondary: Icon(Icons.directions_bus, color: cs.secondary),
          ),
          SwitchListTile.adaptive(
            value: delayAlerts,
            onChanged: (v) => setState(() => delayAlerts = v),
            title: const Text('Delay Notifications'),
            secondary: Icon(Icons.access_time, color: cs.secondary),
          ),
          SwitchListTile.adaptive(
            value: broadcastAlerts,
            onChanged: (v) => setState(() => broadcastAlerts = v),
            title: const Text('Broadcast Announcements'),
            secondary: Icon(Icons.campaign, color: cs.secondary),
          ),
          _section('Support'),
          ListTile(
            leading: Icon(Icons.contact_phone, color: cs.primary),
            title: const Text('Driver Contact'),
            subtitle: const Text('+91 98765 43210'),
            trailing: IconButton(
              icon: const Icon(Icons.call),
              onPressed: _callDriver,
            ),
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: cs.primary),
            title: const Text('Help & FAQs'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: cs.primary),
            title: const Text('About App'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
