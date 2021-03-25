import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:yana/UX/LOGIC/Logic.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  Completer<GoogleMapController> _controller = Completer();

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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton.extended(
          onPressed: jumpToCurrentLocation,
          backgroundColor: Colors.amber,
          label: Text('To My Location!', style: TextStyle(fontSize: 20, color: Colors.black87),),
          icon: Icon(Icons.directions_boat, color: Colors.black54,),
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

//    Fluttertoast.showToast(
//        msg: "Location:\n" + CurrntUserLocation.toString(),
//        toastLength: Toast.LENGTH_LONG,
//        gravity: ToastGravity.CENTER,
//        timeInSecForIosWeb: 1,
//        backgroundColor: Colors.red,
//        textColor: Colors.white,
//        fontSize: 16.0
//    );

  }





}