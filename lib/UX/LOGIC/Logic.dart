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

class Logic {
  ///getUserLocation
  ///try to get hes current location, if fail ->
  /// then try to get last know location
  ///   if fail (position == null) ->
  ///     throw CanNotGetUserLocationException

  static Future<CameraPosition> getUserLocation() async {
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
        Logic.callOnFcmApiSendPushNotifications(tokens,title,body);
      });
    }
    if (await FirebaseHelper.sendEventToFb(theNewEvents)) {
      return theNewEvents;
    } else {
      return null;
    }
  }


  static Future<List<Events>> getEventsByPlace(String IDPlaces) async{
    /// todo: check internet connection

    /// todo: go to DB and get all the vent having the IDPlaces
    // - trow Error if have problem
    // return the List of Events we found
    // User tempU = new User("userID","userName","email","sex","dateOfBirth",0,"hobbies","bio","livingArea","workArea","academicInstitution","fieldOfStudy","smoking","fbPhoto","signUpDate",false,true);
    // Events tempE = new Events("eventID",tempU , "creationDate", true, "startEstimate", "endEstimate", 10, 12, "placeID");
    //
    // return [
    //   tempE,tempE,tempE,tempE,tempE,tempE,tempE,tempE,
    // ];
    return await FirebaseHelper.getEventsByPlaceID(IDPlaces);
  }

  static Future<List<Place>> getAllPlaces() async {
    /// todo: check internet connection

    /// todo: go to DB and get all the Places
    // - trow Error if have problem
    // return the List of Places we found

    return FirebaseHelper.getPlacesFromFb();
    // Place tempP = new Place("placeID", "address", "phoneNumber", "representative", 10, "vibe", true,"openingHours", "name", 21, "webLink", "googleMapLink");
    // return [tempP,tempP,tempP,tempP];
  }

  static Future<Place> getPlacesById(String IDPlaces) async {
    /// todo: check internet connection

    /// todo: go to DB and get the Places BY IDPlaces
    // - trow Error if have problem
    // return the List of Places we found
    var tempP = await FirebaseHelper.getPlaceByID(IDPlaces);
    return tempP!;
  }

  static Future<List<Events>> getAllUserEvent() async {
    return await FirebaseHelper.getUserEvents(userMap['id']!);
  }

  static Future<List<Events>> getEventsByCondition({int maxNumPeople = -1,String estimateDate = '',String startEstimateTime = "",String placesName = ""}) async {
    print("maxNumPeople = $maxNumPeople");
    print("estimateDate = $estimateDate");
    print("startEstimateTime = $startEstimateTime");
    print("placesName = $placesName");
    if(maxNumPeople == -1){
      maxNumPeople = 100;
    }
    return await FirebaseHelper.getEventsBySearchCombination(name:placesName,capacity:maxNumPeople,date:  estimateDate );
  }


  static Future<bool> userAskToJoinEvent(String userID,String eventID,String creatorUserID) async{
    Logic.getTokenNotificationForAUser(creatorUserID).then((token){
      String title = "יש לך בקשת הצטרפות";
      String body = "ישנה בקשת הצטרפות אשר ממתינה לך עבור אירוע שאותה יצרת";
      Logic.callOnFcmApiSendPushNotifications([token], title, body);
    });
    if(await FirebaseHelper.userAskToJoinEvent(userID,eventID,creatorUserID)){
      return true;
    }
    return false;
  }

  static Future<bool> approveOrRejectRequestToJoinEvent(String userID,Events theEvents,bool approve) async{
    if(approve){
      Logic.getTokenNotificationForAUser(userID).then((token){
        String title = "בקשתך להצטרף לאירוע אושרה!";
        String body = "בקשתך להצטרך לאירוע אושרה על-ידי מארגן האירוע";
        Logic.callOnFcmApiSendPushNotifications([token], title, body);
      });
    }
    return await FirebaseHelper.approveOrRejectRequestToJoinEvent(userID,theEvents,approve);
  }

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
      case 2://event creator say no, but we not telling that to the user
        toReturn = Events.ASK;
        break;
      case -1:
        toReturn = Events.NOT_ASK_YET_AND_NOT_GOING;
        break;
    }
    return toReturn;
  }


  static Future<List<MyNotification>> getListNotification() async{
    List<MyNotification> myNotifications = [];
    //get all join request user have to events he create
    List<MyNotification> temp  = await FirebaseHelper.getUserJoinRequest(userMap['id']!);
    temp.forEach((element) {
      print("in getUserJoinRequest");
      myNotifications.add(element);
    });
    //get all events he have be approve
    temp  = await FirebaseHelper.getUserApprovedRequest(userMap['id']!);
    temp.forEach((element) {
      print("in getUserAprovedRequest ${element.type}");
      myNotifications.add(element);
    });
    return myNotifications;
  }

  static Future<bool> userCancelation(String userID,Events event)async{
    Logic.getTokenNotificationForAUser(event.userID).then((token){
      String title = "משתתף ביטל את הגעתו";
      String body = "משתתף שהיה אמור לבוא לאירוע שיצרת ביטל את הגעתו";
      callOnFcmApiSendPushNotifications([token],title,body);
    });
    return await FirebaseHelper.userCancelation(userID, event);
  }

  static saveMyRegistrationToken()async{
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    String registrationToken = await _messaging.getToken()??"";
    FirebaseHelper.saveUserRegistrationToken(userMap['id']!,registrationToken);
  }

  static Future<String> getTokenNotificationForAUser(String userID)async{
    return FirebaseHelper.getTokenNotificationForAUser(userID);
  }


  static sendTestNotification()async{
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    String registrationToken = await _messaging.getToken()??"";
    String title = "כותרת!!!";
    String body = "תכולה";
    callOnFcmApiSendPushNotifications([registrationToken],title,body);
  }


  //use this function to send notification to users
  //based on - https://stackoverflow.com/questions/54380063/flutter-how-can-i-send-push-notification-programmatically-with-fcm
  static Future<bool> callOnFcmApiSendPushNotifications(List<String> idsTokens,String title,String body) async {

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
}
