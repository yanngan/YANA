class Message {

  /// [selfName] - Current user name
  /// [otherName] - Other user name
  /// [selfID] - Current user ID
  /// [otherID] - Other user ID
  /// [message] - The message itself
  /// [createdAt] - The creation date of the message
  String selfName;
  String otherName;
  String selfID;
  String otherID;
  String message;
  String createdAt;
  // constructor
  Message(this.selfName, this.otherName, this.selfID, this.otherID, this.message, this.createdAt);

   /// Make a json object
  Map<String, dynamic> toJson() => {
    'selfName': selfName,
    'otherName': otherName,
    'selfID': selfID,
    'otherID': otherID,
    'message': message,
    'createdAt': createdAt,
  };

   /// Parse a json object  into an event object
   /// [json] - The [Json] object to translate
  factory Message.fromJson(dynamic json) {
    return Message(
      json['selfName'] as String,
      json['otherName'] as String,
      json['selfID'] as String,
      json['otherID'] as String,
      json['message'] as String,
      json['createdAt'] as String,
    );
  }

   /// In order to print the message object
   @override
  String toString() {
    return 'Message{selfName: $selfName, otherName: $otherName, selfID: $selfID, otherID: $otherID, message: $message, createdAt: $createdAt}';
  }

   /// Parse a [DateTime] object  into an event object
   /// [date] - The [DateTime] object to translate
  static dynamic fromDateTimeToJson(DateTime date) {
    // ignore: unnecessary_null_comparison
    if (date == null) {
      return null;
    }
    return date.toUtc();
  }

}
