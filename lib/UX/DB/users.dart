class User {

  String userID;
  String name;
  String email;
  String gender;
  String birthday;//DateTime
  // ignore: non_constant_identifier_names
  int age_range;
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
        'name: $name, '
        'email: $email, '
        'gender: $gender, '
        'birthday: $birthday, '
        'age_range: $age_range, '
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
      json['name'] as String,
      json['email'] as String,
      json['gender'] as String,
      json['birthday'] as String,
      int.parse(json['age_range']), // TODO -> Do not push this line, old line: json['age_range'] as int,
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
      userInfo["userID"].toString(),
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
      userInfo["fbPhoto"].toString(),
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
      this.name,
      this.email,
      this.gender,
      this.birthday,
      this.age_range,
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
      "name": this.name,
      "email":this.email,
      "gender":this.gender,
      "birthday": this.birthday,
      "age_range": this.age_range,
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
      "name": this.name,
      "email":this.email,
      "gender":this.gender,
      "birthday": this.birthday,
      "age_range": this.age_range.toString(),
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