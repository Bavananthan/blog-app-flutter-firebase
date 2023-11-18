import 'package:blog_app/Homepage/SpalashSceen.dart';
import 'package:blog_app/Login/LoginUsers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BLOG APP",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: SpalshScreen(),
    );
  }
}
