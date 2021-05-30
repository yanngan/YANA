import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:yana/UI/PAGES/AllPage.dart';
import 'package:yana/UX/LOGIC/CLASSES/Message.dart';
import 'package:yana/UX/DB/allDB.dart';

/*Yisrael Bar 14/05/2021 */
class FirebaseHelper {
//first use this method to access firebase collection - no need for real-time(messages)
// update I put it on first line of main
  /*static void initFirebase() async {
    await Firebase.initializeApp();
  }*/

//start Places-------------------------------------------------
  //send to the firebase A new Place or update existing one
  static Future<bool> sendPlaceToFb(Place place) async {
    //add to real-time firebase on place name the place id
    FirebaseDatabase.instance
        .reference()
        .child("places/")
        .child(place.name)
        .set(place.placeID);

    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to fireStore the new place
    try {
      await fireStore
          .collection('Places')
          .doc(place.placeID)
          .set(place.toJson());
    } on Exception catch (e) {
      return false;
    }
    return true;
  }

  //get a list of all place from the firebase
  static Future<List<Place>> getPlacesFromFb() async {
    List<Place> places = [];
    //read from collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Places').get();
    querySnapshot.docs.forEach((doc) {
      places.add(Place.fromJson(doc.data()));
    });
    return places;
  }

  //get from firebase a place by ID if it's not exist return null
  static Future<Place?> getPlaceByID(String placeID) async {
    final refUsers =
        FirebaseFirestore.instance.collection('Places').doc(placeID);
    var doc = await refUsers.get();
    if (doc.exists) {
      return Place.fromJson(doc.data());
    } else {
      return null;
    }
  }
//end Places-------------------------------------------------

//start BulletinBoard-------------------------------------------------
  //send BulletinBoard obj to firebase
  static Future<bool> sendBulletinBoardToFb(BulletinBoard bulletinBoard) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    var id = FirebaseFirestore.instance.collection('BulletinBoard').doc().id;
    //write to collection
    try {
      await fireStore
          .collection('BulletinBoard')
          .doc(id)
          .set(bulletinBoard.toJson());
    } on Exception catch (e) {
      return false;
    }
    return true;
  }

  //get all BulletinBoard from firebase
  static Future<List<BulletinBoard>> getBulletinBoardFromFb() async {
    List<BulletinBoard> bulletinBoards = [];

    //read from collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('BulletinBoard').get();
    querySnapshot.docs.forEach((doc) {
      bulletinBoards.add(BulletinBoard.fromJson(doc.data()));
    });
    return bulletinBoards;
  }

  //get BulletinBoard by ID from firebase
  static Future<BulletinBoard?> getBulletinBoardByID(String id) async {
    final refUsers =
        FirebaseFirestore.instance.collection('BulletinBoard').doc(id);
    var doc = await refUsers.get();
    if (doc.exists) {
      return BulletinBoard.fromJson(doc.data());
    } else {
      return null;
    }
  }
//end BulletinBoard-------------------------------------------------

//start Messages-------------------------------------------------
  //send a new message to firebase realtime - store the message on both the sender and the receiver branch's
  static void sendMessageToFb(Message m1) {
    //write a chat message
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference myRef1 = databaseReference
        .child("rooms/")
        .child(m1.self_name)
        .child(m1.other_name);
    myRef1.push().set(m1.toJson());
    myRef1 = databaseReference
        .child("rooms/")
        .child(m1.other_name)
        .child(m1.self_name);
    myRef1.push().set(m1.toJson());
  }

