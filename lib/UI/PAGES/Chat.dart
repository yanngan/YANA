import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yana/UX/DB/allDB.dart';
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
                print("hello");

                // Chat.messages.clear();
                // await Firebase.initializeApp();
                // var m1 = new Message("yisrael", "lidor", "test", "today");
                // await  FirebaseHelper.sendEventToFb(new Events("eventID", new User("userName","userID","dateOfBirth", "bio", "fbPhoto","signUpDate",false,true,"nickName","sex"), "creationDate", false, "startEstimate", "endEstimate", 0,0, "placeID"));
                // FirebaseHelper.sendUserToFb(new User("userName", "meir", "dateOfBirth",
                //     "bio"," fbPhoto", "signUpDate", false, true, "nickName", "sex"));
                var u1 = await FirebaseHelper.getEventsFromFb();
                print(u1);
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




