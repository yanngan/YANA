import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yana/UI/WIDGETS/allWidgets.dart';
import 'package:yana/UX/LOGIC/Logic.dart';

import 'CLASSES/allClasses.dart';

class MapLogic{

  /*
  return list of Markers to position on the map
  for now it's simulate fake Events
   */
  static getMarkers(BuildContext context) async {
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    CameraPosition CurrntUserLocation = await Logic.getUserLocation();
    var latitude = CurrntUserLocation.target.latitude;
    var longitude = CurrntUserLocation.target.longitude;
    for(int i = 0 ;i < 10 ; i++){
      String text = "latitude = $latitude longitude = $longitude";
      Place tempPlace = new Place("$i",i,"name $i",latitude+i,longitude+i);
      Event tempEvent = new Event(tempPlace,"event id-$i");
      markers[MarkerId("$i")] = new MyMarker(tempEvent,markerId: MarkerId("$i"),position: LatLng(latitude+i,longitude+i),onTap: (){
        addEditeSeePoints(context);
      });
    }
    return markers;

  }


  /*
  create alert dialog with AddSeeEvent widget
   */
  static addEditeSeePoints(BuildContext context) async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Add new Place ! 😋",style: TextStyle(color: Colors.amber),),
          backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          content: AddSeeEvent(),
          actions: <Widget>[
            new TextButton(
              child: new Text("OK",style: TextStyle(color: Colors.amber),),
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