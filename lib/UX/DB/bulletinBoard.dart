class BulletinBoard{

  /// [bulletName] - [String] Representing the name of each bullet
  /// [date] - [String] The date the bullet is set to be in
  /// [entryPrice] - [String] The entry price for the current bullet
  /// [eventIcon] - [String] The icon representing the bullet
  /// [extraData] - [String] Extra data the creator wish to add
  /// [extraLink] - [String] Extra link for the users to click and see
  /// [extraLinkName] - [String] Name for the extra link
  /// [googleMapsLink] - [String] Link to Google Maps
  /// [location] - [String] The location of the bullet
  /// [startTime] - [String] The time the bullet event should start
  /// [visibility] - [String] Visibility of the bullet event ( public, private, else )
  String bulletName;
  String date;
  String entryPrice;
  String eventIcon;
  String extraData;
  String extraLink;
  String extraLinkName;
  String googleMapsLink;
  String location;
  String startTime;
  String visibility;

  /// In order to print the bulletinBoard object
  @override
  String toString() {
    return 'BulletinBoard{bulletName: $bulletName, date: $date, entryPrice: $entryPrice, eventIcon: $eventIcon, extraData: $extraData, extraLink: $extraLink, extraLinkName: $extraLinkName, googleMapsLink: $googleMapsLink, location: $location, startTime: $startTime, visibility: $visibility}';
  }

  // constructor
  BulletinBoard(
      this.bulletName,
      this.date,
      this.entryPrice,
      this.eventIcon,
      this.extraData,
      this.extraLink,
      this.extraLinkName,
      this.googleMapsLink,
      this.location,
      this.startTime,
      this.visibility
    );

  /// Parse a json to BulletinBoard object
  /// [json] - The [Json] object to translate
  factory BulletinBoard.fromJson(dynamic json) {
    return BulletinBoard(
      json['bulletName'] as String,
      json['date'] as String,
      json['entryPrice'] as String,
      json['eventIcon'] as String,
      json['extraData'] as String,
      json['extraLink'] as String,
      json['extraLinkName'] as String,
      json['googleMapsLink'] as String,
      json['location'] as String,
      json['startTime'] as String,
      json['visibility'] as String,

    );
  }

  /// Make a json object
  Map<String, dynamic> toJson() {
    return {
      "bulletName": this.bulletName,
      "date":  this.date,
      "entryPrice":  this.entryPrice,
      "eventIcon":  this.eventIcon,
      "extraData": this.extraData,
      "extraLink": this.extraLink,
      "extraLinkName":  this.extraLinkName,
      "googleMapsLink": this.googleMapsLink,
      "location": this.location,
      "startTime": this.startTime,
      "visibility": this.visibility,
    };
  }


}


