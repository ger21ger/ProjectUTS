
class ChatContact {
  final String name;
  final String lastMessage;
  final String imageUrl;
  final String time;
  final int unreadCount;
  final bool isOnline;

  ChatContact({
    required this.name,
    required this.lastMessage,
    required this.imageUrl,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
  });
}