import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapThings.dart';

import 'allWidgets.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    //jumpToCurrentLocation();
    return new Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,   // False reason -> could'nt figure out how to move it's position from our custom navigation bar
        zoomGesturesEnabled: true,
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
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
                FloatingActionButton(
                  onPressed: jumpToCurrentLocation,
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.location_searching, color: Colors.pink,size: 30,),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: addFakePoints,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.ac_unit_sharp, color: Colors.pink,size: 30,),
                    ),
                    FloatingActionButton(
                      onPressed: ()=>addPoints(context),
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.add, color: Colors.pink,size: 30,),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _goTo(CameraPosition locationToGo) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(locationToGo));
  }

  void jumpToCurrentLocation() async {
    CameraPosition CurrntUserLocation = await Logic.getUserLocation();
    _goTo(CurrntUserLocation);
  }
  void addPoints(BuildContext context) async{
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

  void addFakePoints()async{
    var res = await MapThings.getMarkers();
    setState(() {
      markers = res;
    });
  }





}