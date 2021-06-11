class Place{

  /// [placeID] - ID of the place
  /// [address] - Address of the place ( location )
  /// [phoneNumber] - The place phone number
  /// [representative] - The person the user can call or talk to in the place
  /// [capacity] - Max number of people allowed in this place
  /// [vibe] - The general vibe of the place
  /// [isKosher] - [bool] flag to determine if the place is kosher or not
  /// [openingHours] - The place opening hours
  /// [name] - Name of the place
  /// [ageRestrictions] - Minimum age for entry to this place
  /// [webLink] - The place web link ( can be website/ Facebook and more )
  /// [googleMapLink] - Google Maps link
  /// [latitude] - latitude of the place location
  /// [longitude] - longitude of the place location
  /// [placeIcon] - Icon for the place ( can be logo or anything else )
  /// [city] - The city the place is at
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
  String latitude;
  String longitude;
  String placeIcon;
  String city;

  // constructor
  Place(
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
    this.googleMapLink,
    this.latitude,
    this.longitude,
    this.placeIcon,
    this.city
  );

  /// In order to print the MyNotification object in a special way
  String specialToString(){
    String kosher= isKosher ? "כשר" : "לא כשר";
    return 'כתובת: $address\n'
        'איש קשר במקום: $representative\n'
        'מספר ליצירת קשר: $phoneNumber\n'
        'תכולה: $capacity\nוייב: $vibe\n'
        'כשרות: $kosher\nשעת פתיחה: $openingHours';

  }

  /// In order to print the MyNotification object
  @override
  String toString() {
    return 'Places{placeID: $placeID, address: $address, phoneNumber: $phoneNumber, representative: $representative, capacity: $capacity, vibe: $vibe, isKosher: $isKosher, openingHours: $openingHours, name: $name, ageRestrictions: $ageRestrictions, webLink: $webLink, googleMapLink: $googleMapLink, placeIcon: $placeIcon}';
  }

  /// Parse a json to place object
  /// [json] - The [Json] object to translate
  factory Place.fromJson(dynamic json) {
    return Place(
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
      json['latitude'] as String,
      json['longitude'] as String,
      json['placeIcon'] as String,
      json['city'] as String,
    );
  }

  /// make a json object
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
      "name":  this.name,
      "googleMapLink":this.googleMapLink,
      "latitude":this.latitude,
      "longitude": this.longitude,
      "placeIcon": this.placeIcon,
      "city": this.city,
    };
  }

}
