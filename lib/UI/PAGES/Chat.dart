import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yana/UX/DB/places.dart';
import 'package:yana/UX/DB/users.dart';
import 'package:yana/UX/LOGIC/CLASSES/Message.dart';
import 'package:yana/UX/LOGIC/CLASSES/firebaseHelper.dart';

class Chat extends StatefulWidget {
  // User user;
  // const Chat(
  //   this.user,
  //    Key? key,
  // ) : super(key: key);
  static List<Message> messages = [];

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) => Scaffold(
    extendBodyBehindAppBar: true,
    backgroundColor: Colors.amberAccent,
    body: SafeArea(
      child: Column(
        children: [
          Center(
            child: FlatButton.icon(
              icon : Icon(Icons.login),
              onPressed: () async{


                Chat.messages.clear();
                var m1 = new Message("yisrael", "lidor", "test", "today");
                FirebaseHelper fbh = new FirebaseHelper();
                fbh.initFirebase();
                List<Places> places = fbh.getPlaceFromFb();
                print(places.length);
                print(places);

                // fbh.sendMessageToFb(m1);
               // await fbh.getMessageFromFb("yisrael", "lidor");
                // print(Chat.messages);
                // print(Chat.messages.length);

                // on change
                // final databaseReference = FirebaseDatabase.instance.reference();
                // DatabaseReference messageRef = databaseReference.child('rooms/').child("yisrael").child("lidor");
                // messageRef.onValue.listen((event) {
                //   var snapshot = event.snapshot;
                //   Map<dynamic, dynamic> values = snapshot.value;
                //   values.forEach((key, values) {
                //     // Chat.messages.add(Message.fromJson(values));
                //     print("new value: " );
                //     print(Message.fromJson(values));
                //     });
                //   });
              },
              label: Text("test firebase"),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     color: Colors.amber,
  //     child: Center(child: Text("Chat")),
  //   );
  // }
}




