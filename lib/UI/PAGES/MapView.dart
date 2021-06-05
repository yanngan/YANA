import 'package:flutter/material.dart';
import 'package:yana/UI/WIDGETS/MapSample.dart';

class MapView extends StatefulWidget {

  @override
  _MapViewState createState() => _MapViewState();

}

// TODO - make the map more clear that is our (YANA) map and not some random widget
class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
         child: MapSample()
        ),
      ),
    );
  }
}




