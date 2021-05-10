import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yana/UX/DB/events.dart';
import 'package:yana/UX/DB/places.dart';
import 'package:yana/UX/DB/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yana/UX/LOGIC/CLASSES/Message.dart';
import 'package:yana/UX/LOGIC/CLASSES/allClasses.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  void sendToFb() async{
    await Firebase.initializeApp();
    await sendPlace();
  }
  dynamic sendPlace() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var place1 = new Places("placeID", "address2", "pho111neNumbe2", "representative", 10, "vibe", true, "openingHours", "name", 18, "webLink.com", "googleMapLink.com");
    //write to collection
    firestore.collection('Places').doc(place1.placeID).set(place1.toJson())
        .then((_){
      print("success!");
    });


     //read from collection
    FirebaseFirestore.instance
        .collection('Places')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["placeID"]);
        print(doc);
      });
    });


  }



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

                    //realtime write
                    final databaseReference = FirebaseDatabase.instance.reference();
                    var user = new User("yisraeddddl", "yisrael id", "dateOfBirth", "bio","ftoto","signUpDate" ,false, true, "israel", "male");
                    var userId = databaseReference.child('users/').child(user.userID).set(user.toJson());

                    //messages
                    var m1 = new Message("yisrael", "lidor", "ssss", "ssss");
                    //send message to fb

                    //write a chat message
                      DatabaseReference  myRef1= databaseReference.child("rooms/").child(m1.self_name).child(m1.other_name);
                      myRef1.push().set(m1.toJson());
                      myRef1= databaseReference.child("rooms/").child(m1.other_name).child(m1.self_name);
                      myRef1.push().set(m1.toJson());


                      var self_name = "yisrael";
                      var otherName = "lidor";
                      DatabaseReference messageRef = databaseReference.child('rooms/').child(self_name).child(otherName);



                    List<Message> messages=[] ;
                    // messages.add(m1);
                      //read message once
                      messageRef.once().then((DataSnapshot data){
                      print("*****************");
                      // Message m2 = new Message.fromJson(data);
                      Map<dynamic, dynamic> values = data.value;
                      values.forEach((key, values) {
                        messages.add(Message.fromJson(values));
                        // print("new: ");
                        // print(Message.fromJson(values));
                      });
                      //   print(messages);
                    });

                          //need to check- on change
                    // databaseReferenceTest
                    //     .child('MedicalCenter')
                    //     .onValue.listen((event) {
                    //   var snapshot = event.snapshot
                    //
                    //   String value = snapshot.value['Relay1']['Data'];
                    //   print('Value is $value');
                    //
                    //   ...
                    //
                    // });


                      // messageRef.onChildChanged;

                    // onChild();
                    // =>
                    // myRef1.addChildEventListener(new ChildEventListener() {
                    // messageList.clear();
                    // for (DataSnapshot ds1:dataSnapshot.getChildren())    {
                    // Message m1 = ds1.getValue(Message.class);
                    // messageList.add(m1);
                    // adapter = new Adapter(getApplicationContext(),messageList);
                    // l1.setAdapter(adapter);

                    // final refUsers = FirebaseFirestore.instance.collection('users');
                    // await userDoc.set(newUser.toJson());
                    sendToFb();

                    //firestore
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





