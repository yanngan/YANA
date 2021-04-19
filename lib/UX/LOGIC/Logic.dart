//FLUTTER
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
//EXCEPTIONS
import 'EXCEPTIONS/CanNotGetUserLocationException.dart';

/// Developers: Lidor Eliyahu Shelef, Yann Ganem, Yisrael Bar-Or and Jonas Sperling

class Logic{

  ///getUserLocation
  ///try to get hes current ;ocation, if fail ->
  /// then try to get last know location
  ///   if fail (position == null) ->
  ///     throw CanNotGetUserLocationException

  static Future<CameraPosition> getUserLocation() async{
    Position position;
    try {
      position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high,timeLimit: Duration(seconds: 3));
    }
    catch (e){
      position = await getLastKnownPosition();
    }
    if(position == null){
      throw CanNotGetUserLocationException();
    }
    print(position);
    CameraPosition toReturn = CameraPosition(
      target: LatLng(position.latitude,position.longitude),
      zoom: 18.4746,);
    return toReturn;
  }
}



