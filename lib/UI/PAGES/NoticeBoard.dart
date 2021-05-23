import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yana/UX/LOGIC/CLASSES/firebaseHelper.dart';
import '../WIDGETS/MyAppBar.dart';

class NoticeBoard extends StatefulWidget {
  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

//data is an array of Places to simulate the firebase data.
Queue<_AdvertisementState> Opened = Queue();
List<Advertisement> advertisements = [];
bool isInitialized = false;
// List<Place> data = [
//   new Place(
//     '000000001',
//     100,
//     'Chez Andi',
//     156.48797894,
//     80.236598,
//     address: "14 Yafo,Jerusalem",
//     phoneNum: "02854978756",
//     representive: "Yoram",
//     isKosher: 2,
//     ageRestrictions: 18,
//     webLink: "htpp//fgefzffcz",
//     googleMapLink: "gvzsfgvrzsfgvrs",
//   ),
//   new Place(
//     '000000041',
//     100,
//     'Katsefte',
//     156.48797894,
//     80.236598,
//     address: "14 Yafo,Yafo",
//     phoneNum: "02854978756",
//     representive: "Yoram",
//     isKosher: 2,
//     ageRestrictions: 18,
//     webLink: "htpp//fgefzffcz",
//     googleMapLink: "gvzsfgvrzsfgvrs",
//   ),
//   new Place(
//     '000000002',
//     100,
//     'Rimon',
//     156.48797894,
//     80.236598,
//     address: "415 Haifa",
//     phoneNum: "02854978756",
//     representive: "Yoram",
//     isKosher: 2,
//     ageRestrictions: 18,
//     webLink: "htpp//fgefzffcz",
//     googleMapLink: "gvzsfgvrzsfgvrs",
//   ),
//   new Place(
//     '000000004',
//     100,
//     'Pythagore',
//     156.48797894,
//     80.236598,
//     address: "14 Yafo,Jerusalem",
//     phoneNum: "02854978756",
//     representive: "Yoram",
//     isKosher: 2,
//     ageRestrictions: 18,
//     webLink: "htpp//fgefzffcz",
//     googleMapLink: "gvzsfgvrzsfgvrs",
//   ),
//   new Place(
//     '000000006',
//     100,
//     'Jackie Chan',
//     156.48797894,
//     80.236598,
//     address: "14 Yafo,Jerusalem",
//     phoneNum: "02854978756",
//     representive: "Yoram",
//     isKosher: 2,
//     ageRestrictions: 18,
//     webLink: "htpp//fgefzffcz",
//     googleMapLink: "gvzsfgvrzsfgvrs",
//   ),
//   new Place(
//     '000000106',
//     100,
//     'Jackie Chan',
//     156.48797894,
//     80.236598,
//     address: "14 Yafo,Jerusalem",
//     phoneNum: "02854978756",
//     representive: "Yoram",
//     isKosher: 2,
//     ageRestrictions: 18,
//     webLink: "htpp//fgefzffcz",
//     googleMapLink: "gvzsfgvrzsfgvrs",
//   ),
//   new Place(
//     '000000082',
//     100,
//     'Jackie Chan',
//     156.48797894,
//     80.236598,
//     address: "14 Yafo,Jerusalem",
//     phoneNum: "02854978756",
//     representive: "Yoram",
//     isKosher: 2,
//     ageRestrictions: 18,
//     webLink: "htpp//fgefzffcz",
//     googleMapLink: "gvzsfgvrzsfgvrs",
//   ),
//   new Place(
//     '000000666',
//     100,
//     'Jackie Chan',
//     156.48797894,
//     80.236598,
//     address: "14 Yafo,Jerusalem",
//     phoneNum: "02854978756",
//     representive: "Yoram",
//     isKosher: 2,
//     ageRestrictions: 18,
//     webLink: "htpp//fgefzffcz",
//     googleMapLink: "gvzsfgvrzsfgvrs",
//   ),
//   new Place(
//     '000000008',
//     100,
//     'Hatsarfat',
//     156.48797894,
//     80.236598,
//     address: "14 Yafo,Jerusalem",
//     phoneNum: "02854978756",
//     representive: "Yoram",
//     isKosher: 2,
//     ageRestrictions: 18,
//     webLink: "htpp//fgefzffcz",
//     googleMapLink: "gvzsfgvrzsfgvrs",
//   ),
// ];

class _NoticeBoardState extends State<NoticeBoard> {
  @override
  void initState() {
    if (isInitialized) {
      return;
    }
    super.initState();
    initPlacesList();
    isInitialized = true;
    // In order to populate our Advertisement list
    //Here will be the sorting of the data coming from firebase
  }

