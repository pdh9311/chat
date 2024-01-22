import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/member.dart';
import '../models/message.dart';

class ChatService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _createChatRoomId(String senderId, String receiverId) {
    final List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return chatRoomId;
  }

  Stream<List<Member>> getMembers() {
    return _firestore
        .collection("members")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Member.fromJson(doc.data())).toList());
  }

  Future<void> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    final msg = Message(
      senderId: _auth.currentUser!.uid,
      senderEmail: _auth.currentUser!.email!,
      receiverId: receiverId,
      content: message,
      createdAt: Timestamp.now(),
    );

    // chat room id : an underline comes between two aligned user ids
    String chatRoomId = _createChatRoomId(msg.senderId, msg.receiverId);

    // send message
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(msg.toJson());
  }

  Stream<List<Message>> getMessages(String receiverId) {
    String chatRoomId = _createChatRoomId(_auth.currentUser!.uid, receiverId);

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }
}
