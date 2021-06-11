import 'package:flutter/material.dart';

/// Custom made exception for not finding the user location or general location
class CanNotGetUserLocationException implements Exception{

  /// [message] - Exception text
  final String message = "CAN'T GET USER LOCATION!";

  String toString() {
    return message;
  }

}