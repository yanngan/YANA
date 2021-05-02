import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yana/UX/DB/events.dart';
import 'package:yana/UX/DB/places.dart';
import 'package:yana/UX/DB/user.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.amber,
    //   child: Center(child: Text("SearchView")),
    // );


    return Scaffold(
        body: Padding(
        padding: EdgeInsets.all(10.0),
          child: Column(

            children: [
              SizedBox(height: 20.0),
              Center(
                child: FlatButton.icon(
                  icon : Icon(Icons.login),
                  onPressed: () {
                    final databaseReference = FirebaseDatabase.instance.reference();
                    var user = new User("yisrael", "yisrael id", "dateOfBirth", "bio","fhoto","signUpDate" ,false, true, "israel", "male");
                    var userId = databaseReference.child('users/').push();
                    userId.set(user.toJson());
                    var place = new Places("placeID", "address", "phoneNumber", "representative", 10, "vibe", true, "openingHours", "name", 18, "webLink.com", "googleMapLink.com");
                    var placeId = databaseReference.child('Places/').push();
                    placeId.set(place.toJson());
                    var event = new Events("eventID", user, "creationDate", true, "startEstimate"," endEstimate", 3, 5, "placeID");
                    var eventId = databaseReference.child('Events/').push();
                    eventId.set(event.toJson());
                    },
                    label: Text("test firebase"),
                ),
              ),
            ],
          ),
        ),
    );

  }
}





