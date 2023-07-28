import 'package:chatflutter/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

void _sendMessage(String text) {
  FirebaseFirestore.instance.collection("messeges").add({"text": text});
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ola"),
        elevation: 0,
      ),
      body: TextComposer(sendMessage: _sendMessage),
    );
  }
}
