import "package:firebase_core/firebase_core.dart";
import "package:chatflutter/firebase_options.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

import "check_user.dart";
import "home_page.dart";

void main() async {
  // Esse comando esta garantindo inicialização correta antes do flutter inciar
  WidgetsFlutterBinding.ensureInitialized();
  // Esse comando iniciliza o servidor
  await Firebase.initializeApp(
      // Menor ideia
      options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
  await FirebaseFirestore.instance
      .collection("col")
      .doc("doc")
      .set({"texto": "daniel"});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "ChatFlutter", home: Container());
  }
}
