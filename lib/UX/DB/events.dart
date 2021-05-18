import 'package:yana/UX/DB/users.dart';

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



  //parse a json to event object
  factory Events.fromJson(dynamic json) {
    return Events(
      json['eventID'] as String,
      User.fromJson(json['user']) ,
      json['creationDate'] as String,
      json['status'] as bool,
      json['startEstimate'] as String,
      json['endEstimate'] as String,
      json['curNumPeople'] as int,
      json['maxNumPeople'] as int,
      json['placeID'] as String,

    );
  }


  @override
  String toString() {
    return 'Events{eventID: $eventID, user: $user, creationDate: $creationDate, status: $status, startEstimate: $startEstimate, endEstimate: $endEstimate, curNumPeople: $curNumPeople, maxNumPeople: $maxNumPeople, placeID: $placeID}';
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