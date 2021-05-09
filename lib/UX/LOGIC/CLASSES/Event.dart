import 'allClasses.dart';

class Event{
  String eventID;
  String user;
  String creationDate;
  int status; // 0 - open, 1 - full,2 - close
  String startEstimate;
  String endEstimate;
  String curNumPeople;
  String maxNumPeople;
  Place place;
  bool going;

  Event(
    this.place,
    this.eventID,
    this.startEstimate,
    this.status,
      {
        this.user = "",
        this.creationDate = "",
        this.endEstimate = "",
        this.curNumPeople = "",
        this.maxNumPeople = "",
        this.going = false,
      }
  );
}