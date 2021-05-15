import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yana/UI/WIDGETS/allWidgets.dart';
import 'package:yana/UX/LOGIC/Logic.dart';

import 'CLASSES/allClasses.dart';
import '../DB/allDB.dart';

class MapLogic{

  /*
  return list of Markers to position on the map
  for now it's simulate fake Events
   */
  static getMarkers(BuildContext context) async {
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    CameraPosition currentUserLocation = await Logic.getUserLocation();
    var latitude = currentUserLocation.target.latitude;
    var longitude = currentUserLocation.target.longitude;
    for(int i = 0 ;i < 10 ; i++){
      //String text = "latitude = $latitude longitude = $longitude";
      Places tempPlace = Places("$i", "address", "phoneNumber", "representative", 10, "vibe", true,"openingHours", "name", 21, "webLink", "googleMapLink");

      //Event tempEvent = new Event(tempPlace,"event id-$i");
      markers[MarkerId("$i")] = new MyMarker(tempPlace,markerId: MarkerId("$i"),position: LatLng(latitude+i,longitude+i),onTap: (){
        seeListEventInPlace(context,tempPlace);
      });
    }
    return markers;

  }


  /*
  create alert dialog with AddSeeEvent widget
   */
  static seeListEventInPlace(BuildContext context,Places thePlace) async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ListEventsForMap(thePlace);
      },
    );
  }

  static addEditSeePoints(BuildContext context,{var theEvent}) async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Add new Event ! 😋",style: TextStyle(color: Colors.blueGrey),),
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          content: AddSeeEvent(),
          actions: <Widget>[
            new TextButton(
              child: new Text("OK",style: TextStyle(color: Colors.blueGrey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}