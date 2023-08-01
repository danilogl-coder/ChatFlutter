import 'dart:io';

import 'package:chatflutter/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();

 

}



class _ChatScreenState extends State<ChatScreen> {

  //Cadastro com google
 final GoogleSignIn googleSignIn = GoogleSignIn();
 //Barra de erro
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
 User ?_currentUser;
  @override
  void initState()
  {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) { 
      setState(() {
       _currentUser = user;
      });
    });
  }

  Future _getUser() async {
    if(_currentUser != null){
      return _currentUser;
    }
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final User ?user = authResult.user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }



  void _sendMessage({String? text, File? imgFile}) async {
  final User user = await _getUser();

  if(user == null){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Não foi possível fazer o login. tente novamente"), backgroundColor: Colors.red,));
  }
  Map<String, dynamic> data = {
    "uid" : user.uid,
    "senderNamer" : user.displayName,
    "senderPhotoURL" : user.photoURL
  };

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
