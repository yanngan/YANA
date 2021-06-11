import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:yana/UI/PAGES/Utilities.dart';
import 'package:yana/UX/LOGIC/CLASSES/Message.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:intl/intl.dart';

/// Yisrael Bar, Lidor Eliyahu Shelef, Yann Moshe Ganem
class FirebaseHelper {
/// First use this method to access firebase collection - no need for real-time(messages)
// update I put it on first line of main
  /*static void initFirebase() async {
    await Firebase.initializeApp();
  }*/

/// start Places-------------------------------------------------

  /// Send to the firebase A new Place or update existing one
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
    } on Exception {
      return false;
    }
    return true;
  }

  /// Get a list of all place from the firebase
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

  /// Get from firebase a place by ID if it's not exist return null
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

/// End Places-------------------------------------------------

/// Start BulletinBoard-------------------------------------------------

  /// Send BulletinBoard obj to firebase
  static Future<bool> sendBulletinBoardToFb(BulletinBoard bulletinBoard) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    var id = FirebaseFirestore.instance.collection('BulletinBoard').doc().id;
    //write to collection
    try {
      await fireStore
          .collection('BulletinBoard')
          .doc(id)
          .set(bulletinBoard.toJson());
    } on Exception {
      return false;
    }
    return true;
  }

  /// Get all BulletinBoard from firebase
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

  /// Get BulletinBoard by ID from firebase
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

/// End BulletinBoard-------------------------------------------------

/// Start Messages-------------------------------------------------

  /// Send a new message to firebase realtime - store the message on both the sender and the receiver branch's
  static void sendMessageToFb(Message m1) {
    //write a chat message
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference myRef1 = databaseReference
        .child("rooms/")
        .child(m1.selfID)
        .child(m1.otherID);
    myRef1.push().set(m1.toJson());
    myRef1 = databaseReference
        .child("rooms/")
        .child(m1.otherID)
        .child(m1.selfID);
    myRef1.push().set(m1.toJson());
  }

  /// Just a test but not usable- implementation in chat page in the UI
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

  /// Receives a [Map] of all the senders -> key (users IDs) : value (users names)
  /// [_selfID] - Current user ID
  static Future<Map<dynamic, dynamic>> getSendersInfo(var _selfID) async {
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference sendersRef = databaseReference.child('chats_information/').child(_selfID);
    DataSnapshot data = await sendersRef.once();
    Map<dynamic, dynamic> values = data.value;
    return values;
  }

  /// Creates a new chat between current user and other user
  /// [_selfID] - Current user ID
  /// [_selfName] - Current user name
  /// [_otherID] - Other user ID
  /// [_otherName] - Other user name
  static void createNewChat(var _selfID, var _selfName, var _otherID, var _otherName){
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference  myRef = databaseReference.child("chats_information/");
    myRef.child(_selfID).child(_otherID).set(_otherName);
    myRef.child(_otherID).child(_selfID).set(_selfName);
  }

  /// Deletes all the chats related to the current user
  /// [_selfID] - Current user ID
  static void deleteAllUserChats(var _selfID){
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference  myRef = databaseReference.child("chats_information/");
    myRef.child(_selfID).remove();
  }

/// End Messages-------------------------------------------------

