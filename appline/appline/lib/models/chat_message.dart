
enum MessageStatus { sent, delivered, read }

class ChatMessage {
  final String id;
  final String text;
  final bool mine;
  final DateTime time;
  final MessageStatus status;

  ChatMessage({
    required this.id,
    required this.text,
    required this.mine,
    required this.time,
    this.status = MessageStatus.sent,
  });

  ChatMessage copyWith({
    MessageStatus? status,
  }) {
    return ChatMessage(
      id: id,
      text: text,
      mine: mine,
      time: time,
      status: status ?? this.status,
    );
  }
}