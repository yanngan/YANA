import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';

import 'allWidgets.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool mapType = true; // true == MapType.hybrid, false == MapType.normal

  static final CameraPosition _TLV = CameraPosition( //init poit to be at TLV
    target: LatLng(32.085300, 34.781769),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    //jumpToCurrentLocation();
    return new Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,   // False reason -> could'nt figure out how to move it's position from our custom navigation bar
        zoomGesturesEnabled: true,
        mapType: mapType ? MapType.hybrid : MapType.normal,
        initialCameraPosition: _TLV,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
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
                        onPressed: switchMapType,
                        backgroundColor: Colors.amber,
                        child: Icon(mapType?Icons.satellite:Icons.map_outlined, color: Colors.pink,size: 30,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        onPressed: jumpToCurrentLocation,
                        backgroundColor: Colors.amber,
                        child: Icon(Icons.location_searching, color: Colors.pink,size: 30,),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        onPressed: ()=>addFakePoints(context),
                        backgroundColor: Colors.amber,
                        child: Icon(Icons.ac_unit_sharp, color: Colors.pink,size: 30,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        onPressed: ()=>MapLogic.addEditeSeePoints(context),
                        backgroundColor: Colors.amber,
                        child: Icon(Icons.add, color: Colors.pink,size: 30,),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }

  /*Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }*/


  /*
  get CameraPosition and move the mape to this place
   */
  Future<void> _goTo(CameraPosition locationToGo) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(locationToGo));
  }

  /*
  go to the current user plase
   */
  void jumpToCurrentLocation() async {
    CameraPosition CurrntUserLocation = await Logic.getUserLocation();
    _goTo(CurrntUserLocation);
  }

  /*
  dev function creat 10 fake Events and add them to the map
   */
  void addFakePoints(BuildContext context)async{
    var res = await MapLogic.getMarkers(context);
    setState(() {
      markers = res;
    });
  }

  /*
  switch Map Type
  bool mapType = true; // true == MapType.hybrid, false == MapType.normal
   */
  void switchMapType(){
    setState(() {
      mapType = !mapType;
    });
  }




}