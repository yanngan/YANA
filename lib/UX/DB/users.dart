class Users {

  String userName;
  String userID;
  String dateOfBirth;//DateTime
  String bio;
  String fbPhoto;
  String signUpDate;//DateTime
  bool isBlocked;
  bool notifications;
  String nickName;
  String sex;


  @override
  String toString() {
    return 'User{userName: $userName, userID: $userID, dateOfBirth: $dateOfBirth, bio: $bio, fbPhoto: $fbPhoto, signUpDate: $signUpDate, isBlocked: $isBlocked, notifications: $notifications, nickName: $nickName, sex: $sex}';
  }
  //parse a json to user object
  factory Users.fromJson(dynamic json) {
    return Users(json['userName'] as String,
      json['userID'] as String,
      json['dateOfBirth'] as String,
      json['bio'] as String,
      json['fbPhoto'] as String,
      json['signUpDate'] as String,
      json['isBlocked'] as bool,
      json['notifications'] as bool,
      json['nickName'] as String,
      json['sex'] as String,
    );
  }
  //constructor
  Users(
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