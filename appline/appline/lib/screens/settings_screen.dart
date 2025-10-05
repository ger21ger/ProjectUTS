import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme_notifier.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../globals.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

 Future<String?> _pickChatWallpaper(BuildContext context) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);

  if (picked != null) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_wallpaper', picked.path);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chat wallpaper updated!')),
    );

    // Return path image sebagai string
    return picked.path;
  }

  // Jika tidak ada gambar yang dipilih, return null
  return null;
}


  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: themeNotifier.themeMode == ThemeMode.dark,
            onChanged: (val) {
              themeNotifier.toggleTheme();
            },
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: _notifications,
            onChanged: (val) => setState(() => _notifications = val),
            secondary: const Icon(Icons.notifications_outlined),
          ),
          ListTile(
            title: const Text('Profile'),
            leading: const Icon(Icons.person_outline),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile settings clicked')),
              );
            },
          ),
          ListTile(
            title: const Text('About'),
            leading: const Icon(Icons.info_outline),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Appline App',
                applicationVersion: '1.0.0',
                children: [const Text('Made with Flutter ❤️')],
              );
            },
          ),
          ListTile(
            title: const Text('Privacy'),
            leading: const Icon(Icons.lock_outline),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy settings clicked')),
              );
            },
          ),
         ListTile(
  title: const Text('Chat Wallpaper'),
  leading: const Icon(Icons.wallpaper),
  onTap: () async {
    String? path = await _pickChatWallpaper(context);

    if (path != null) {
      // Update global variable
      wallpaperPath = path;

      setState(() {
        // UI bisa menggunakan chatWallpaperPath
      });
    }
  },
),


          ListTile(
            title: const Text('Help'),
            leading: const Icon(Icons.help_outline),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Help & Support"),
                  content: const Text("For support, contact: support@example.com"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
