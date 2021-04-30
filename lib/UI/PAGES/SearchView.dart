import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yana/UX/DB/user.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(child: Text("SearchView")),
    );


    // return Scaffold(
    //     body: Padding(
    //     padding: EdgeInsets.all(10.0),
    //       child: Column(
    //
    //         children: [
    //           SizedBox(height: 20.0),
    //           Center(
    //             child: FlatButton.icon(
    //               icon : Icon(Icons.login),
    //               onPressed: () {
    //                 final databaseReference = FirebaseDatabase.instance.reference();
    //                 var user = new User("yisrael", "yisrael id", "dateOfBirth", "bio","fhoto","signUpDate" ,false, true, "israel", "male");
    //                 var id = databaseReference.child('users/').push();
    //                 id.set(user.toJson());
    //                 print(user);
    //                 print("im here");
    //                 },
    //                 label: Text("test firebase"),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    // );

  }
}





