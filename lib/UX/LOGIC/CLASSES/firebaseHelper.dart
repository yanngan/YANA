import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:yana/UI/PAGES/AllPage.dart';
import 'package:yana/UX/DB/places.dart';
import 'package:yana/UX/DB/users.dart';
import 'package:yana/UX/LOGIC/CLASSES/Message.dart';
import 'package:yana/UX/DB/events.dart';
import 'package:yana/UX/LOGIC/CLASSES/Place.dart';
class FirebaseHelper{


  //first use this method to access firebase collection - no need for real time(messages)
  void initFirebase() async {
    await Firebase.initializeApp();
    Places place = new Places("placeID", "address2", "pho111neNumbe2", "representative", 10, "vibe", true, "openingHours", "name", 18, "webLink.com", "googleMapLink.com");
    await sendPlaceToFb(place);
    getPlaceFromFb();
  }

  dynamic sendPlaceToFb(Places place) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to collection
    fireStore.collection('Places').doc(place.placeID).set(place.toJson())
        .then((_){
      print("success!");
    });
  }

  List<Places> getPlaceFromFb(){
    List<Places> places = [];

    //read from collection
    FirebaseFirestore.instance
        .collection('Places')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("new place: ");
        // print(doc["placeID"]);
        // print(doc.data());
        // print(Places.fromJson(doc.data()));
          places.add(Places.fromJson(doc.data()));
      });
    });
    return places;
  }


  void sendMessageToFb(Message m1){
    //write a chat message
    // var m1 = new Message("yisrael", "lidor", "ssss", "ssss");
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference  myRef1= databaseReference.child("rooms/").child(m1.self_name).child(m1.other_name);
    myRef1.push().set(m1.toJson());
    myRef1= databaseReference.child("rooms/").child(m1.other_name).child(m1.self_name);
    myRef1.push().set(m1.toJson());
  }

  dynamic getMessageFromFb(var self_name,var otherName)  {
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference messageRef = databaseReference.child('rooms/').child(self_name).child(otherName);
    //read message once
     return messageRef.once().then((DataSnapshot data){
      Map<dynamic, dynamic> values = data.value;
      values.forEach((key, values) {
        Chat.messages.add(Message.fromJson(values));
      });
    });
  }


  dynamic sendEventToFb(Events event) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to collection
    fireStore.collection('Events').doc(event.eventID).set(event.toJson())
        .then((_){
      print("success!");
    });
  }

  void getEventFromFb(){
    //read from collection
    FirebaseFirestore.instance
        .collection('Events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["eventID"]);
        print(doc);
      });
    });
  }

  dynamic sendUserToFb(User user) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to collection
    fireStore.collection('Users').doc(user.userID).set(user.toJson())
        .then((_){
      print("success!");
    });
  }
  void getUserFromFb(){
    //read from collection
    FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["userID"]);
        print(doc);
      });
    });
  }

  FirebaseHelper();
}