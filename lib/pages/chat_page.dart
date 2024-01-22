import 'package:chat/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../components/chat_bubble.dart';
import '../models/message.dart';
import '../service/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverEmail;

  ChatPage({
    super.key,
    required this.receiverId,
    required this.receiverEmail,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _msgController = TextEditingController();

  final _authService = AuthService();
  final _chatService = ChatService();

  final _scrollController = ScrollController();
  final focusNode = FocusNode();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 40,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), scrollDown);
      }
    });
    Future.delayed(const Duration(milliseconds: 500), scrollDown);
  }

  @override
  void dispose() {
    focusNode.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void sendMessageForButton() async {
    if (_msgController.text.isNotEmpty) {
      await _chatService.sendMessage(
        receiverId: widget.receiverId,
        message: _msgController.text,
      );
    }

    _msgController.clear();
    scrollDown();
  }

  void sendMessageForEnter(String value) async {
    if (value.isNotEmpty) {
      await _chatService.sendMessage(
        receiverId: widget.receiverId,
        message: value,
      );
    }

    _msgController.clear();
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(context),
            ),
            _buildMessageInputField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverId),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // success
        return ListView.builder(
          controller: _scrollController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            Message message = snapshot.data![index];
            bool isMe = message.senderId == _authService.getCurrentUser()!.uid;
            return Container(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(
                children: [
                  ChatBubble(
                    content: message.content,
                    isMe: isMe,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInputField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              focusNode: focusNode,
              onSubmitted: sendMessageForEnter,
              controller: _msgController,
              decoration: const InputDecoration(
                hintText: "messages...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                // fillColor: Theme.of(context).colorScheme.secondaryContainer,
                // filled: true,
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessageForButton,
            icon: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.send,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
