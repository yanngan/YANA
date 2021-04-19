import 'package:flutter/material.dart';


class CanNotGetUserLocationException implements Exception{
  final String message = "CAN'T GET USER LOCATION!";
  String toString() {
    return message;
  }
}