import 'package:flutter/material.dart';
import 'dart:math';

// MODEL: Tidak ada perubahan di sini, sudah bagus.
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

  @override
  void initState() {
    super.initState();
    // Panggil method untuk mengisi data dummy saat state diinisialisasi.
    _loadDummyHistory();
  }

  void _loadDummyHistory() {
    final dummyHistory = [
      ChatMessage(
        id: '1',
        text: "Halo, apa kabar?",
        mine: false,
        time: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        id: '2',
        text: "Baik! Kamu sendiri gimana?",
        mine: true,
        time: DateTime.now().subtract(const Duration(minutes: 9)),
      ),
      ChatMessage(
        id: '3',
        text: "Aku juga baik. Lagi sibuk apa sekarang?",
        mine: false,
        time: DateTime.now().subtract(const Duration(minutes: 9, seconds: 30)),
      ),
      ChatMessage(
        id: '4',
        text: "Lagi ngerjain project Flutter nih, seru banget! 😁",
        mine: true,
        time: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      ChatMessage(
        id: '5',
        text: "Wah, keren! Semangat ya!",
        mine: false,
        time: DateTime.now().subtract(const Duration(minutes: 7)),
      ),
    ];
    // PERBAIKAN 1: Menambahkan data dummy ke list utama.
    _messages.addAll(dummyHistory);
  }

  @override
  void dispose() {
    // PENTING: Selalu dispose controller untuk mencegah memory leak.
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
    );

    setState(() {
      _messages.add(msg);
      _controller.clear();
    });

    // Peningkatan: Scroll otomatis ke pesan terbaru.
    _scrollToBottom();

    // Simulasi balasan dari orang lain.
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
  }

  // Peningkatan: Fungsi untuk scroll ke paling bawah.
  void _scrollToBottom() {
    // Memberi sedikit jeda agar ListView sempat ter-update sebelum scroll.
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
    // Menggunakan tema dari context untuk konsistensi warna.
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // Peningkatan: AppBar yang lebih informatif dan rapi.
        elevation: 0.5,
        title: Row(
          children: const [
            CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
            ),
            SizedBox(width: 12),
            Text("Nama Kontak"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Dialog tetap sama, sudah cukup baik.
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Panggilan"),
                  content: const Text("Fitur panggilan belum tersedia."),
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
      // Peningkatan: Memberi warna latar yang sedikit berbeda agar tidak terlalu putih.
      backgroundColor: theme.canvasColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              // Peningkatan: Padding agar list tidak menempel di tepi.
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                // Peningkatan: Memisahkan UI bubble ke dalam widget sendiri agar lebih rapi.
                return _MessageBubble(message: msg, formatTime: _formatTime);
              },
            ),
          ),
          // Peningkatan: Memisahkan UI input ke dalam widget sendiri.
          _MessageInputField(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}

// WIDGET BARU: Gelembung Pesan (Message Bubble)
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.formatTime});

  final ChatMessage message;
  final String Function(DateTime) formatTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMine = message.mine;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        // Peningkatan: Menggunakan Card untuk mendapatkan efek shadow (elevation).
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
        // Peningkatan: Menggunakan warna dari tema aplikasi.
        color: isMine ? theme.colorScheme.primary : theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  color: isMine
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                // PERBAIKAN 2: Typo pada nama variabel.
                formatTime(message.time),
                style: TextStyle(
                  fontSize: 11,
                  color:
                      (isMine
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface)
                          .withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// WIDGET BARU: Input Pesan
class _MessageInputField extends StatelessWidget {
  const _MessageInputField({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(
        bottom:
            MediaQuery.of(context).padding.bottom + 8, // Menghindari keyboard
        top: 8,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              // Peningkatan: Memberi aksi saat keyboard menekan tombol "kirim".
              onSubmitted: (_) => onSend(),
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Ketik pesan...",
                filled: true,
                fillColor: theme.scaffoldBackgroundColor, // Warna lebih soft
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Peningkatan: Tombol kirim dibuat lebih menarik.
          FloatingActionButton.small(
            onPressed: onSend,
            elevation: 1,
            backgroundColor: theme.colorScheme.primary,
            child: Icon(Icons.send, color: theme.colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }
}
