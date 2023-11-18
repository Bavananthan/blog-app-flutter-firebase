import 'dart:ffi';

import 'package:blog_app/Homepage/UploadImage.dart';
import 'package:blog_app/Login/LoginUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final dbref = FirebaseDatabase.instance.ref().child('posts');
  TextEditingController _searchcontroler = TextEditingController();
  late String _search;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Home",textAlign: TextAlign.center,),
        actions: [

          IconButton(
            onPressed: () {
              _auth.signOut().then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginUsers()));
              });
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      drawer: Drawer(
        elevation: 16.0,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Bavananthan"),
              accountEmail: Text("bavananthan14@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: ExactAssetImage("Images/10.jpg"),
                radius: 110.0,
              ),
            ),
            ListTile(
              title: Text("Profile"),
              leading: Icon(Icons.person),
            ),
            Divider(
              height: 1.0,
            ),
            ListTile(
              title: Text("Order"),
              leading: Icon(
                Icons.local_shipping,
              ),
            ),
            Divider(
              height: 1.0,
            ),
            ListTile(
              title: Text("Favorite"),
              leading: Icon(
                Icons.favorite,
              ),
            ),
            Divider(
              height: 1.0,
            ),
            ListTile(
              title: Text("Offer and Promo"),
              leading: Icon(
                Icons.local_offer,
              ),
            ),
            Divider(
              height: 1.0,
            ),
            ListTile(
              title: Text("Privacy Policy"),
              leading: Icon(
                Icons.policy,
              ),
            ),
            Divider(
              height: 1.0,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
        child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _searchcontroler,
                onChanged:(String value) {
                  _search = value;
                },
                validator: (_search) {
                  if (_search!.isEmpty && _search != null) {
                    return "Enter your password";
                  }
                },

               //change password type
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),

                  labelText: 'search',
                  labelStyle: TextStyle(fontSize: 15),
                ),
              ),

              Expanded(
                child: FirebaseAnimatedList(
                    query: dbref.child('post list'),
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {


                        final data = snapshot.value as Map<dynamic, dynamic>;
                        String temptitle = data['pTitle'];

                        if(_searchcontroler.text.isEmpty)
                          {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius:BorderRadius.circular(15),
                                  child: FadeInImage.assetNetwork(
                                      height: 300,
                                      width: double.infinity,
                                      fit: BoxFit.cover,

                                      placeholder: 'Images/scrren.png',
                                      image: data['pImage']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(data['pTitle'],style: TextStyle(fontSize:20
                                      ,fontWeight: FontWeight.bold),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(data['pDescription']),
                                ),
                              ],
                            );
                          }else if(temptitle.toLowerCase().contains(_searchcontroler.text.toString()))
                            {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius:BorderRadius.circular(15),
                                    child: FadeInImage.assetNetwork(
                                        height: 300,
                                        width: double.infinity,
                                        fit: BoxFit.cover,

                                        placeholder: 'Images/scrren.png',
                                        image: data['pImage']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(data['pTitle'],style: TextStyle(fontSize:20
                                        ,fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(data['pDescription']),
                                  ),
                                ],
                              );

                            }else{
                          return Container();

                        }


                    }),
              )
            ]

            //
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UploadImage()));
        },
        child: const Icon(Icons.add_photo_alternate_outlined),
      ),
    );
  }
}
