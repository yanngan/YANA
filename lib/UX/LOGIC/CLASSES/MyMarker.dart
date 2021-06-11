import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../DB/allDB.dart';

class MyMarker extends Marker{

  /// [place] - Represents the desired place object
  final Place place;

  // constructor
  const MyMarker(
    this.place,
    {
      required markerId,
      alpha = 1.0,
      anchor = const Offset(0.5, 1.0),
      consumeTapEvents = false,
      draggable = false,
      flat = false,
      icon = BitmapDescriptor.defaultMarker,
      infoWindow = InfoWindow.noText,
      position = const LatLng(0.0, 0.0),
      rotation = 0.0,
      visible = true,
      zIndex = 0.0,
      onTap,
      onDragEnd,
    })
    : super(
        markerId:markerId,
        alpha:alpha,
        anchor:anchor,
        consumeTapEvents:consumeTapEvents,
        draggable:draggable,
        flat:flat,
        icon:icon,
        infoWindow:infoWindow,
        position:position,
        rotation:rotation,
        visible:visible,
        zIndex:zIndex,
        onTap:onTap,
        onDragEnd:onDragEnd
      );

}


