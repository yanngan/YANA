//FLUTTER
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yana/UI/PAGES/Utilities.dart';
import '../DB/allDB.dart';
import 'CLASSES/allClasses.dart';
import 'EXCEPTIONS/CanNotGetUserLocationException.dart';
import 'package:http/http.dart' as http;

/// Developers: Lidor Eliyahu Shelef, Yann Ganem, Yisrael Bar-Or and Jonas Sperling

/// TODO: check internet connection in every method that needs an internet connection
class Logic {

  /// Method in order to get the current user geo location
  /// @return type - [CameraPosition] containing latitude and longitude of the user geo location
  static Future<CameraPosition> getUserLocation() async {
    ///getUserLocation
    ///try to get hes current location, if fail ->
    /// then try to get last know location
    ///   if fail (position == null) ->
    ///     throw CanNotGetUserLocationException
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 3));
    } catch (e) {
      position = await Geolocator.getLastKnownPosition();
    }
    if (position == null) {
      throw CanNotGetUserLocationException();
    }
    print(position);
    CameraPosition toReturn = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18.4746,
    );
    return toReturn;
  }

  /// [theNewEvents] - Represent a new event from Creation / Editing mode
  /// [thisIsANewEvent] - Flag to represent the type of the new event:
  ///    - True -> Creation of a new event
  ///    - False -> Editing of existing event
  /// returns the event itself
  static Future<Events?> createEditNewEvents(Events theNewEvents, bool thisIsANewEvent) async {
    if(!thisIsANewEvent){
      FirebaseHelper.getAllAttendanceIdUserForANEvent(theNewEvents.eventID).then((idUsers)async{
        String title = "מארגן האירוע שינה את פרטי האירוע";
        String body = "מארגן האירוע שינה את פרטי האירוע שאליו נרשמת";
        List<String> tokens = [];
        for(var idUser in idUsers){
          String theToken = await Logic.getTokenNotificationForAUser(idUser);
          if(theToken!=""){
            tokens.add(theToken);
          }
        }
        Logic.sendPushNotificationsToUsers(tokens,title,body);
      });
    }
    if (await FirebaseHelper.sendEventToFb(theNewEvents)) {
      return theNewEvents;
    } else {
      return null;
    }
  }

  /// [placeID] - Represent the desired place ID
  /// return all the events that occur in the desired place
  static Future<List<Events>> getEventsByPlace(String placeID) async {
    return await FirebaseHelper.getEventsByPlaceID(placeID);
  }

  /// Return all the places that are registered in our Firebase database
  static Future<List<Place>> getAllPlaces() async {
    return FirebaseHelper.getPlacesFromFb();
  }

  /// [placeID] - Represent the wanted place ID
  /// @return [tempP] - the place itself
  static Future<Place> getPlaceById(String placeID) async {
    var tempP = await FirebaseHelper.getPlaceByID(placeID);
    return tempP!;
  }

  /// Returns all the events that the user create / applied for
  static Future<List<Events>> getAllUserEvent() async {
    return await FirebaseHelper.getUserEvents(userMap['userID']!);
  }

  /// [maxNumPeople] - Represents the maximum amount of people allowed in the event ( if == -1 gets default to 1000 )
  /// [estimateDate] - Event date
  /// [startEstimateTime] - Event starting time of the day
  /// [placesName] - Desired place name
  /// Returns a [List] of [Events] that meet the conditions
  static Future<List<Events>> getEventsByCondition({int maxNumPeople = -1, String estimateDate = '', String startEstimateTime = "", String placesName = ""}) async {
//    print("maxNumPeople = $maxNumPeople");
//    print("estimateDate = $estimateDate");
//    print("startEstimateTime = $startEstimateTime");
//    print("placesName = $placesName");
    if(maxNumPeople == -1){
      maxNumPeople = 1000;
    }
    return await FirebaseHelper.getEventsBySearchCombination(name: placesName, capacity: maxNumPeople, date: estimateDate );
  }

  /// [userID] - Represent the current user ID
  /// [eventID] - Represent the desired event ID
  /// [creatorUserID] - Represent the event creator ID
  /// @return type - boolean that represent success / failure
  static Future<bool> userAskToJoinEvent(String userID, String eventID, String creatorUserID) async {
    Logic.getTokenNotificationForAUser(creatorUserID).then((token){
      String title = "יש לך בקשת הצטרפות";
      String body = "ישנה בקשת הצטרפות אשר ממתינה לך עבור אירוע שאותו יצרת";
      Logic.sendPushNotificationsToUsers([token], title, body);
    });
    if(await FirebaseHelper.userAskToJoinEvent(userID,eventID,creatorUserID)){
      return true;
    }
    return false;
  }

  /// [userID] - Represent the ID of the user that is requesting to join current user event
  /// [theEvent] - Represent the current event
  /// [approve] - boolean flag to indicate whether the user is approved to the event or denied
  /// @return type - boolean that represent success / failure
  static Future<bool> approveOrRejectRequestToJoinEvent(User otheUser, Events theEvent, bool approve) async {
    if(approve){
      Logic.getTokenNotificationForAUser(otheUser.userID).then((token){
        String title = "בקשתך להצטרף לאירוע אושרה!";
        String body = "בקשתך להצטרך לאירוע אושרה על-ידי מארגן האירוע";
        Logic.sendPushNotificationsToUsers([token], title, body);
      });
      FirebaseHelper.createNewChat(userMap['id']!, userMap['name']!,otheUser.userID, otheUser.name);
    }
    return await FirebaseHelper.approveOrRejectRequestToJoinEvent(otheUser.userID, theEvent, approve);
  }

  /// [eventID] - Represent current user request status of the given event
  /// @return type - int representing:
  ///  -1 -- Not relevant to this method
  ///   0 -- New event, the user never interacted with it
  ///   1 -- Request sent, creator hasn't responded yet
  ///   2 -- The event creator approved the request
  static Future<int> getStatusEventForUser(String eventID) async{
    int res = await FirebaseHelper.getStatusEventForUser(eventID);
    int toReturn = -1;
    switch(res){
      case 0:
        toReturn = Events.ASK;
        break;
      case 1:
        toReturn = Events.GOING;
        break;
      case 2: // event creator say no, but we not telling that to the user
        toReturn = Events.ASK;
        break;
      case -1:
        toReturn = Events.NOT_ASK_YET_AND_NOT_GOING;
        break;
    }
    return toReturn;
  }

  /// Returns all the notifications that are related to the current user
  /// [myNotifications] - [List] of [MyNotification] that holds all the user related notifications
  static Future<List<MyNotification>> getListNotification() async{
    // TODO - New messages notifications - Need to implement?
    List<MyNotification> myNotifications = [];
    // get all join request user have to events he create
    List<MyNotification> temp  = await FirebaseHelper.getUserJoinRequest(userMap['id']!);
    temp.forEach((element) {
      //print("in getUserJoinRequest");
      myNotifications.add(element);
    });
    // get all events he have be approve
    temp  = await FirebaseHelper.getUserApprovedRequest(userMap['id']!);
    temp.forEach((element) {
      //print("in getUserAprovedRequest ${element.type}");
      myNotifications.add(element);
    });
    return myNotifications;
  }

  /// [userID] - Represent the current user ID
  /// [event] - Represent the event the user canceled
  static Future<bool> userCancelation(String userID, Events event) async {
    Logic.getTokenNotificationForAUser(event.userID).then((token){
      String title = "משתתף ביטל את הגעתו";
      String body = "משתתף שהיה אמור לבוא לאירוע שיצרת ביטל את הגעתו";
      sendPushNotificationsToUsers([token],title,body);
    });
    return await FirebaseHelper.userCancelation(userID, event);
  }

  /// Method to save current user "notificationToken"
  static saveMyRegistrationToken() async { // TODO - call this method when the userMap['id'] is initialized
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    String registrationToken = await _messaging.getToken()??"";
    FirebaseHelper.saveUserRegistrationToken(userMap['userID']!,registrationToken);
  }

  /// [userID] - Represent the User ID (the user of which you wish to send a notification to)
  /// @return type - User object property named -> "notificationToken"
  static Future<String> getTokenNotificationForAUser(String userID) async {
    return FirebaseHelper.getTokenNotificationForAUser(userID);
  }

  /// This function send notifications to users
  // based on - https://stackoverflow.com/questions/54380063/flutter-how-can-i-send-push-notification-programmatically-with-fcm
  /// [idsTokens] - Represent a [List] of users ids of their machines ( to get one token use [getTokenNotificationForAUser] )
  /// [title] - Represent the title of the notification
  /// [body] - Represent the body of the notification
  static Future<bool> sendPushNotificationsToUsers(List<String> idsTokens, String title, String body) async {

    final postUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final data = {
      "registration_ids" : idsTokens,
      "collapse_key" : "type_a",
      "notification" : {
        "title": title,
        "body" : body,
      }
    };
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAAWCoywHc:APA91bEQubuHl4R-lZLnPG5LSbVHlO6LiQB9cKjaXrowsY_4RlZYu9E8X1VdiylN7QFF-9jnBY8OgGRINGgvnC1CnnM0KRLtymkTNCsLw92M2X3rcZCS09aZGRUn3UGH6Jfbtz0CTmJ1'
    };
    final response = await http.post(postUrl,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

  static sendTestNotification() async {
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    String registrationToken = await _messaging.getToken() ?? "";
    String title = "כותרת!!!";
    String body = "תכולה";
    sendPushNotificationsToUsers([registrationToken], title, body);
  }

}
