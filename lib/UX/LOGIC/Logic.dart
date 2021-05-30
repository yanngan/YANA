//FLUTTER
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yana/UI/PAGES/AllPage.dart';
//EXCEPTIONS
import '../DB/allDB.dart';
import 'CLASSES/allClasses.dart';
import 'EXCEPTIONS/CanNotGetUserLocationException.dart';

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

  static Future<Events?> createEditNewEvents(
      Events theNewEvents, bool thisIsANewEvent) async {
    // todo: check internet connection

    //todo : Check there no problem with new Events:
    // - Places and time not in other Events
    // - all needed data is in the Events

    // todo: insert into DB
    // - trow Error if have problem

    // todo: get the Events from DB and check that they equal
    // - if yes - return the Events
    // - else trow Error
    // Place tempP = new Place("placeID", "address", "phoneNumber", "representative", 10, "vibe", true,"openingHours", "name", 21, "webLink", "googleMapLink","32.085300", "34.781769");
    // User tempU = new User("userID","userName","email","sex","dateOfBirth",0,"hobbies","bio","livingArea","workArea","academicInstitution","fieldOfStudy","smoking","fbPhoto","signUpDate",false,true);
    // Events tempE = new Events("eventID","tempU" , "tempU" , "creationDate", true, "startEstimate", "endEstimate", 10, 12, "placeID");
    // return tempE;
    if (await FirebaseHelper.sendEventToFb(theNewEvents, thisIsANewEvent)) {
      return theNewEvents;
    } else {
      return null;
    }
  }

/*
  static Future<Events> getEventsByIdEvents(String IDEvents)async{
    // todo: check internet connection

    // todo: get Events from DB
    // only the open once
    // - trow Error if have problem
    // - return the Events we have found
    User tempU = new User("userID","userName","email","sex","dateOfBirth",0,"hobbies","bio","livingArea","workArea","academicInstitution","fieldOfStudy","smoking","fbPhoto","signUpDate",false,true);
    Events tempE = new Events("eventID","tempU" , "tempU" , "creationDate", true, "startEstimate", "endEstimate", 10, 12, "placeID","Aroma","blabla");
    return tempE;
  }
*/
  static Future<List<Events>> getEventsByPlace(String IDPlaces) async {
    // todo: check internet connection

    // todo: go to DB and get all the vent having the IDPlaces
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
    // todo: check internet connection

    // todo: go to DB and get all the Places
    // - trow Error if have problem
    // return the List of Places we found

    return FirebaseHelper.getPlacesFromFb();
    // Place tempP = new Place("placeID", "address", "phoneNumber", "representative", 10, "vibe", true,"openingHours", "name", 21, "webLink", "googleMapLink");
    // return [tempP,tempP,tempP,tempP];
  }

  static Future<Place> getPlacesById(String IDPlaces) async {
    // todo: check internet connection

    // todo: go to DB and get the Places BY IDPlaces
    // - trow Error if have problem
    // return the List of Places we found
    var tempP = await FirebaseHelper.getPlaceByID(IDPlaces);
    return tempP!;
  }

  static Future<List<Events>> getAllUserEvent() async {
    return await FirebaseHelper.getUserEvents(userMap['id']!);
  }

  static Future<List<Events>> getEventsByCondition(
      {int maxNumPeople = -1,
      String estimateDate = '',
      String startEstimateTime = "",
      String placesName = ""}) async {
    print("maxNumPeople = $maxNumPeople");
    print("estimateDate = $estimateDate");
    print("startEstimateTime = $startEstimateTime");
    print("placesName = $placesName");
    return await getAllUserEvent();
  }
}
