class Places{

  String placeID;
  String address;
  String phoneNumber;
  String representative;
  int capacity;
  String vibe;
  bool isKosher;
  String openingHours;
  String name;
  int ageRestrictions;
  String webLink;//could be url
  String googleMapLink;//could be url

  //constructor
  Places(
      this.placeID,
      this.address,
      this.phoneNumber,
      this.representative,
      this.capacity,
      this.vibe,
      this.isKosher,
      this.openingHours,
      this.name,
      this.ageRestrictions,
      this.webLink,
      this.googleMapLink);


  //parse a json to user object
  factory Places.fromJson(dynamic json) {
    return Places(
      json['placeID'] as String,
      json['address'] as String,
      json['phoneNumber'] as String,
      json['representative'] as String,
      json['capacity'] as int,
      json['vibe'] as String,
      json['isKosher'] as bool,
      json['openingHours'] as String,
      json['name'] as String,
      json['ageRestrictions'] as int,
      json['webLink'] as String,
      json['googleMapLink'] as String,
    );
  }

//make a json object
  Map<String, dynamic> toJson() {
    return {
      "placeID": this.placeID,
      "address": this.address,
      "phoneNumber": this.phoneNumber,
      "representative":this.representative,
      "capacity":this.capacity,
      "vibe":this.vibe,
      "isKosher":this.isKosher,
      "openingHours":this.openingHours,
      "ageRestrictions":this.ageRestrictions,
      "webLink":  this.webLink,
      "googleMapLink":this.googleMapLink,
    };
  }












}