  //Initiate all the details and colors for all the Advert Card.
  void initPlacesList() async {
    // var FbData = await FirebaseHelper.getPlacesFromFb();
    var FbData = await FirebaseHelper.getBulletinBoardFromFb();

    int index = 0;
    FbData.forEach((element) {
      String details = "\u2022 Address\b: ${element.location}\n"
          "\u2022 Date\b: ${element.date}\n"
          "\u2022 Entry Price\b: ${element.entryPrice}\n"
          "\u2022 Link\b: ${element.extraLinkName}\n"
          "\u2022 Start Time\b: ${element.startTime}\n"
          "\u2022 Maps\b: ${element.googleMapsLink}\n";

      if (index % 2 == 0) {
        advertisements.add(Advertisement(Color(0xfff3b5a5), element.bulletName,
            element.eventIcon, Colors.grey[900]!, details,element.googleMapsLink,element.extraLink,element.extraLinkName));
      } else {
        advertisements.add(Advertisement(Color(0xfffad5b8),element.bulletName,
            element.eventIcon, Colors.grey[900]!, details,element.googleMapsLink,element.extraLink,element.extraLinkName));
      }
      index++;
    });
    setState(() {
      advertisements;
    });
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
  String adv_icon;
  Color color;
  Color expansiontilecolor;
  String adv_mapsLink;
  String adv_extraLink;
  String adv_extraLinkName;

  //Constructor
  Advertisement(this.color, this.adv_name, this.adv_icon,
      this.expansiontilecolor, this.adv_details, this.adv_mapsLink,
      this.adv_extraLink,this.adv_extraLinkName);

  @override
  _AdvertisementState createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  double _width = 200;
  double _height = 100;
  bool _isOpen = false;
  var indexof_linkname;
  @override
  // void initState() {
  //   // TODO: implement initState
  //   indexof_linkname = widget.adv_details.indexOf(widget.adv_extraLinkName);
  // }

  void launchUrl(String url) async{
    if(await canLaunch(url)){
      launchUrl(url);
    }
    else{
        throw "Cannot launch the url";
    }
  }

  void onPressed() {
    if (this.mounted) {
      setState(() {
        if (_isOpen) {
          _height -= widget.adv_details.length;
          _isOpen = false;
        } else {
          _height += widget.adv_details.length;
          print(widget.adv_details);
          _isOpen = true;
          Opened.add(this);
        }
      });
    }
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
              if (Opened.first == this) {
                onPressed();
                Opened.clear();
                return;
              }
              Opened.first.onPressed();
              Opened.clear();
            }
            onPressed();
          },
          // I put a column in case that we want another widget in the bottom.
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(4, 8), // Shadow position
                      ),
                    ],
                  ),
                  //Column of the "card"
                  child: Column(
                    children: <Widget>[
                      //Title widget the does not change dynamically.
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Cards_Title(widget.adv_name, widget.adv_icon),
                      ),
                      //Advert details.
                      Expanded(
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 700),
                          opacity: _isOpen ? 1 : 0,
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 2, 0, 10),
                                  child: SingleChildScrollView(
                                    child: AutoSizeText(
                                      widget.adv_details,
                                      maxLines: 8,
                                      style: TextStyle(
                                        fontFamily: 'Font1',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        decorationThickness: 2,
                                        wordSpacing: 1,
                                      ),
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0,0,10,0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(fb),
            radius: 40.0,
          ),
        ),
        Text(
          name,
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w400,
              color: Colors.grey[900],
              fontFamily: 'Font2'),
        ),
      ],
    );
  }
}
