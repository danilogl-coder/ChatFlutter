import "package:firebase_core/firebase_core.dart";
import "package:chatflutter/firebase_options.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

import "chat_screen.dart";
import "check_user.dart";
import "home_page.dart";

void main() async {
  // Esse comando esta garantindo inicialização correta antes do flutter iniciar
  WidgetsFlutterBinding.ensureInitialized();
  // Esse comando iniciliza o servidor
  await Firebase.initializeApp(
      // Menor ideia
      options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "ChatFlutter",
        theme: ThemeData(
            primarySwatch: Colors.blue,
            iconTheme: IconThemeData(color: Colors.blue)),
        home: ChatScreen());
  }
}
