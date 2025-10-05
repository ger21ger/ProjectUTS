import 'package:flutter/material.dart';
import 'package:appline/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.formatTime,
  });

  final ChatMessage message;
  final String Function(DateTime) formatTime;

  Widget _buildStatusIcon(BuildContext context) {
    IconData? icon;
    Color? color;

    switch (message.status) {
      case MessageStatus.sent:
        icon = Icons.check;
        color = Colors.grey;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = Colors.grey;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = Colors.blue.shade400;
        break;
    }
    return Icon(icon, size: 16, color: color);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMine = message.mine;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMine ? const Radius.circular(20) : Radius.zero,
            bottomRight: isMine ? Radius.zero : const Radius.circular(20),
          ),
        ),
        color: isMine ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  color: isMine ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatTime(message.time),
                    style: TextStyle(
                      fontSize: 11,
                      color: (isMine ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface).withOpacity(0.7),
                    ),
                  ),
                  if (isMine) ...[
                    const SizedBox(width: 5),
                    _buildStatusIcon(context),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}