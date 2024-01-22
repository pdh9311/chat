import 'package:chat/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/member.dart';
import '../service/chat_service.dart';
import 'chat_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _chatService = ChatService();
  final _authService = AuthService();

  void logout(BuildContext context) {
    context.read<AuthService>().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User user = context.read<AuthService>().getCurrentUser()!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(user.email!),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: StreamBuilder(
        stream: _chatService.getMembers(),
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
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Member member = snapshot.data![index];
              if (_authService.getCurrentUser()!.email == member.email) {
                return Container();
              }
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.inversePrimary,
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.secondaryContainer,
                    ],
                  ),
                  // color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    topLeft: Radius.circular(60),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      spreadRadius: 1,
                      blurRadius: 0.5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          receiverId: member.uid,
                          receiverEmail: member.email,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: Text(
                      member.email,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
      ),
    );
  }
}
