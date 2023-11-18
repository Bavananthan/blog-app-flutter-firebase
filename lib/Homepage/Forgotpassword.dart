

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _LoginUsersState();
}

class _LoginUsersState extends State<Forgotpassword> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  late String _email, _password;
  bool isAPIcallprocess = false;
  bool textvisible = true;
  bool showSpinner = false;
  FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("reset password"),
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
                      ' Nice Work!!',
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
                      ' I have a solution',
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



                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      ' Enter your email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blueGrey,
                      ),
                    ),
                    TextFormField(

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
                      height: 20,
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
                              setState(() {
                                showSpinner= true;
                              });
                              try{
                                _auth.sendPasswordResetEmail(email: _email.toString()).then((value) {
                                  setState(() {
                                    showSpinner= false;
                                  });
                                  mesg("check your email and Reset your password");
                                  setState(() {
                                    showSpinner= false;
                                  });
                                }).onError((error, stackTrace) {
                                  mesg(error.toString());
                                  setState(() {
                                    showSpinner= false;
                                  });

                                });
                                
                              }catch(e){
                                
                              }


                            } 
                          },
                          child: Text('Reset')),
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
