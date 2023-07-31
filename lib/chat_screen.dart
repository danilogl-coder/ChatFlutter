import 'dart:io';

import 'package:chatflutter/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();

  void _getUser(){
    try {
      
    } catch (e) {
      
    }
  }

}

void _sendMessage({String? text, File? imgFile}) async {
  Map<String, dynamic> data = {};

  //Salvando imagem
  if (imgFile != null) {
    UploadTask task = FirebaseStorage.instance
        .ref()
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(imgFile);

    //Provalvel erro falta do onComplete
    TaskSnapshot taskSnapshot = await task;
    String url = await taskSnapshot.ref.getDownloadURL();
    data['imgUrl'] = url;
  }

  if (text != null) {
    data['text'] = text;
  }

  FirebaseFirestore.instance.collection("messeges").add(data);
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ola"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('messeges').snapshots(),
            builder: (context, snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                return Center(
                  child:CircularProgressIndicator(),
                );
                default:
                List<DocumentSnapshot> documents = snapshot.data!.docs.reversed.toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text(documents[index].get('text')),
                    );
                  },);
              }
            },)),
          TextComposer(sendMessage: _sendMessage),
        ],
      ),
    );
  }
}
