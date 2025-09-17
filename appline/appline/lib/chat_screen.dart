import 'package:flutter/material.dart';
import 'dart:math';

class ChatMessage {
  final String id;
  final String text;
  final bool mine;
  final DateTime time;

  ChatMessage({
    required this.id,
    required this.text,
    required this.mine,
    required this.time,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final msg = ChatMessage(
      id: Random().nextInt(10000).toString(),
      text: text,
      mine: true,
      time: DateTime.now(),
    );

    setState(() {
      _messages.add(msg);
      _controller.clear();
    });

    // Simulasi balasan
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(
          ChatMessage(
            id: Random().nextInt(10000).toString(),
            text: "Balasan: $text",
            mine: false,
            time: DateTime.now(),
          ),
        );
      });
    });
  }

  String _formatTime(DateTime t) {
    return "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        actions: [
          IconButton(
            onPressed: () {
              // Dummy Call Option
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Call"),
                  content: const Text("Panggilan Voice/Video masih dummy 🙂"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.call),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  alignment: msg.mine
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: msg.mine
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: msg.mine
                              ? const Color(0xFF00C300)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            color: msg.mine ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        _formatTime(msg.time),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ketik pesan...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Color(0xFF00C300)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
