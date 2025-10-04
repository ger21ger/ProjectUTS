import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Data profil
  String name = "Hansel Yohanes";
  String status = "Keep moving forward 🚀";
  String phone = "+62 812-3456-7890";
  String email = "hansel@example.com";
  String location = "Jakarta, Indonesia";

  // === PILIH GAMBAR ===
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile photo updated ✅")));
    }
  }

  // === EDIT PROFILE DALAM SATU DIALOG ===
  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: name);
    final phoneController = TextEditingController(text: phone);
    final emailController = TextEditingController(text: email);
    final locationController = TextEditingController(text: location);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              setState(() {
                name = nameController.text;
                phone = phoneController.text;
                email = emailController.text;
                location = locationController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile updated ✅")),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // === Header ===
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/images/profile.jpg')
                                as ImageProvider,
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        status,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.qr_code_2,
                    size: 32,
                    color: Colors.black87,
                  ),
                  onPressed: () => _showSnackBar("QR Code tapped!"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // === Tombol Aksi ===
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _profileButton(Icons.edit, "Edit Profile", _editProfile),
                _profileButton(Icons.photo_camera, "Change Photo", _pickImage),
                _profileButton(
                  Icons.settings,
                  "Settings",
                  () => _showSnackBar("Settings clicked"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // === Info ===
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _infoTile(Icons.phone, "Phone", phone),
                _infoTile(Icons.email, "Email", email),
                _infoTile(Icons.location_on, "Location", location),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _profileButton(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.green, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  static Widget _infoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
