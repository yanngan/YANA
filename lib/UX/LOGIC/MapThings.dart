import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yana/UX/LOGIC/Logic.dart';

import 'CLASSES/allClasses.dart';

class MapThings{


  static getMarkers() async {
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    CameraPosition CurrntUserLocation = await Logic.getUserLocation();
    var latitude = CurrntUserLocation.target.latitude;
    var longitude = CurrntUserLocation.target.longitude;
    for(int i = 0 ;i < 10 ; i++){
      String text = "latitude = $latitude longitude = $longitude";
      Place tempPlace = new Place("$i",i,"name $i",latitude+i,longitude+i);
      Event tempEvent = new Event(tempPlace,"event id-$i");
      markers[MarkerId("$i")] = new MyMarker(tempEvent,markerId: MarkerId("$i"),position: LatLng(latitude+i,longitude+i),onTap: (){
        print(tempEvent.place.name);
      });
    }
    return markers;

  }
}