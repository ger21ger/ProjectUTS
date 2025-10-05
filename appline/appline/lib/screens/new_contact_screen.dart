import 'package:flutter/material.dart';

class NewContactScreen extends StatelessWidget {
  const NewContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk daftar kontak
    final List<Map<String, String>> contacts = [
      {'name': 'Andi', 'imageUrl': 'https://i.pravatar.cc/150?img=1'},
      {'name': 'Bella', 'imageUrl': 'https://i.pravatar.cc/150?img=2'},
      {'name': 'Charlie', 'imageUrl': 'https://i.pravatar.cc/150?img=3'},
      {'name': 'Diana', 'imageUrl': 'https://i.pravatar.cc/150?img=4'},
      {'name': 'Eko', 'imageUrl': 'https://i.pravatar.cc/150?img=7'},
      {'name': 'Fara', 'imageUrl': 'https://i.pravatar.cc/150?img=8'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Kontak"),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(contact['imageUrl']!),
            ),
            title: Text(contact['name']!),
            onTap: () {
              Navigator.pop(context, contact);
            },
          );
        },
      ),
    );
  }
}