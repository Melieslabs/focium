import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = true;
  bool notificationsEnabled = true;


  Widget _settingsTile({
    required String title,
    String? subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Color(0xFFD9D9D9)),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: Color(0xFF777777)))
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(
              color: Color(0xFFD9D9D9),
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _settingsTile(
            title: "Dark Mode",
            trailing: Switch(
              activeColor: Colors.white,
              inactiveThumbColor: const Color(0xFF777777),
              value: darkMode,
              onChanged: (v) => setState(() => darkMode = v),
            ),
          ),
          _settingsTile(
            title: "Notifications",
            trailing: Switch(
              inactiveThumbColor: const Color(0xFF777777),
              value: notificationsEnabled,
              onChanged: (v) => setState(() => notificationsEnabled = v),
            ),
          ),
        ],
      ),
    );
  }
}
