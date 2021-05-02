import 'allClasses.dart';

class Place{
  String placeID;
  String address;
  String name;
  String phoneNum;
  String representive;
  int capacity;
  int isKosher; // 0-d'ont know , 1-yes , 2-no
  int ageRestrictions; // -1 -> d'ont know
  String webLink;
  String googleMapLink;
  double latitude;
  double longitude;

  Place(
    this.placeID,
    this.capacity,
    this.name,
    this.latitude,
    this.longitude,
    {
      this.address = "" ,
      this.phoneNum = "",
      this.representive = "",
      this.isKosher = 0,// 0-d'ont know , 1-yes , 2-no
      this.ageRestrictions = -1,
      this.webLink = "",
      this.googleMapLink = ""
    }
  );


}