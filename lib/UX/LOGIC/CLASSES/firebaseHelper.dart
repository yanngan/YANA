import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:yana/UX/LOGIC/CLASSES/Message.dart';
import 'package:yana/UX/DB/allDB.dart';

/*Yisrael Bar 14/05/2021 */
class FirebaseHelper{

//first use this method to access firebase collection - no need for real-time(messages)//update I put it on first line of main
  /*static void initFirebase() async {
    await Firebase.initializeApp();
  }*/

//start Places-------------------------------------------------
  static Future<bool> sendPlaceToFb(Place place) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to collection
    try {
      await fireStore.collection('Places').doc(place.placeID).set(place.toJson());
    } on Exception catch (e) {
      return false;
    }
    return true;
  }

  static Future<List<Place>> getPlacesFromFb() async {
    List<Place> places = [];

    //read from collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Places').get();
    querySnapshot.docs.forEach((doc) {
      places.add(Place.fromJson(doc.data()));
    });
    return places;
  }

  static Future<Place?> getPlaceByID(String placeID) async{
    final refUsers =  FirebaseFirestore.instance.collection('Places').doc(placeID);
    var doc = await refUsers.get();
    if (doc.exists) {
      return Place.fromJson(doc.data());
    } else {
      return null;
    }
  }
//end Places-------------------------------------------------

//start BulletinBoard-------------------------------------------------
  static Future<bool> sendBulletinBoardToFb(BulletinBoard bulletinBoard) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    var id = FirebaseFirestore.instance.collection('BulletinBoard').doc().id;
    //write to collection
    try {
      await fireStore.collection('BulletinBoard').doc(id).set(bulletinBoard.toJson());
    } on Exception catch (e) {
      return false;
    }
    return true;
  }

  static Future<List<BulletinBoard>> getBulletinBoardFromFb() async {
    List<BulletinBoard> bulletinBoards = [];

    //read from collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('BulletinBoard').get();
    querySnapshot.docs.forEach((doc) {
      bulletinBoards.add(BulletinBoard.fromJson(doc.data()));
    });
    return bulletinBoards;
  }

  static Future<BulletinBoard?> getBulletinBoardByID(String id) async{
    final refUsers =  FirebaseFirestore.instance.collection('BulletinBoard').doc(id);
    var doc = await refUsers.get();
    if (doc.exists) {
      return BulletinBoard.fromJson(doc.data());
    } else {
      return null;
    }
  }
//end BulletinBoard-------------------------------------------------


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
  static String generateEventId(){
       return FirebaseFirestore.instance.collection('Events').doc().id;
  }

  static Future<bool> sendEventToFb(Events event) async {
    //add to real-time firebase on place id the new event
    FirebaseDatabase.instance.reference().child("places/").child(event.placeID).push().set(event.eventID);

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
/*
  //in case we want to find an event by place -- need to fix
  static Future<List<Events>?> getEventsByPlaceID( String placeID) async{
    DatabaseReference placeRef = FirebaseDatabase.instance.reference().child("places/").child(placeID);
    DataSnapshot data = await placeRef.once();
    Map<dynamic, dynamic> values = data.value;
    List<Events> events = [];
    //need to fix with await
     values.forEach((key, values) async {
      var doc = await FirebaseFirestore.instance.collection('Events').doc(values).get();
      // print(doc.data());
      if (doc.exists) {
        events.add(Events.fromJson(doc.data()));
        print("im here 0");
      }
    });
    print("im here 1 ${events}");
    return events;
  }
*/
  //in case we want to find an event by place -- need to fix
  static Future<List<Events>> getEventsByPlaceID( String placeID) async{
    DatabaseReference placeRef = FirebaseDatabase.instance.reference().child("places/").child(placeID);
    DataSnapshot data = await placeRef.once();
    Map<dynamic, dynamic> values = data.value??{};
    
    List<Events> events0 = await getEventsFromFb();
    List<Events> events1 = [];

    events0.forEach((event) {
        values.forEach((key, value) {
          if(event.eventID == value )
            events1.add(event);
        });
    });
    return events1;
  }

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

  static Future<List<User>> getUsersFromFb() async {
    //read from collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
    List<User> user = [];
    querySnapshot.docs.forEach((doc) {
      user.add(User.fromJson(doc.data()));
    });
    return user;
  }

  static Future<User?> getCurrentUser(String userID) async{
    final refUsers =  FirebaseFirestore.instance.collection('Users').doc(userID);
    var doc = await refUsers.get();
    if (doc.exists) {
      return User.fromJson(doc.data());
    } else {
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
