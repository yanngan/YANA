class User {

  String userID;
  String userName;
  String email;
  String sex;
  String dateOfBirth;//DateTime
  int age;
  String hobbies;
  String bio;
  String livingArea;
  String workArea;
  String academicInstitution;
  String fieldOfStudy;
  String smoking;
  String fbPhoto;
  String signUpDate;//DateTime
  bool isBlocked;
  bool notifications;

  @override
  String toString() {
    return 'User{'
        'userID: $userID, '
        'userName: $userName, '
        'email: $email, '
        'sex: $sex, '
        'dateOfBirth: $dateOfBirth, '
        'hobbies: $hobbies, '
        'bio: $bio, '
        'livingArea: $livingArea, '
        'workArea: $workArea, '
        'academicInstitution: $academicInstitution, '
        'fieldOfStudy: $fieldOfStudy, '
        'smoking: $smoking, '
        'fbPhoto: $fbPhoto, '
        'signUpDate: $signUpDate, '
        'isBlocked: $isBlocked, '
        'notifications: $notifications, '
        '}';
  }

  //parse a json to user object
  factory User.fromJson(dynamic json) {
    return User(
      json['userID'] as String,
      json['userName'] as String,
      json['email'] as String,
      json['sex'] as String,
      json['dateOfBirth'] as String,
      json['age'] as int,
      json['hobbies'] as String,
      json['bio'] as String,
      json['livingArea'] as String,
      json['workArea'] as String,
      json['academicInstitution'] as String,
      json['fieldOfStudy'] as String,
      json['smoking'] as String,
      json['fbPhoto'] as String,
      json['signUpDate'] as String,
      json['isBlocked'] as bool,
      json['notifications'] as bool,
    );
  }

  // Parse a map into a user object
  factory User.fromMap(Map<String, String> userInfo){
    return User(
      userInfo["id"].toString(),
      userInfo["name"].toString(),
      userInfo["email"].toString(),
      userInfo["gender"].toString(),
      userInfo["birthday"].toString(),
      int.parse(userInfo["age_range"].toString()),
      userInfo["hobbies"].toString(),
      userInfo["bio"].toString(),
      userInfo["livingArea"].toString(),
      userInfo["workArea"].toString(),
      userInfo["academicInstitution"].toString(),
      userInfo["fieldOfStudy"].toString(),
      userInfo["smoking"].toString(),
      userInfo["picture_link"].toString(),
      userInfo["signUpDate"].toString(),
      (userInfo["isBlocked"].toString().toLowerCase() == 'true'),
      (userInfo["notifications"].toString().toLowerCase() == 'true'),
    );
  }

  // Parse a map into a user object
  factory User.isNULL(String value){
    return User(
      value,
      value,
      value,
      value,
      value,
      0,
      value,
      value,
      value,
      value,
      value,
      value,
      value,
      value,
      value,
      false,
      false,
    );
  }

  //constructor
  User(
      this.userID,
      this.userName,
      this.email,
      this.sex,
      this.dateOfBirth,
      this.age,
      this.hobbies,
      this.bio,
      this.livingArea,
      this.workArea,
      this.academicInstitution,
      this.fieldOfStudy,
      this.smoking,
      this.fbPhoto,
      this.signUpDate,
      this.isBlocked,
      this.notifications,
      );

// Make a json object
  Map<String, dynamic> toJson() {
    return {
      "userID": this.userID,
      "userName": this.userName,
      "email":this.email,
      "sex":this.sex,
      "dateOfBirth": this.dateOfBirth,
      "age": this.age,
      "hobbies":this.hobbies,
      "bio":this.bio,
      "livingArea":this.livingArea,
      "workArea":this.workArea,
      "academicInstitution":this.academicInstitution,
      "fieldOfStudy":this.fieldOfStudy,
      "smoking":this.smoking,
      "fbPhoto":this.fbPhoto,
      "signUpDate":this.signUpDate,
      "isBlocked":this.isBlocked,
      "notifications":this.notifications,
    };
  }

//  Make a map object
  Map<String, String> toMap(){
    return {
      "userID": this.userID,
      "userName": this.userName,
      "email":this.email,
      "sex":this.sex,
      "dateOfBirth": this.dateOfBirth,
      "age": this.age.toString(),
      "hobbies":this.hobbies,
      "bio":this.bio,
      "livingArea":this.livingArea,
      "workArea":this.workArea,
      "academicInstitution":this.academicInstitution,
      "fieldOfStudy":this.fieldOfStudy,
      "smoking":this.smoking,
      "fbPhoto":this.fbPhoto,
      "signUpDate":this.signUpDate,
      "isBlocked":this.isBlocked.toString(),
      "notifications":this.notifications.toString(),
    };
  }

}