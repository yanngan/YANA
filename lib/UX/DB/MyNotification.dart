class MyNotification{

  /// [EVENTS_CHANGE] - [bool] Flag to indicate that the event have some changes made to him
  /// [EVENTS_ASK_TO_JOIN] - [bool] Flag that the event has a new join request from some user
  /// [EVENTS_ASK_TO_JOIN_BEEN_APPROVE] - [bool] Flag to let the user know that the request has been approved
  static const EVENTS_CHANGE = 0;
  static const EVENTS_ASK_TO_JOIN = 1;
  static const EVENTS_ASK_TO_JOIN_BEEN_APPROVE = 2;

  /// [eventsID] - [String] The event ID
  /// [userID] - [String] The user that wants to join ID
  /// [creatorID] - [String]  The event creator ID
  /// [statusForUser] - [int] The status of the user request
  /// [type] - [int] Type of the event
  String eventsID;
  String userID;
  String creatorID;
  int statusForUser; //by the const in Events class
  int type;
  // constructor
  MyNotification(this.eventsID, this.userID, this.creatorID, this.statusForUser, this.type);


  /// In order to print the MyNotification object
  @override
  String toString() {
    return "eventsID = ${this.eventsID} , userID = ${this.userID} ,CreatorID = ${this.creatorID} , statusForUser = ${this.statusForUser} , type = ${this.type} , ";
  }

}