//just a test but not usable- implementation in chat page in the UI
  static Future<List<Message>> getMessagesFromFb(
      var selfName, var otherName) async {
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference messageRef =
        databaseReference.child('rooms/').child(selfName).child(otherName);
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
  //generate event id to put in event object
  static Future<String> generateEventId() async {
    return await FirebaseFirestore.instance.collection('Events').doc().id;
  }
  static Future<String> generateAttendanceId() async {
    return await FirebaseFirestore.instance.collection('Attendance').doc().id;
  }

  //send events object to firebase
  static Future<bool> sendEventToFb(Events event) async {
    //add to real-time firebase on place id the new event
    // FirebaseDatabase.instance
    //     .reference()
    //     .child("places/")
    //     .child(event.placeID)
    //     .push()
    //     .set(event.eventID);

    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to collection
    try {
      await fireStore
          .collection('Events')
          .doc(event.eventID)
          .set(event.toJson());
    } on Exception catch (e) {
      return false;
    }
    return true;
  }

  //in case the event does not exist the function return null
  static Future<Events?> getEventByID(String eventID) async {
    final refUsers =
        FirebaseFirestore.instance.collection('Events').doc(eventID);
    var doc = await refUsers.get();
    if (doc.exists) {
      return Events.fromJson(doc.data());
    } else {
      return null;
    }
  }

  //in a given place id we get from firebase all the events in this place
  static Future<List<Events>> getEventsByPlaceID(String placeID) async {
    List<Events> events = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Events')
        .where("placeID", isEqualTo: placeID)
        .get();
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });
    return events;
  }

/*
  //in case we want to find an event by place -- need to fix
  static Future<List<Events>> getEventsByPlaceID(String placeID) async {
    DatabaseReference placeRef =
        FirebaseDatabase.instance.reference().child("places/").child(placeID);
    DataSnapshot data = await placeRef.once();
    Map<dynamic, dynamic> values = data.value ?? {};

    List<Events> events0 = await getEventsFromFb();
    List<Events> events1 = [];

    events0.forEach((event) {
      values.forEach((key, value) {
        if (event.eventID == value) events1.add(event);
      });
    });
    return events1;
  }
*/
  //get all events from firebase
  static Future<List<Events>> getEventsFromFb() async {
    //read from collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Events').get();
    querySnapshot.docs.forEach((doc) {});
    List<Events> events = [];
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });
    return events;
  }



  //get all events that active
  static Future<List<Events>> getEventsByStatus(bool isActive) async {
    List<Events> events = [];
    //need to fix with await
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Events')
        .where("status", isEqualTo: isActive)
        .get();
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });
    return events;
  }

