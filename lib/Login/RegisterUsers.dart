import 'package:blog_app/Homepage/Homepage.dart';
import 'package:blog_app/Login/LoginUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterUsers extends StatefulWidget {
  const RegisterUsers({super.key});

  @override
  State<RegisterUsers> createState() => _LoginUsersState();
}

class _LoginUsersState extends State<RegisterUsers> {
  GlobalKey<FormState> RegisterFormKey = GlobalKey<FormState>();
  late String _email, _password;
  bool isAPIcallprocess = false;
  bool textvisible = true;

  //register
  Future<void> Register(BuildContext context)
  async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      ).then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Homepage()));
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        mesg('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        mesg('The account already exists for that email.');
      }
    } catch (e) {
      mesg(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Container(
              //padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Form(
                key: RegisterFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Text(
                      ' Create Your Account',
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
                      ' Follow Me!!!!',
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
                        prefixIcon: Icon(Icons.person),
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
                            if (RegisterFormKey.currentState!.validate()) {
                              RegisterFormKey.currentState?.save();
                              print(_email);
                              print(_password);
                              Register(context);
                            } else {}
                          },
                          child: Text('Sign in')),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Do You Have Account?"),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(MaterialPageRoute(
                                  builder: (context) => LoginUsers()));
                            },
                            child: Text("Log IN"))
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
