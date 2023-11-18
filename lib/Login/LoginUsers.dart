

import 'package:blog_app/Homepage/Forgotpassword.dart';
import 'package:blog_app/Homepage/Homepage.dart';
import 'package:blog_app/Login/RegisterUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginUsers extends StatefulWidget {
  const LoginUsers({super.key});

  @override
  State<LoginUsers> createState() => _LoginUsersState();
}

class _LoginUsersState extends State<LoginUsers> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  late String _email, _password;
  bool isAPIcallprocess = false;
  bool textvisible = true;


//   //sign in
  void sign(BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
      ).then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Homepage()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        mesg('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        mesg('Wrong password provided for that user.');
      }
    }
  }
// final FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
// Future<Sting> Sign(String email ,String Password){
//
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BaVa BloG"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Container(
              //padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Form(
                key: loginFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Text(
                      ' Welcome to My world',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.blueGrey,
                      ),

                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      ' Post OWN Memories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blueGrey,
                      ),
                    ),
                    CircleAvatar(

                        backgroundColor: Colors.transparent,
                        radius: 110.0,
                        child: Image.asset("Images/logo.png",height: 200,)),

                    Text(
                      ' Have a nice day',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blueGrey,
                      ),
                    ),
                    TextFormField(
                      //controller: usernamecontrol,
                      validator: (_email) {
                        if (_email!.isEmpty && _email != null) {
                          return "Enter your name";
                        }
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      // controller: userpass,
                      validator: (_password) {
                        if (_password!.isEmpty && _password != null) {
                          return "Enter your password";
                        }
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      obscureText: textvisible, //change password type
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                textvisible = !textvisible;
                              });
                            },
                            icon: textvisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off)),
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      //study button and radius methode allso navigate
                      child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (loginFormKey.currentState!.validate()) {
                              loginFormKey.currentState?.save();

                              sign(context);

                            } else {}
                          },
                          child: Text('LogIn')),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                               Navigator.of(context).push(MaterialPageRoute(
                                   builder: (context) => Forgotpassword()));
                            },
                            child: Text("Forgot Password"))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("New user?"),
                        TextButton(
                            onPressed: () {
                               Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegisterUsers()));
                            },
                            child: Text("Register Now"))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
void mesg(String message) {
  Fluttertoast.showToast(msg: message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 15
  );
}
