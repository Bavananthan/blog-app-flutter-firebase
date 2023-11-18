import 'dart:io';
//import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:firebase_database/firebase_database.dart' ;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
//import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  bool showSpinner = false;
  final postRef = FirebaseDatabase.instance.ref().child('posts');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  File? _image;
  final picker = ImagePicker();
  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _Detailscontroller = TextEditingController();

  GlobalKey blogkey = GlobalKey<FormState>();

  Future getgallery() async {
    final imagefile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (imagefile != null) {
        _image = File(imagefile.path);
      } else {
        print("Image not select");
      }
    });
  }

  Future getcamera() async {
    final imagefile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (imagefile != null) {
        _image = File(imagefile.path);
      } else {
        print("Image not select");
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getgallery();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text("Gallery"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getcamera();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text("camera"),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Upload post"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      dialog(context);
                    },
                    child: Center(
                      child: Container(
                        height: 300,
                        width: 400,
                        child: _image != null
                            ? ClipRect(
                                child: Image.file(
                                  _image!.absolute,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: 100,
                                width: 100,
                                child: Icon(Icons.camera_alt),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                      child: Column(
                    children: [
                      TextFormField(
                        controller: _titlecontroller,
                        // validator: ,
                        decoration: InputDecoration(
                          labelText: "Title",
                          hintText: "Enter post title",
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _Detailscontroller,
                        minLines: 1,
                        maxLines: 10,

                        // validator: ,
                        decoration: InputDecoration(
                          labelText: "Desciption",
                          hintText: "About the post",
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try{
                              int date = DateTime.now().microsecondsSinceEpoch;
                              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('bavabhaii$date');
                              UploadTask uploadtask = ref.putFile(_image!.absolute, SettableMetadata(contentType: 'image/*'),);
                              await Future.value(uploadtask);
                              var imageurl = await ref.getDownloadURL();


                              final User? user = _auth.currentUser;
                              postRef.child('post list').child(date.toString()).set({

                                'pid': date.toString(),
                                'pImage': imageurl.toString(),
                                'pTime': date.toString(),
                                'pTitle': _titlecontroller.text.toString(),
                                'pDescription': _Detailscontroller.text.toString(),
                                'uEmail': user?.email.toString(),
                                'pid': user?.uid.toString(),

                              }).then((value){
                                mesg(' post uploaded ');
                                setState(() {
                                  showSpinner = false;
                                });
                              }).onError((error, stackTrace) {
                                mesg(error.toString());
                                setState(() {
                                  showSpinner = false;
                                });
                              });

                            }catch(e){
                              setState(() {
                                showSpinner = false;
                              });
                              mesg(e.toString());
                            }
                          },
                          child: Text("upload"))
                    ],
                  ))
                ],
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
