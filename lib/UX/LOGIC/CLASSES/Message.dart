class Message {
   String self_name;
   String other_name;
   String message;
   String createdAt;


  Message(this.self_name, this.other_name, this.message, this.createdAt);

  Map<String, dynamic> toJson() => {
    'self_name': self_name,
    'other_name': other_name,
    'message': message,
    'createdAt': createdAt,
    // 'createdAt': fromDateTimeToJson(createdAt),
  };


  //parse a json to user object
  factory Message.fromJson(dynamic json) {
    return Message(
      json['self_name'] as String,
      json['other_name'] as String,
      json['message'] as String,
      json['createdAt'] as String,
    );
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
