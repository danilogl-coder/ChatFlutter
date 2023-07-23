import 'package:chatflutter/check_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Home Page',
            textAlign: TextAlign.center,
          ),
          TextButton(
              onPressed: () {
                sair();
              },
              child: Text("sair"))
        ],
      ),
    );
  }

  sair() async {
    await _firebaseAuth.signOut().then((user) => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CheckUser())));
  }
}
