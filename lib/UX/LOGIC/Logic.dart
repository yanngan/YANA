//FLUTTER
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
//EXCEPTIONS
import 'CLASSES/allClasses.dart';
import 'EXCEPTIONS/CanNotGetUserLocationException.dart';

/// Developers: Lidor Eliyahu Shelef, Yann Ganem, Yisrael Bar-Or and Jonas Sperling

class Logic{

  ///getUserLocation
  ///try to get hes current location, if fail ->
  /// then try to get last know location
  ///   if fail (position == null) ->
  ///     throw CanNotGetUserLocationException

  static Future<CameraPosition> getUserLocation() async{
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,timeLimit: Duration(seconds: 3));
    }
    catch (e){
      position = await Geolocator.getLastKnownPosition();
    }
    if(position == null){
      throw CanNotGetUserLocationException();
    }
    print(position);
    CameraPosition toReturn = CameraPosition(
      target: LatLng(position.latitude,position.longitude),
      zoom: 18.4746,);
    return toReturn;
  }

  static Future<Event> createNewEvent(Event theNewEvent) async{
    // todo: check internet connection

    //todo : Check there no problem with new Event:
    // - place and time not in other Event
    // - all needed data is in the Event

    // todo: insert into DB
    // - trow Error if have problem


    // todo: get the Event from DB and check that they equal
    // - if yes - return the Event
    // - else trow Error
    return new Event(new Place("demo", -1, "name", -1, -1),"demo","2021-05-12 19:30:00",1);
  }

  static Future<Event> getEventByIdEvent(String IDEvent)async{
    // todo: check internet connection

    // todo: get Event from DB
    // only the open once
    // - trow Error if have problem
    // - return the Event we have found
    return new Event(new Place("demo", -1, "name", -1, -1),"demo","2021-05-12 19:30:00",1);
  }

  static Future<List<Event>> getEventsByPlace(String IDPlace) async{
    // todo: check internet connection

    // todo: go to DB and get all the vent having the IDPlace
    // - trow Error if have problem
    // return the List of Event we found

    return [
      new Event(new Place("demo1", -1, "name1", -1, -1),"demo1","2021-05-12 19:30:00",1),
      new Event(new Place("demo2", -1, "name2", -1, -1),"demo2","2021-05-12 19:30:00",1),
      new Event(new Place("demo3", -1, "name3", -1, -1),"demo3","2021-05-12 19:30:00",1),
      new Event(new Place("demo4", -1, "name4", -1, -1),"demo4","2021-05-12 19:30:00",1),
      new Event(new Place("demo5", -1, "name5", -1, -1),"demo5","2021-05-12 19:30:00",1),
    ];
  }

  static Future<List<Place>> getAllPlaces()async{
    // todo: check internet connection

    // todo: go to DB and get all the places
    // - trow Error if have problem
    // return the List of Places we found
    return [new Place("demo", -1, "name", -1, -1)];
  }


  static Future<Place> getPlaceById(String IDPlace) async{
    // todo: check internet connection

    // todo: go to DB and get the Place BY IDPlace
    // - trow Error if have problem
    // return the List of Places we found
    return new Place("demo", -1, "name", -1, -1);
  }

  static Future<List<Event>> getEventsByCondition({int status = -1,String startEstimate = "",String endEstimate = "",String placeName= "",bool going=false})async{
    return [
      new Event(new Place("demo1", -1, "name1", -1, -1),"demo1","2021-05-12 19:30:00",1),
      new Event(new Place("demo2", -1, "name2", -1, -1),"demo2","2021-05-12 19:30:00",1),
      new Event(new Place("demo3", -1, "name3", -1, -1),"demo3","2021-05-12 19:30:00",1),
      new Event(new Place("demo4", -1, "name4", -1, -1),"demo4","2021-05-12 19:30:00",1),
      new Event(new Place("demo5", -1, "name5", -1, -1),"demo5","2021-05-12 19:30:00",1),
    ];
  }

}



