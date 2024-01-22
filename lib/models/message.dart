import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String content;
  final Timestamp createdAt;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.content,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> map) {
    return Message(
      senderId: map["senderId"],
      senderEmail: map["senderEmail"],
      receiverId: map["receiverId"],
      content: map["content"],
      createdAt: map["createdAt"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "senderEmail": senderEmail,
      "receiverId": receiverId,
      "content": content,
      "createdAt": createdAt,
    };
  }
}
