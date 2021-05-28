class BulletinBoard{

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

  @override
  String toString() {
    return 'BulletinBoard{bulletName: $bulletName, date: $date, entryPrice: $entryPrice, eventIcon: $eventIcon, extraData: $extraData, extraLink: $extraLink, extraLinkName: $extraLinkName, googleMapsLink: $googleMapsLink, location: $location, startTime: $startTime, visibility: $visibility}';
  }

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
      this.visibility);



  //parse a json to BulletinBoard object
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

  //make a json object
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


