import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_field.dart';
import '../globals.dart';

class ChatScreen extends StatefulWidget {
  final String contactName;
  final String contactImageUrl;

  const ChatScreen({
    super.key,
    required this.contactName,
    required this.contactImageUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadDummyHistory();
    _loadWallpaper();
  }

  Future<void> _loadWallpaper() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      wallpaperPath = prefs.getString('chat_wallpaper');
    });
  }

  void _loadDummyHistory() {
    final dummyHistory = [
      ChatMessage(
        id: '1',
        text: "Halo, apa kabar?",
        mine: false,
        time: DateTime.now().subtract(const Duration(minutes: 10)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '2',
        text: "Baik! Kamu sendiri gimana?",
        mine: true,
        time: DateTime.now().subtract(const Duration(minutes: 9)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '3',
        text: "Aku juga baik. Lagi sibuk apa sekarang?",
        mine: false,
        time: DateTime.now().subtract(const Duration(minutes: 9, seconds: 30)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '4',
        text: "Lagi ngerjain project Flutter nih, seru banget! 😁",
        mine: true,
        time: DateTime.now().subtract(const Duration(minutes: 8)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '5',
        text: "Wah, keren! Semangat ya!",
        mine: false,
        time: DateTime.now().subtract(const Duration(minutes: 7)),
        status: MessageStatus.read,
      ),
    ];
    _messages.addAll(dummyHistory);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final msg = ChatMessage(
      id: Random().nextInt(10000).toString(),
      text: text,
      mine: true,
      time: DateTime.now(),
      status: MessageStatus.sent,
    );

    setState(() {
      _messages.add(msg);
      _controller.clear();
    });

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 800), () {
      final reply = ChatMessage(
        id: Random().nextInt(10000).toString(),
        text: "Ok, saya terima pesannya: \"$text\"",
        mine: false,
        time: DateTime.now(),
      );
      setState(() {
        _messages.add(reply);
      });
      _scrollToBottom();
    });

    Future.delayed(const Duration(seconds: 2), () {
      final index = _messages.indexWhere((m) => m.id == msg.id);
      if (index != -1) {
        setState(() {
          _messages[index] = _messages[index].copyWith(status: MessageStatus.delivered);
        });
      }
    });
    Future.delayed(const Duration(seconds: 4), () {
      final index = _messages.indexWhere((m) => m.id == msg.id);
      if (index != -1) {
        setState(() {
          _messages[index] = _messages[index].copyWith(status: MessageStatus.read);
        });
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime t) {
    return "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.contactImageUrl)),
            const SizedBox(width: 12),
            Text(widget.contactName),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implementasi panggilan suara
            },
            icon: const Icon(Icons.call),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: wallpaperPath != null
              ? DecorationImage(
                  image: FileImage(File(wallpaperPath!)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return MessageBubble(message: msg, formatTime: _formatTime);
                },
              ),
            ),
            MessageInputField(controller: _controller, onSend: _sendMessage),
          ],
        ),
      ),
    );
  }
}
