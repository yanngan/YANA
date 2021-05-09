import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../UX/LOGIC/CLASSES/Place.dart';
import '../WIDGETS/MyAppBar.dart';

class NoticeBoard extends StatefulWidget {
  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

//data is an array of Places to simulate the firebase data.
List<Advertisement> advertisements = [];
List<Place> data = [
  new Place(
    '000000001',
    100,
    'Chez Andi',
    156.48797894,
    80.236598,
    address: "14 Yafo,Jerusalem",
    phoneNum: "02854978756",
    representive: "Yoram",
    isKosher: 2,
    ageRestrictions: 18,
    webLink: "htpp//fgefzffcz",
    googleMapLink: "gvzsfgvrzsfgvrs",
  ),
  new Place(
    '000000041',
    100,
    'Katsefte',
    156.48797894,
    80.236598,
    address: "14 Yafo,Jerusalem",
    phoneNum: "02854978756",
    representive: "Yoram",
    isKosher: 2,
    ageRestrictions: 18,
    webLink: "htpp//fgefzffcz",
    googleMapLink: "gvzsfgvrzsfgvrs",
  ),
  new Place(
    '000000002',
    100,
    'Rimon',
    156.48797894,
    80.236598,
    address: "14 Yafo,Jerusalem",
    phoneNum: "02854978756",
    representive: "Yoram",
    isKosher: 2,
    ageRestrictions: 18,
    webLink: "htpp//fgefzffcz",
    googleMapLink: "gvzsfgvrzsfgvrs",
  ),
  new Place(
    '000000004',
    100,
    'Pythagore',
    156.48797894,
    80.236598,
    address: "14 Yafo,Jerusalem",
    phoneNum: "02854978756",
    representive: "Yoram",
    isKosher: 2,
    ageRestrictions: 18,
    webLink: "htpp//fgefzffcz",
    googleMapLink: "gvzsfgvrzsfgvrs",
  ),
  new Place(
    '000000006',
    100,
    'Jackie Chan',
    156.48797894,
    80.236598,
    address: "14 Yafo,Jerusalem",
    phoneNum: "02854978756",
    representive: "Yoram",
    isKosher: 2,
    ageRestrictions: 18,
    webLink: "htpp//fgefzffcz",
    googleMapLink: "gvzsfgvrzsfgvrs",
  ),
  new Place(
    '000000106',
    100,
    'Jackie Chan',
    156.48797894,
    80.236598,
    address: "14 Yafo,Jerusalem",
    phoneNum: "02854978756",
    representive: "Yoram",
    isKosher: 2,
    ageRestrictions: 18,
    webLink: "htpp//fgefzffcz",
    googleMapLink: "gvzsfgvrzsfgvrs",
  ),
  new Place(
    '000000082',
    100,
    'Jackie Chan',
    156.48797894,
    80.236598,
    address: "14 Yafo,Jerusalem",
    phoneNum: "02854978756",
    representive: "Yoram",
    isKosher: 2,
    ageRestrictions: 18,
    webLink: "htpp//fgefzffcz",
    googleMapLink: "gvzsfgvrzsfgvrs",
  ),
  new Place(
    '000000666',
    100,
    'Jackie Chan',
    156.48797894,
    80.236598,
    address: "14 Yafo,Jerusalem",
    phoneNum: "02854978756",
    representive: "Yoram",
    isKosher: 2,
    ageRestrictions: 18,
    webLink: "htpp//fgefzffcz",
    googleMapLink: "gvzsfgvrzsfgvrs",
  ),
  new Place(
    '000000008',
    100,
    'Hatsarfat',
    156.48797894,
    80.236598,
    address: "14 Yafo,Jerusalem",
    phoneNum: "02854978756",
    representive: "Yoram",
    isKosher: 2,
    ageRestrictions: 18,
    webLink: "htpp//fgefzffcz",
    googleMapLink: "gvzsfgvrzsfgvrs",
  ),
];

class _NoticeBoardState extends State<NoticeBoard> {
  @override
  void initState() {
    super.initState();
    initPlacesList(); // In order to populate our Advertisement list
    //Here will be the sorting of the data coming from firebase
  }

  //Initiate all the details and colors for all the Advert Card.
  void initPlacesList() {
    for (int i = 0; i < data.length; i++) {

      String details = "Address: ${data[i].address},\n"
          "Representive: ${data[i].representive},\n"
          "Capacity: ${data[i].capacity},\n"
          "AgeRestriction: ${data[i].ageRestrictions},\n"
          "Link: ${data[i].webLink},\n"
          "Map: ${data[i].googleMapLink}\n";

      if (i % 2 == 0) {
        advertisements.add(Advertisement(
            Colors.purple[200]!,
            data[i].getName(),
            data[i].getIsKosher(),
            data[i].getPhoneNumber(),
            Colors.grey[900]!,
            details));
      } else {
        advertisements.add(Advertisement(
            Colors.purple[400]!,
            data[i].getName(),
            data[i].getIsKosher(),
            data[i].getPhoneNumber(),
            Colors.grey[400]!,
            details));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        children: [
          Container(
            color: Colors.amber,
            child: ListView(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 40),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 85,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: advertisements,
                      )
                    ],
                    // ],
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 110,
            child: MyAppBar("NoticeBoard", null, height: 110)
          ),
        ],
      ),
    );
  }
}

//Advertisement Widget
class Advertisement extends StatefulWidget {

  String adv_name;
  String adv_details;
  int adv_isKosher;
  String adv_phoneNum;
  Color color;
  Color expansiontilecolor;

  var children = [];

  //Constructor
  Advertisement(this.color, this.adv_name, this.adv_isKosher, this.adv_phoneNum,
      this.expansiontilecolor, this.adv_details);

  @override
  _AdvertisementState createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  double _width = 200;
  double _height = 110;
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedContainer(
        width: _width,
        height: _height,
        margin: EdgeInsets.fromLTRB(6, 6, 6, 10.0),
        duration: Duration(milliseconds: 700),
        child: GestureDetector(
          onTap: () {
            //SetState of the open/close functionality
            setState(() {
              if (_isOpen) {
                _height -= widget.adv_details.length + 30;
                _isOpen = false;
              } else {
                _height += widget.adv_details.length + 30;
                _isOpen = true;
              }
            });
          },
          // I put a column in case that we want another widget in the bottom.
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: widget.color,

                  //Column of the "card"
                  child: Column(
                    children: <Widget>[
                      //Title widget the does not change dynamically.
                      Cards_Title(widget.adv_name),
                      //Advert details.
                      Expanded(
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 700),
                          opacity: _isOpen ? 1 : 0,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 2, 0, 10),
                                child: Text(
                                  widget.adv_details,
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    decorationThickness: 2,
                                    wordSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Advert Title Widget
class Cards_Title extends StatelessWidget {
  @override
  var name;
  Cards_Title(this.name);
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/yana_logo.png'),
            radius: 40.0,
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: Text(
              name,
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                  fontFamily: 'Font2'),
            )),
      ],
    );
  }
}
