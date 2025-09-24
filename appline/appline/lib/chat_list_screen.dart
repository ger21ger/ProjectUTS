import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Impor halaman chat screen yang sudah Anda buat

// MODEL DATA (bisa diletakkan di sini atau di file terpisah)
class ChatContact {
  final String name;
  final String lastMessage;
  final String imageUrl;
  final String time;
  final int unreadCount;

  ChatContact({
    required this.name,
    required this.lastMessage,
    required this.imageUrl,
    required this.time,
    required this.unreadCount,
  });
}

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // DATA DUMMY UNTUK DAFTAR KONTAK
  final List<ChatContact> chatContacts = [
    ChatContact(
      name: "Budi Santoso",
      lastMessage: "Lagi ngerjain project Flutter nih...",
      imageUrl: 'https://i.pravatar.cc/150?img=11',
      time: "10:05",
      unreadCount: 2,
    ),
    ChatContact(
      name: "Citra Lestari",
      lastMessage: "Oke, nanti aku kabari lagi ya!",
      imageUrl: 'https://i.pravatar.cc/150?img=32',
      time: "09:48",
      unreadCount: 0,
    ),
    ChatContact(
      name: "Grup Proyek UTS",
      lastMessage: "Jangan lupa deadline besok teman-teman.",
      imageUrl: 'https://i.pravatar.cc/150?img=5',
      time: "Kemarin",
      unreadCount: 5,
    ),
    ChatContact(
      name: "Dewi Anggraini",
      lastMessage: "Terima kasih banyak bantuannya!",
      imageUrl: 'https://i.pravatar.cc/150?img=25',
      time: "Kemarin",
      unreadCount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: chatContacts.length,
        itemBuilder: (context, index) {
          final contact = chatContacts[index];
          return Column(
            children: [
              // Menggunakan ListTile untuk struktur yang rapi
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(contact.imageUrl),
                ),
                title: Text(
                  contact.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  contact.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      contact.time,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Tampilkan badge notifikasi jika ada pesan belum dibaca
                    if (contact.unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          contact.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 22),
                  ],
                ),
                onTap: () {
                  // Aksi Navigasi ke Halaman Chat Detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ChatScreen(), // Nanti kita modifikasi ini
                    ),
                  );
                },
              ),
              const Divider(height: 1, indent: 80, endIndent: 16),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
