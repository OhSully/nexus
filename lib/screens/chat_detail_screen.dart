import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.contactName,
    this.startEmpty = false,
    this.onMessageSent,
  });

  final String contactName;
  final bool startEmpty;
  final ValueChanged<String>? onMessageSent;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late final TextEditingController _messageController;
  late final ScrollController _scrollController;
  late final List<(String, String, bool)> _messages;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _messages = widget.startEmpty
        ? []
        : [
            (widget.contactName, 'Hey! Are you still up for the hike?', true),
            ('You', 'Yep, let’s meet at 8am.', false),
            (widget.contactName, 'Perfect, I’ll bring water.', true),
          ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(('You', text, false));
      _messageController.clear();
    });
    widget.onMessageSent?.call(text);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.contactName}')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final (sender, text, isIncoming) = _messages[index];
                  final alignment = isIncoming
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end;

                  return Align(
                    alignment: isIncoming
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: alignment,
                      children: [
                        Text(
                          sender,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isIncoming
                                ? Colors.grey.shade200
                                : AppColors.brand,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            text,
                            style: TextStyle(
                              color: isIncoming ? Colors.black87 : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: _sendMessage,
                    tooltip: 'Send message',
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
