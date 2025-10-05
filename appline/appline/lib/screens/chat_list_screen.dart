import 'package:flutter/material.dart';
import '../models/chat_contact.dart';
import '../widgets/chat_contact_tile.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<ChatContact> chatContacts = [
    ChatContact(
      name: "Budi Santoso",
      lastMessage: "Lagi ngerjain project Flutter nih...",
      imageUrl: 'https://i.pravatar.cc/150?img=11',
      time: "10:05",
      unreadCount: 2,
      isOnline: true,
    ),
    ChatContact(
      name: "Citra Lestari",
      lastMessage: "Oke, nanti aku kabari lagi ya!",
      imageUrl: 'https://i.pravatar.cc/150?img=32',
      time: "09:48",
      unreadCount: 0,
      isOnline: false,
    ),
    ChatContact(
      name: "Grup Proyek UTS",
      lastMessage: "Jangan lupa deadline besok teman-teman.",
      imageUrl: 'https://i.pravatar.cc/150?img=5',
      time: "Kemarin",
      unreadCount: 5,
      isOnline: false, // Grup tidak memiliki status online
    ),
    ChatContact(
      name: "Dewi Anggraini",
      lastMessage: "Terima kasih banyak bantuannya!",
      imageUrl: 'https://i.pravatar.cc/150?img=25',
      time: "Kemarin",
      unreadCount: 0,
      isOnline: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: chatContacts.length,
        itemBuilder: (context, index) {
          final contact = chatContacts[index];
          return ChatContactTile(contact: contact);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}