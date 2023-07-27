import "package:firebase_core/firebase_core.dart";
import "package:chatflutter/firebase_options.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

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
  //FirebaseFirestore.instance cria uma instancia do App inteiro set Lê e cria
  FirebaseFirestore.instance
      .collection("Mensagens")
      .doc("3P0p2tXUswKKb8056QuG")
      .set({"texto": "Hola", "from": "Diego", "read": true});
  //Atualiza coisa especifica
  FirebaseFirestore.instance
      .collection("Mensagens")
      .doc("3P0p2tXUswKKb8056QuG")
      .update({"read": false});
  //Podemos criar subcoleções
  FirebaseFirestore.instance
      .collection("Mensagens")
      .doc("3P0p2tXUswKKb8056QuG")
      .collection("arquivos")
      .doc()
      .set({"arqname": "foto.png"});

  //Lendo dados

  //Obtendo todos os documentos
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection("Mensagens").get();
  snapshot.docs.forEach((d) {
    print(d.data());
  });

  //Obtendo um documento
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection("Mensagens")
      .doc("3P0p2tXUswKKb8056QuG")
      .get();

  print(documentSnapshot.data());

  //Obtendo todos os documentos com id
  QuerySnapshot snapshot2 =
      await FirebaseFirestore.instance.collection("Mensagens").get();
  snapshot2.docs.forEach((d) {
    print(d.data());
    print(d.id);
  });

  //Adicionando campo por referencia
  QuerySnapshot snapshot3 =
      await FirebaseFirestore.instance.collection("Mensagens").get();
  snapshot3.docs.forEach((d) {
    d.reference.update({"lido": false});
  });

  //Update/lendo em tempo real
  FirebaseFirestore.instance.collection("Mensagens").snapshots().listen((dado) {
    dado.docs.forEach((e) {
      print(e.data());
    });
  });

  //Update/lendo documento unico
  FirebaseFirestore.instance
      .collection("Mensagens")
      .doc("3P0p2tXUswKKb8056QuG")
      .snapshots()
      .listen((e) {
    print(e.data());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "ChatFlutter", home: Container());
  }
}
