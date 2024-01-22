import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String content;
  final bool isMe;
  const ChatBubble({
    super.key,
    required this.content,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: isMe ? const EdgeInsets.only(right: 16) : const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: isMe
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.only(
          bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
          bottomRight: isMe ? Radius.zero : const Radius.circular(12),
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
        ),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 0.5,
            spreadRadius: 0.5,
            offset: isMe ? const Offset(1, 1) : const Offset(-1, 1),
          ),
        ],
      ),
      child: Text(
        content,
        style: TextStyle(
          color: isMe
              ? Theme.of(context).colorScheme.onTertiaryContainer
              : Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
