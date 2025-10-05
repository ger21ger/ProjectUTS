import 'package:flutter/material.dart';
import '../models/chat_contact.dart';

class ChatContactTile extends StatelessWidget {
  final ChatContact contact;
  final VoidCallback onTap;

  const ChatContactTile({
    super.key,
    required this.contact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(contact.imageUrl),
              ),
              if (contact.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(contact.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(contact.time, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              const SizedBox(height: 2),
              if (contact.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    contact.unreadCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              else
                const SizedBox(height: 22) // Placeholder agar rata
            ],
          ),
          onTap: onTap,
        ),
        const Divider(height: 1, indent: 90, endIndent: 16),
      ],
    );
  }
}