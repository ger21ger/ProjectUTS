import 'package:flutter/material.dart';
import '../models/chat_contact.dart';
import '../widgets/chat_contact_tile.dart';
import 'chat_screen.dart';
import 'new_contact_screen.dart';
import 'settings_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<ChatContact> _filteredContacts = [];

  var _allContacts = [
    ChatContact(name: "Budi Santoso", lastMessage: "Lagi ngerjain project Flutter nih...", imageUrl: 'https://i.pravatar.cc/150?img=11', time: "10:05", unreadCount: 2, isOnline: true),
    ChatContact(name: "Citra Lestari", lastMessage: "Oke, nanti aku kabari lagi ya!", imageUrl: 'https://i.pravatar.cc/150?img=32', time: "09:48", unreadCount: 0, isOnline: false),
    ChatContact(name: "Grup Proyek UTS", lastMessage: "Jangan lupa deadline besok teman-teman.", imageUrl: 'https://i.pravatar.cc/150?img=5', time: "Kemarin", unreadCount: 5, isOnline: false),
    ChatContact(name: "Dewi Anggraini", lastMessage: "Terima kasih banyak bantuannya!", imageUrl: 'https://i.pravatar.cc/150?img=25', time: "Kemarin", unreadCount: 0, isOnline: true),
  ];

  @override
  void initState() {
    super.initState();
    _filteredContacts = _allContacts;
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterContacts);
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _allContacts.where((contact) {
        return contact.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  void _navigateToChat(BuildContext context, ChatContact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          contactName: contact.name,
          contactImageUrl: contact.imageUrl,
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _stopSearch,
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari...',
            border: InputBorder.none,
          ),
        ),
      );
    } else {
      return AppBar(
        title: const Text("Chats", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _startSearch),
          PopupMenuButton<String>(
            onSelected: (value) {
             if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView.builder(
        itemCount: _filteredContacts.length,
        itemBuilder: (context, index) {
          final contact = _filteredContacts[index];
          return ChatContactTile(
            contact: contact,
            onTap: () => _navigateToChat(context, contact),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Map<String, String>>(
            context,
            MaterialPageRoute(builder: (context) => const NewContactScreen()),
          );

          if (result != null && mounted) {
            final newContact = ChatContact(
              name: result['name']!,
              imageUrl: result['imageUrl']!,
              lastMessage: "",
              time: "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
              unreadCount: 0,
              isOnline: true,
            );

            setState(() {
              _allContacts.insert(0, newContact);
              _filterContacts();
            });
            
            _navigateToChat(context, newContact);
          }
        },
        child: const Icon(Icons.message_outlined),
      ),
    );
  }
}