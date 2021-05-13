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
  /*static void initFirebase() async {

    Places place = new Places("placeID", "address2", "pho111neNumbe2", "representative", 10, "vibe", true, "openingHours", "name", 18, "webLink.com", "googleMapLink.com");
    await sendPlaceToFb(place);
    getPlaceFromFb();
  }*/

  static Future<bool> sendPlaceToFb(Places place) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to collection
    try {
      await fireStore.collection('Places').doc(place.placeID).set(place.toJson());
    } on Exception catch (e) {
      return false;
    }
    return true;
  }

  static Future<List<Places>> getPlaceFromFb() async {
    List<Places> places = [];

    //read from collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Places').get();
    querySnapshot.docs.forEach((doc) {
      places.add(Places.fromJson(doc.data()));
    });
    return places;
  }


  static void sendMessageToFb(Message m1){
    //write a chat message
    // var m1 = new Message("yisrael", "lidor", "ssss", "ssss");
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference  myRef1= databaseReference.child("rooms/").child(m1.self_name).child(m1.other_name);
    myRef1.push().set(m1.toJson());
    myRef1= databaseReference.child("rooms/").child(m1.other_name).child(m1.self_name);
    myRef1.push().set(m1.toJson());
  }

  static Future<List<Message>> getMessageFromFb(var self_name,var otherName)  async {
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference messageRef = databaseReference.child('rooms/').child(self_name).child(otherName);
    //read message once
    DataSnapshot data = await messageRef.once();
    List<Message> listMessage = [];
    Map<dynamic, dynamic> values = data.value;
    values.forEach((key, values) {
      listMessage.add(Message.fromJson(values));
    });
    return listMessage;

  }


  static Future<bool> sendEventToFb(Events event) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to collection
    try {
      await fireStore.collection('Events').doc(event.eventID).set(event.toJson());
    } on Exception catch (e) {
      return false;
    }
    return true;
  }

  static Future<List<Events>> getEventFromFb() async {
    //read from collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Events').get();
    querySnapshot.docs.forEach((doc) {
      print(doc["eventID"]);
      print(doc);
    });
    List<Events> events = [];
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });
    return events;

  }

  static Future<bool> sendUserToFb(User user) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to collection
    try {
      await fireStore.collection('Users').doc(user.userID).set(user.toJson());
    } on Exception catch (e) {
      return false;
    }
    return true;

  }

  static Future<List<User>> getUserFromFb() async {
    //read from collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
    List<User> user = [];
    querySnapshot.docs.forEach((doc) {
      user.add(User.fromJson(doc.data()));
    });
    return user;
  }

}