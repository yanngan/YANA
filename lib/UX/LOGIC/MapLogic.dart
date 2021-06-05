import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yana/UI/PAGES/Utilities.dart';
import 'package:yana/UI/WIDGETS/allWidgets.dart';
import 'package:yana/UX/LOGIC/Logic.dart';

import 'CLASSES/allClasses.dart';
import '../DB/allDB.dart';

class MapLogic{

  /// [context] - Current page context
  /// Returns all the map markers [markers] representing all the [Place]s on the map
  static getMarkers(BuildContext context) async {
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    List<Place> places = await Logic.getAllPlaces();
    places.forEach((onePlace) {
      markers[MarkerId(onePlace.placeID)] = new MyMarker(onePlace,markerId: MarkerId(onePlace.placeID),position: LatLng(double.parse(onePlace.latitude),double.parse(onePlace.longitude)),onTap: (){
        seeListEventInPlace(context,onePlace);});
    });
    return markers;
  }

  /// Create alert dialog with [List] of all the events in this place
  /// [context] - Current page context
  /// [thePlace] - Desired place for events
  static seeListEventInPlace(BuildContext context, Place thePlace) async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ListEventsForMap(thePlace);
      },
    );
  }

  /// [context] - Current page context
  /// [action] - Add / Edit / Show event keys (add, edit, see) representation
  /// [theEvent] - Desired event to Edit / Show
  /// [thePlace] - Desired place for events
  /// [totallyPop] - A boolean flag that indicates if we should [onClose] should call [seeListEventInPlace] again or not
  static addEditSeePoints(BuildContext context, String action, {var theEvent, var thePlace, bool totallyPop = false}) async {
    var screen;
    switch (action) {
      case 'add':
        screen = AddEvent(thePlace);
        break;
      case 'edit':
        screen = EditEvent(thePlace, theEvent,totallyPop);
        break;
      case 'see':
        screen = SeeEvent(thePlace, theEvent,totallyPop);
        break;
    }
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          content: screen,
          actions: <Widget>[
            new TextButton(
              child: new Text(
                "סגור", style: TextStyle(color: Colors.blueGrey),),
              onPressed: () {
                Navigator.of(context).pop();
                if (!totallyPop) {
                  print("in popTotally");
                  seeListEventInPlace(context, thePlace);
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// [context] - Current page context
  /// [thePlace] - Desired place for events
  /// [totallyPop] - A boolean flag that indicates if we should [onClose] should call [seeListEventInPlace] again or not
//  static askIfReallyWantToCloseTheEditAdd(BuildContext context, Place thePlace, bool totallyPop) {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return AlertDialog(
//          backgroundColor: Colors.amber,
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.all(Radius.circular(20.0))
//          ),
//          content: Text("הנתונים לא נשמרו"),
//          actions: <Widget>[
//            TextButton(
//              child: new Text(
//                "אל תשמור", style: TextStyle(color: Colors.blueGrey),),
//              onPressed: () {
//
//                seeListEventInPlace(context, thePlace);
//              },
//            ),
//            TextButton(
//              child: new Text(
//                "ברצוני להמשיך", style: TextStyle(color: Colors.blueGrey),),
//              onPressed: () {},
//            ),
//          ],
//        );
//      },
//    );
//  }

}