//get all events by a place name
  static Future<List<Events>> getEventsByName(String name) async {
    List<Events> events = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Events')
        .where("placeName", isGreaterThanOrEqualTo: name)
        .get();
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });
    return events;
  }

  //return all events that max capacity is less then num
  static Future<List<Events>> getEventsByMaxCapacity(int num) async {
    List<Events> events = [];
    //need to fix with await
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Events')
        .where("maxNumPeople", isLessThanOrEqualTo: num)
        .get();
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });
    return events;
  }

  //get all events that from a given date and more.. date <= List<events>
  //date= 2021-03-03 then the function will returns 2021-03-03, 2021-04-04...
  static Future<List<Events>> getEventsByDate(String date) async {
    List<Events> events = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Events')
        .where("startEstimate", isGreaterThanOrEqualTo: date)
        .get();
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });
    return events;
  }

  /*
  static Future<List<Events>> getEventsByLocation(double lat, double lon, double distance) async{
    List<Events> events = [];
    // double lat = 0.0144927536231884;
    // double lon = 0.0181818181818182;
    GeoPoint userGeoPoint = user.geoPoint["geopoint"];
    double lowerLat = userGeoPoint.latitude - (lat * distance);
    double lowerLon = userGeoPoint.longitude - (lon * distance);

    double greaterLat = userGeoPint.latitude + (lat * distance);
    double greaterLon = userGeoPint.longitude + (lon * distance);

    GeoPoint lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    GeoPoint greaterGeopoint = GeoPoint(greaterLat, greaterLon);
    Query query = Firestore.instance
        .collection(path)
        .where("geoPoint.geopoint", isGreaterThan: lesserGeopoint)
        .where("geoPoint.geopoint", isLessThan: greaterGeopoint)
        .limit(limit);
    return events;
  }
*/

  //get events by the 3 parameters : name, max capacity, date.
  static Future<List<Events>> getEventsBySearchCombination(
      {String name = "", int capacity = -1, String date = ""}) async {
    List<Events> events = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Events')
        .where("startEstimate", isGreaterThanOrEqualTo: date)
        .get();
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });

    if (capacity != -1) {
      events =
          events.where((element) => element.maxNumPeople <= capacity).toList();
    }
    if (name.isNotEmpty) {
      events = events
          .where((element) =>
              element.placeName.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    return events;
  }




  static Future<List<Events>> getUserEvents(String userID) async{
    QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection('Events').where('userID',isEqualTo: userID).get();
    List<Events> events = [];
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });
    querySnapshot =  await FirebaseFirestore.instance.collection('Attendance').where('idUser',isEqualTo: userID).get();
    for(var alias in querySnapshot.docs){
      dynamic json = alias.data();
      print("########## idEvent = " + json['idEvent']);
      QuerySnapshot tempQuerySnapshot =  await FirebaseFirestore.instance.collection('Events').where('eventID',isEqualTo: json['idEvent']).get();
      print("tempQuerySnapshot.docs.length = ${tempQuerySnapshot.docs.length}");
      tempQuerySnapshot.docs.forEach((doc) {
        var tempEvent = Events.fromJson(doc.data());
        print("----------------in tempEvent------------------");
        print(tempEvent);
        events.add(tempEvent);
      });
    }
    //print(events);
    return events;
  }



  static Future<bool> userAskToJoinEvent(String userID,String eventID,String creatorUserID) async{
    //eventID
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to collection
    try {
      await fireStore.collection('Attendance').doc(await generateAttendanceId()).set({'idEvent':eventID,'idUser':userID,'status':0,'idCreator:':creatorUserID});
    } on Exception catch (e) {
      return false;
    }
    return true;
  }

  static Future<int> getStatusEventForUser(String eventID)async{
    QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection('Attendance').where('idEvent',isEqualTo: eventID).get();
    for(var alias in querySnapshot.docs){
      dynamic json = alias.data();
      print("########## idEvent = " + json['idEvent']);
      if(json['idUser'] == userMap['id']! ){
        return json['status'];
      }
    }
    return 0;
  }

  static Future<List<MyNotification>> getUserJoinRequest(String idCreator)async{
    QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection('Attendance').where('idCreator',isEqualTo: idCreator).get();
    List<MyNotification> myNotifications = [];
    for(var alias in querySnapshot.docs){
      dynamic json = alias.data();
      myNotifications.add(new MyNotification(json['idEvent'],json['idUser'],json['idCreator'],json['status'],MyNotification.EVENTS_ASK_TO_JOIN));
    }
    return myNotifications;
  }

  static Future<List<MyNotification>> getUserApprovedRequest(String idUser)async{
    QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection('Attendance').where('idUser',isEqualTo: idUser).get();
    List<MyNotification> myNotifications = [];
    for(var alias in querySnapshot.docs){
      dynamic json = alias.data();
      if(json['status'] == 1){
        myNotifications.add(new MyNotification(json['idEvent'],json['idUser'],json['idCreator'],json['status'],MyNotification.EVENTS_ASK_TO_JOIN_BEEN_APPROVE));
      }
    }
    return myNotifications;
  }

//end Events-------------------------------------------------

// start users-------------------------------------------------
  //send to firebase new user or update existing one
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

  //get all users from firebase
  static Future<List<User>> getUsersFromFb() async {
    //read from collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Users').get();
    List<User> user = [];
    querySnapshot.docs.forEach((doc) {
      user.add(User.fromJson(doc.data()));
    });
    return user;
  }

  //in a given id return the user from firebase
  static Future<User?> getCurrentUser(String userID) async {
    final refUsers = FirebaseFirestore.instance.collection('Users').doc(userID);
    var doc = await refUsers.get();
    if (doc.exists) {
      return User.fromJson(doc.data());
    } else {
      return null;
    }
  }

  //check if a certain user id already exist
  static Future<bool> checkIfUserExists(String userID) async {
    final refUsers = FirebaseFirestore.instance.collection('Users').doc(userID);
    var doc = await refUsers.get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

//end users-------------------------------------------------

}
