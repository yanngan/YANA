


class MyNotification{
  static const EVENTS_CHANGE = 0;
  static const EVENTS_ASK_TO_JOIN = 1;
  static const EVENTS_ASK_TO_JOIN_BEEN_APPROVE = 2;

  String eventsID;
  String userID;
  String CreatorID;
  int statusForUser; //by the const in Events class
  int type;
  MyNotification(this.eventsID,this.userID,this.CreatorID,this.statusForUser,this.type);


  @override
  String toString() {
    return "eventsID = ${this.eventsID} , userID = ${this.userID} ,CreatorID = ${this.CreatorID} , statusForUser = ${this.statusForUser} , type = ${this.type} , ";
  }

}