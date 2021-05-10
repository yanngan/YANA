import 'package:yana/UX/DB/user.dart';

class Events{

  String eventID;
  User user;
  String creationDate;//DateTime
  bool status;//if it active
  String startEstimate;//DateTime
  String endEstimate;//DateTime
  int curNumPeople;
  int maxNumPeople;
  String placeID;

  //constructor
  Events(
      this.eventID,
      this.user,
      this.creationDate,
      this.status,
      this.startEstimate,
      this.endEstimate,
      this.curNumPeople,
      this.maxNumPeople,
      this.placeID);



  //parse a json to user object
  factory Events.fromJson(dynamic json) {
    return Events(
      json['eventID'] as String,
      json['user'] as User,
      json['creationDate'] as String,
      json['status'] as bool,
      json['startEstimate'] as String,
      json['endEstimate'] as String,
      json['curNumPeople'] as int,
      json['maxNumPeople'] as int,
      json['placeID'] as String,

    );
  }


//make a json object
  Map<String, dynamic> toJson() {
    return {
      "eventID": this.eventID,
      "user":  this.user.toJson(),
      "creationDate":  this.creationDate,
      "status": this.status,
      "startEstimate": this.startEstimate,
      "endEstimate":  this.endEstimate,
      "curNumPeople": this.curNumPeople,
      "maxNumPeople": this.maxNumPeople,
      "placeID": this.placeID,
    };
  }
}