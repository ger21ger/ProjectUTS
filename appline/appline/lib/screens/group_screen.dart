import 'package:flutter/material.dart';
import 'chat_screen.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  final List<String> groups = const [
    "Flutter Devs",
    "Game Development",
    "Appline Family",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Groups")),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.group),
            title: Text(groups[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    // Mengirim nama grup sesuai item yang di-klik
                    contactName: groups[index],
                    // Mengirim URL gambar placeholder untuk grup
                    contactImageUrl: 'https://i.pravatar.cc/150?img=5',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
