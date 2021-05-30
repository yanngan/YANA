import 'package:yana/UX/DB/users.dart';

class Events{

  String eventID;
  String  userID;
  String  userName;
  String creationDate;//DateTime
  bool status;//if it active
  String startEstimate;//DateTime
  String endEstimate;//DateTime
  int curNumPeople;
  int maxNumPeople;
  String placeID;
  String placeName;
  String note;
  int statusForUser;//0-not ask+not going , 1-ask, 2-going '-1'-don't know
  static const NOT_ASK_YET_AND_NOT_GOING = 0;
  static const ASK = 1;
  static const GOING = 2;
  static const DONT_KNOW = -1;

  //constructor
  Events(
      this.eventID,
      this.userID,
      this.userName,
      this.creationDate,
      this.status,
      this.startEstimate,
      this.endEstimate,
      this.curNumPeople,
      this.maxNumPeople,
      this.placeID,
      this.placeName,
      this.note,
      {this.statusForUser=-1});



  //parse a json to event object
  factory Events.fromJson(dynamic json) {
    return Events(
      json['eventID'] as String,
      json['userID'] as String,
      json['userName'] as String,
      json['creationDate'] as String,
      json['status'] as bool,
      json['startEstimate'] as String,
      json['endEstimate'] as String,
      json['curNumPeople'] as int,
      json['maxNumPeople'] as int,
      json['placeID'] as String,
      json['placeName'] as String,
      json['note'] as String,
    );
  }


  @override
  String toString() {
    return 'Events{eventID: $eventID, userID: $userID, userName: $userName, creationDate: $creationDate, status: $status, startEstimate: $startEstimate, endEstimate: $endEstimate, curNumPeople: $curNumPeople, maxNumPeople: $maxNumPeople, placeID: $placeID, placeName: $placeName, note: $note}';
  }
  //make a json object
  Map<String, dynamic> toJson() {
    return {
      "eventID": this.eventID,
      "userID":  this.userID,
      "userName":  this.userName,
      "creationDate":  this.creationDate,
      "status": this.status,
      "startEstimate": this.startEstimate,
      "endEstimate":  this.endEstimate,
      "curNumPeople": this.curNumPeople,
      "maxNumPeople": this.maxNumPeople,
      "placeID": this.placeID,
      "placeName": this.placeName,
      "note": this.note,
    };
  }
}