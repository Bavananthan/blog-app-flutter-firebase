import 'dart:async';

import 'package:blog_app/Homepage/Homepage.dart';
import 'package:blog_app/Login/LoginUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = _auth.currentUser;

    Timer(Duration(seconds: 10), () {
      print("Timer elapsed. Navigating...");
      if (user != null) {
        print("User is logged in. Navigating to Homepage.");
        Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
      } else {
        print("User is not logged in. Navigating to LoginUsers.");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginUsers()));
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(

            child: CircleAvatar(

               radius:100,
               backgroundImage:AssetImage('Images/scrren.png')),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text(
              "BaVa BLOG!!",
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
