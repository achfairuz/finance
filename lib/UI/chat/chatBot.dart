import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  bool isSearching = false;
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _controller.text.trim(),
          'isUser': true,
        });
        _controller.clear();
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _messages.add({
            'text': 'Halo saya bot',
            'isUser': false,
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredMessages = _searchText.isEmpty
        ? _messages
        : _messages.where((msg) {
            final text = msg['text'].toString().toLowerCase();
            return text.contains(_searchText);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _searchText = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Cari pesan...',
                  border: InputBorder.none,
                ),
              )
            : Align(
                alignment: Alignment.center,
                child: Text(
                  'Chat Bot',
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
            icon: Icon(
              Icons.search,
              size: AppSizes.iconSize,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              reverse: true,
              itemBuilder: (context, index) {
                final message =
                    filteredMessages[filteredMessages.length - 1 - index];
                final isUser = message['isUser'] as bool;

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.primary : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: AppSizes.fontBase,
                      ),
                    ),
                  ),
                );
              },
              itemCount: filteredMessages.length,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 150, right: 8, left: 8, top: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: AppColors.primary,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
