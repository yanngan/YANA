import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import '../../UX/LOGIC/CLASSES/Place.dart';
import '../WIDGETS/MyAppBar.dart';

class NoticeBoard extends StatefulWidget {
  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

//data is an array of Places to simulate the firebase data.
Queue<_AdvertisementState> Opened = Queue();
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
    address: "14 Yafo,Yafo",
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
    address: "415 Haifa",
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
      String details = "\u2022 Address\b: ${data[i].address}\n"
          "\u2022 Representive\b: ${data[i].representive}\n"
          "\u2022 Capacity\b: ${data[i].capacity}\n"
          "\u2022 AgeRestriction\b: ${data[i].ageRestrictions}\n"
          "\u2022 Link\b: ${data[i].webLink}\n"
          "\u2022 Map\b: ${data[i].googleMapLink}\n";

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
                      SizedBox(
                        height: 70,
                      ),
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
              height: 110, child: MyAppBar("NoticeBoard", null, height: 110)),
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
  void onPressed() {
    setState(() {
      if (_isOpen) {
        _height -= widget.adv_details.length + 30;
        _isOpen = false;
      } else {
        _height += widget.adv_details.length + 30;
        _isOpen = true;
        Opened.add(this);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedContainer(
        width: _width,
        height: _height,
        margin: EdgeInsets.fromLTRB(6, 6, 6, 10.0),
        duration: Duration(milliseconds: 700),
        child: GestureDetector(
          key: UniqueKey(),
          onTap: () {
            //SetState of the open/close functionality
            
            if (Opened.isNotEmpty) {
              if(Opened.first == this){
                onPressed();
                Opened.clear();
                return;
              }
              Opened.first.onPressed();
              Opened.clear();
            }
            onPressed();
            //) onPressed();
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Title widget the does not change dynamically.
                      Cards_Title(widget.adv_name,
                          "https://upload.wikimedia.org/wikipedia/en/thumb/c/c3/Flag_of_France.svg/1200px-Flag_of_France.svg.png"),
                      //Advert details.
                      Expanded(
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 700),
                          opacity: _isOpen ? 1 : 0,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 2, 0, 10),
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.adv_details,
                                    style: TextStyle(
                                      fontFamily: 'Font1',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      fontSize: 20,
                                      letterSpacing: 1,
                                      decorationThickness: 2,
                                      wordSpacing: 1,
                                    ),
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
  var fb;
  Cards_Title(this.name, this.fb);

  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(fb),
            radius: 40.0,
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: Text(
              name,
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[900],
                  fontFamily: 'Font2'),
            )),
      ],
    );
  }
}
