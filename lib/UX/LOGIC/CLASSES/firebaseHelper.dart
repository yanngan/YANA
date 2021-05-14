import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:yana/UX/DB/places.dart';
import 'package:yana/UX/DB/users.dart';
import 'package:yana/UX/LOGIC/CLASSES/Message.dart';
import 'package:yana/UX/DB/events.dart';
/*Yisrael Bar 14/05/2021 */
class FirebaseHelper{

  //first use this method to access firebase collection - no need for real-time(messages)//update I put it on first line of main
  /*static void initFirebase() async {
    await Firebase.initializeApp();
  }*/
//start Places-------------------------------------------------
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

  static Future<List<Places>> getPlacesFromFb() async {
    List<Places> places = [];

    //read from collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Places').get();
    querySnapshot.docs.forEach((doc) {
      places.add(Places.fromJson(doc.data()));
    });
    return places;
  }

  static Future<Places?> getPlaceByID(String placeID) async{
    final refUsers =  FirebaseFirestore.instance.collection('Places').doc(placeID);
    var doc = await refUsers.get();
    if (doc.exists) {
      return Places.fromJson(doc.data());
    } else {
      return null;
    }
  }
//end Places-------------------------------------------------

//start Messages-------------------------------------------------
  static void sendMessageToFb(Message m1){
    //write a chat message
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference  myRef1= databaseReference.child("rooms/").child(m1.self_name).child(m1.other_name);
    myRef1.push().set(m1.toJson());
    myRef1= databaseReference.child("rooms/").child(m1.other_name).child(m1.self_name);
    myRef1.push().set(m1.toJson());
  }

  static Future<List<Message>> getMessagesFromFb(var selfName,var otherName)  async {
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference messageRef = databaseReference.child('rooms/').child(selfName).child(otherName);
    //read message once
    DataSnapshot data = await messageRef.once();
    List<Message> listMessage = [];
    Map<dynamic, dynamic> values = data.value;
    values.forEach((key, values) {
      listMessage.add(Message.fromJson(values));
    });
    return listMessage;

  }
//end Messages-------------------------------------------------

  //start Events-------------------------------------------------
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

  //in case the event does not exist the function return null
  static Future<Events?> getEventByID(String eventID) async{
    final refUsers =  FirebaseFirestore.instance.collection('Events').doc(eventID);
    var doc = await refUsers.get();
    if (doc.exists) {
      return Events.fromJson(doc.data());
    } else {
      return null;
    }
  }

  //in case we want to find an event by place
  // static Future<Events?> getEventsByPlaceID(String eventID, String placeID) async{
  //   final refUsers =  FirebaseFirestore.instance.collection('Events').doc(eventID);
  //   var doc = await refUsers.get();
  //   if (doc.exists) {
  //     return Events.fromJson(doc.data());
  //   } else {
  //     return null;
  //   }
  // }

  static Future<List<Events>> getEventsFromFb() async {
    //read from collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Events').get();
    querySnapshot.docs.forEach((doc) {
    });
    List<Events> events = [];
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });
    return events;

  }
//end Events-------------------------------------------------


// start users-------------------------------------------------
  static Future<bool> sendUserToFb(Users user) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to collection
    try {
      await fireStore.collection('Users').doc(user.userID).set(user.toJson());
    } on Exception catch (e) {
      return false;
    }
    return true;
  }

  static Future<List<Users>> getUsersFromFb() async {
    //read from collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
    List<Users> user = [];
    querySnapshot.docs.forEach((doc) {
      user.add(Users.fromJson(doc.data()));
    });
    return user;
  }

  static Future<Users?> getCurrentUser(String userID) async{
    final refUsers =  FirebaseFirestore.instance.collection('Users').doc(userID);
    var doc = await refUsers.get();
    if (doc.exists) {
      // print("Document data:");
      return Users.fromJson(doc.data());
    } else {
      // doc.data() will be undefined in this case
      // print("No such document!");
      return null;
    }
  }

  static Future<bool> checkIfUserExists(String userID) async{
    final refUsers =  FirebaseFirestore.instance.collection('Users').doc(userID);
    var doc = await refUsers.get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }
//end users-------------------------------------------------
}
