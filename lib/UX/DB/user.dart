class User {

  String userName;
  String userID;
  DateTime dateOfBirth;
  String bio;
  String fbPhoto;
  DateTime signUpDate;
  bool isBlocked;
  bool notifications;
  String nickName;
  String sex;

  //parse a json to user object
  factory User.fromJson(dynamic json) {
    return User(json['userName'] as String,
      json['userID'] as String,
      json['dateOfBirth'] as DateTime,
      json['bio'] as String,
      json['fbPhoto'] as String,
      json['signUpDate'] as DateTime,
      json['isBlocked'] as bool,
      json['notifications'] as bool,
      json['nickName'] as String,
      json['sex'] as String,
    );
  }
  //constructor
  User(
      this.userName,
      this.userID,
      this.dateOfBirth,
      this.bio,
      this.fbPhoto,
      this.signUpDate,
      this.isBlocked,
      this.notifications,
      this.nickName,
      this.sex
      );


//make a json object
  Map<String, dynamic> toJson() {
    return {
      "userName": this.userName,
      "userID": this.userID,
      "dateOfBirth": this.dateOfBirth,
      "bio":this.bio,
      "fbPhoto":this.fbPhoto,
      "signUpDate":this.signUpDate,
      "isBlocked":this.isBlocked,
      "notifications":this.notifications,
      "nickName":this.nickName,
      "sex":this.sex
    };
  }
}