import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yana/UI/PAGES/Utilities.dart';
import 'package:yana/UX/LOGIC/EXCEPTIONS/CanNotGetUserLocationException.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';

class MapSample extends StatefulWidget {

  @override
  State<MapSample> createState() => MapSampleState();

}

class MapSampleState extends State<MapSample> {

  /// [_controller] - [GoogleMapController] allows us to control the map
  /// [markers] - [Map] of all the places on the map
  /// [mapType] - [bool] Represents the map type ( normal / hybrid ) - defaulted to [defaultMapType]
  /// [initDone] - [bool] flag that represent that all the markers loading is complete
  /// [tries] - [int] representing the number of tried [GoogleMap] API tried to show the no location dialog
  /// [_tlv] - Default location to Tel-Aviv Israel
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool mapType = defaultMapType; // true == MapType.hybrid, false == MapType.normal
  bool initDone = false;
  int tries = 0;
  static final CameraPosition _tlv = CameraPosition( //init poit to be at TLV
    target: LatLng(32.085300, 34.781769),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    if(!initDone){
      jumpToCurrentLocation();
      addLocationsPoints();
    }
    //jumpToCurrentLocation();
    return new Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: GoogleMap(
          zoomControlsEnabled: false,   // False reason -> could'nt figure out how to move it's position from our custom navigation bar
          zoomGesturesEnabled: true,
          mapType: mapType ? MapType.hybrid : MapType.normal,
          initialCameraPosition: _tlv,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(markers.values),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        heroTag: 'mapType',
                        onPressed: switchMapType,
                        backgroundColor: Colors.amber,
                        child: Icon(mapType?Icons.satellite:Icons.map_outlined, color: Colors.pink,size: 30,),
                      ),
                    ),  // Change map type
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        heroTag: 'current_user_location',
                        onPressed: jumpToCurrentLocation,
                        backgroundColor: Colors.amber,
                        child: Icon(Icons.location_searching, color: Colors.pink,size: 30,),
                      ),
                    ),  // Focus on current user geo location
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        heroTag: 'notifications',
                        onPressed: openNotifications,
                        backgroundColor: Colors.amber,
                        child: Icon(Icons.notifications, color: Colors.pink,size: 30,),
                      ),
                    ),  // Open notifications page
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: FloatingActionButton(
//                        heroTag: 'add',
//                        onPressed: ()=> MapLogic.addEditSeePoints(context,'add'),
//                        backgroundColor: Colors.amber,
//                        child: Icon(Icons.add, color: Colors.pink,size: 30,),
//                      ),
//                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }


  /// Get [CameraPosition] and move the map to this place coordinates
  /// [locationToGo] - Represent the wanted place [CameraPosition]
  Future<void> _goTo(CameraPosition locationToGo) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(locationToGo));
  }

  /// Go to current user place in the map
  void jumpToCurrentLocation() async {
    try {
      if(tries == 0){
        Logic.getUserLocation().then((value){
          initDone = true;
          _goTo(value);
        });
        tries += 1;
      }
    } on CanNotGetUserLocationException catch (_) {
      Fluttertoast.showToast(
          msg: "שירותי מיקום לא זמינים",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  /// [res] - Temporary variable to hold all the markers
  /// [markers] - Initialized
  void addLocationsPoints()async{
    var res = await MapLogic.getMarkers(context);
    setState(() {
      markers = res;
    });
  }

  /// Switched the map type using [mapType] variable change
  void switchMapType(){
    setState(() {
      mapType = !mapType;
    });
  }

  /// Opens the notifications page
  openNotifications(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationPage()),
    );
  }

}