/// Start Events-------------------------------------------------

  /// Generate event id to put in event object
  static Future<String> generateEventId() async {
    return FirebaseFirestore.instance.collection('Events').doc().id;
  }

  /// Generate a new random ID for the attendance ( from FireBase )
  static Future<String> generateAttendanceId() async {
    return FirebaseFirestore.instance.collection('Attendance').doc().id;
  }

  /// Send events object to firebase
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
    } on Exception {
      return false;
    }
    return true;
  }

  /// In case the event does not exist the function return null
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

  /// In a given place id we get from firebase all the events in this place
  static Future<List<Events>> getEventsByPlaceID(String placeID) async {
    List<Events> events = [];
    DateTime now = new DateTime.now();
    String date = new DateFormat('yyyy-MM-dd').format(now);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Events')
        // .where("placeID", isEqualTo: placeID)//can't do both where is the same query
        .where("startEstimate", isGreaterThanOrEqualTo: date )
        .get();
    querySnapshot.docs.forEach((doc) {
      Events e1 =Events.fromJson(doc.data());
      if(e1.placeID ==  placeID)
        events.add( e1);
    });
    return events;
  }

  /// Deleting an event from the event collection and from Attendance collection
  static void deleteEventByID(String _eventID){
    FirebaseFirestore.instance.collection('Events').doc(_eventID).delete();
    FirebaseFirestore.instance.collection("Attendance")
        .where("idEvent", isEqualTo: _eventID).get().then((value){
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection("Attendance").doc(element.id).delete();
      });
    });

  }

  /// Get all events from firebase
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

  /// Get all events that active
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

  /// Get all events by a place name--you should use getEventsBySearchCombination
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

  /// Return all events that max capacity is less then num--you should use getEventsBySearchCombination
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

  /// Get all events that in the range on a specific date, returns: List<events>
  static Future<List<Events>> getEventsByASpecificDate(String startDate,String endDate ) async {
    List<Events> events = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Events')
        .where("startEstimate", isGreaterThanOrEqualTo: startDate)
        .where("startEstimate", isLessThanOrEqualTo: endDate+" 23:59")
        .get();
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });
    return events;
  }

  /// Get all events that from this date and more, returns: List<events>
  static Future<List<Events>> getEventsByDateAndMore(String startDate) async {
    List<Events> events = [];
    if(startDate.isEmpty){
      DateTime now = new DateTime.now();
      startDate = new DateFormat('yyyy-MM-dd').format(now);
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Events')
        .where("startEstimate", isGreaterThanOrEqualTo: startDate)
        .get();
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });
    return events;
  }

  /// Get events by the 3 parameters : name, max capacity, date.
  ///  name- events that contain the place name like: Shoshana Bar
  ///  capacity- events that have less max nom of people then capacity
  ///  date- events that in the range on a specific date
  static Future<List<Events>> getEventsBySearchCombination(
      {String name = "", int capacity = -1, String date = "",String startHour=""}) async {

    List<Events> events = [];
    if(date.isEmpty){
      DateTime now = new DateTime.now();
      date = new DateFormat('yyyy-MM-dd').format(now);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Events')
          .where("startEstimate", isGreaterThanOrEqualTo: date)
          .get();
      querySnapshot.docs.forEach((doc) {
        events.add(Events.fromJson(doc.data()));
      });
    }else{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Events')
          .where("startEstimate", isGreaterThanOrEqualTo: date + " "+startHour )
          .where("startEstimate", isLessThanOrEqualTo: date+" 23:59")
          .get();
      querySnapshot.docs.forEach((doc) {
        events.add(Events.fromJson(doc.data()));
      });
    }


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

  /// Retrieve all the user events
  /// [userID] - Current user ID
  static Future<List<Events>> getUserEvents(String userID) async{
    QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection('Events').where('userID',isEqualTo: userID).get();
    List<Events> events = [];
    querySnapshot.docs.forEach((doc) {
      events.add(Events.fromJson(doc.data()));
    });
    querySnapshot =  await FirebaseFirestore.instance.collection('Attendance').where('idUser',isEqualTo: userID).get();
    for(var alias in querySnapshot.docs){
      dynamic json = alias.data();
      QuerySnapshot tempQuerySnapshot =  await FirebaseFirestore.instance.collection('Events').where('eventID',isEqualTo: json['idEvent']).get();
      tempQuerySnapshot.docs.forEach((doc) {
        var tempEvent = Events.fromJson(doc.data());
        events.add(tempEvent);
      });
    }
    return events;
  }

  /// Sends a request from current user to the event creator user in order to join this event
  /// [userID] - Current user ID
  /// [eventID] - Current event ID
  /// [creatorUserID] - Event creator user ID
  static Future<bool> userAskToJoinEvent(String userID, String eventID, String creatorUserID) async {
    //eventID
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to collection
    try {
      await fireStore.collection('Attendance').doc(await generateAttendanceId()).set({'idEvent':eventID,'idUser':userID,'status':0,'idCreator':creatorUserID});
    } on Exception {
      return false;
    }
    return true;
  }

  /// If approve == true -> approve , else -> reject
  static Future<bool> approveOrRejectRequestToJoinEvent(String userID,Events theEvents,bool approve) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    try {
      QuerySnapshot<Map<String, dynamic>> res = await  FirebaseFirestore.instance.collection("Attendance").where("idEvent", isEqualTo : theEvents.eventID).get();
      int status = approve?1:2;
      for(var alias in res.docs) {
        if(alias.data()['idUser'] == userID){
          await FirebaseFirestore.instance.collection("Attendance").doc(alias.id).update({'status':status});
          break;
        }
      }
      if(approve){
        await FirebaseFirestore.instance.collection('Events').doc(theEvents.eventID).update({'curNumPeople':(theEvents.curNumPeople+1)});
      }
      return true;
    } on Exception {
      return false;
    }
  }

  /// If user been approve to join an event and regrets, use this function to cancel
  static Future<bool> userCancelation(String userID, Events event,) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    try {
      QuerySnapshot<Map<String, dynamic>> res = await  FirebaseFirestore.instance.collection("Attendance").where("idEvent", isEqualTo : event.eventID).get();

      for(var alias in res.docs) {
        if(alias.data()['idUser'] == userID){
          await FirebaseFirestore.instance.collection("Attendance").doc(alias.id).delete();
          break;
        }
      }
      await FirebaseFirestore.instance.collection('Events').doc(event.eventID).update({'curNumPeople':(event.curNumPeople-1)});
      return true;
    } on Exception {
      return false;
    }
  }

  /// Retrieves the user status on given event ( pending, approved, denied )
  /// [eventID] - Current event ID
  static Future<int> getStatusEventForUser(String eventID) async {
    QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection('Attendance').where('idEvent',isEqualTo: eventID).get();
    for(var alias in querySnapshot.docs){
      dynamic json = alias.data();
      if(json['idUser'] == userMap['userID']! ){
        return json['status'];
      }
    }
    return -1;
  }

  /// Retrieves all the join requests sent to my events
  /// [idCreator] - Event creator ID
  static Future<List<MyNotification>> getUserJoinRequest(String idCreator) async {
    QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection('Attendance').where('idCreator',isEqualTo: idCreator).get();
    List<MyNotification> myNotifications = [];
    for(var alias in querySnapshot.docs){
      dynamic json = alias.data();
      myNotifications.add(new MyNotification(json['idEvent'],json['idUser'],json['idCreator'],json['status'],MyNotification.EVENTS_ASK_TO_JOIN));
    }
    return myNotifications;
  }

  /// Retrieves all the requests the current user sent that has been approved
  /// [idUser] - Current user ID
  static Future<List<MyNotification>> getUserApprovedRequest(String idUser) async {
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

  /// Get all Attendance Id-User for an Event
  /// [idEvent] - Current event ID
  static Future<List<String>> getAllAttendanceIdUserForANEvent(String idEvent) async {
    QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection('Attendance').where('idEvent',isEqualTo: idEvent).get();
    List<String> idUser = [];
    for(var alias in querySnapshot.docs){
      dynamic json = alias.data();
      idUser.add(json['idUser']);
    }
    return idUser;
  }

  static void deleteAllUserEvents(var _userID) async {
    await FirebaseFirestore.instance
      .collection('Events')
      .where("userID", isEqualTo: _userID)
      .get().then((value){
        value.docs.forEach((element) {
          FirebaseFirestore.instance.collection("Events").doc(element.id).delete();
        });
      });
  }

/// End Events-------------------------------------------------

/// Start Users-------------------------------------------------

  /// Send to firebase new user or update existing one
  static Future<bool> sendUserToFb(User user) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    //write to collection
    try {
      await fireStore.collection('Users').doc(user.userID).set(user.toJson());
    } on Exception {
      return false;
    }
    return true;
  }

  /// Get all users from firebase
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

  /// In a given id return the user from firebase
  static Future<User?> getCurrentUser(String userID) async {
    final refUsers = FirebaseFirestore.instance.collection('Users').doc(userID);
    var doc = await refUsers.get();
    if (doc.exists) {
      return User.fromJson(doc.data());
    } else {
      return null;
    }
  }

  /// Check if a certain user id already exist
  static Future<bool> checkIfUserExists(String userID) async {
    final refUsers = FirebaseFirestore.instance.collection('Users').doc(userID);
    var doc = await refUsers.get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  /// Delete the user entire account
  static void deleteUserAccount(var _userID) {
    FirebaseFirestore.instance.collection('Users').doc(_userID).delete();
  }

  /// Save the Firebase Cloud Messaging user token into Users
  static void saveUserRegistrationToken(String userID,String registrationToken) async {
    await FirebaseFirestore.instance.collection('Users').doc(userID).update({'notificationToken':registrationToken});
  }

  /// Retrieves the user machine token ( for the notifications )
  static Future<String> getTokenNotificationForAUser(String userID) async {
    final refUsers = FirebaseFirestore.instance.collection('Users').doc(userID);
    var doc = await refUsers.get();
    if (doc.exists) {
      return (doc.data()??{})['notificationToken']??"";
    } else {
      return "";
    }
  }

/// End Users-------------------------------------------------

}











