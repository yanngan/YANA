class Message {
   String selfName;
   String otherName;
   String selfID;
   String otherID;
   String message;
   String createdAt;

  Message(this.selfName, this.otherName, this.selfID, this.otherID, this.message, this.createdAt);

  Map<String, dynamic> toJson() => {
    'selfName': selfName,
    'otherName': otherName,
    'selfID': selfID,
    'otherID': otherID,
    'message': message,
    'createdAt': createdAt,
  };

  //parse a json to user object
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

   @override
  String toString() {
    return 'Message{selfName: $selfName, otherName: $otherName, selfID: $selfID, otherID: $otherID, message: $message, createdAt: $createdAt}';
  }

  // static DateTime toDateTime(Timestamp value) {
  //   if (value == null) return null;
  //   return value.toDate();
  // }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;
    return date.toUtc();
  }

}
