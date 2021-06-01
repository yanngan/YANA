import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yana/UX/LOGIC/CLASSES/firebaseHelper.dart';
import '../WIDGETS/MyAppBar.dart';

class NoticeBoard extends StatefulWidget {
  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

Queue Opened = Queue();

class _NoticeBoardState extends State<NoticeBoard> {
  List<Advertisement> advertisements = [];
  bool isInitialized = false;
  late bool _isEmptyList;
  String details = "";

  @override
  void initState() {
    super.initState();
//    initBoardwithFb();

    if(advertisements.isEmpty){
      _isEmptyList = true;
    }else{
      _isEmptyList = false;
    }
  }

  //Initiate all the details and colors for all the Advert Card.
  void initBoardwithFb() async {
    var FbData = await FirebaseHelper.getBulletinBoardFromFb();

    int index = 0;
    FbData.forEach((element) {
      String details = "\u2022 Address\b: ${element.location}\n"
          "\u2022 Date\b: ${element.date}\n"
          "\u2022 Entry Price\b: ${element.entryPrice}\n"
          // "\u2022 Link\b: ${element.extraLinkName}\n"
          "\u2022 Start Time\b: ${element.startTime}\n";
      // "\u2022 Maps\b: ${element.googleMapsLink}\n";
      if (index % 2 == 0) {
        advertisements.add(Advertisement(
            Color(0xfff3b5a5),
            element.bulletName,
            element.eventIcon,
            element.googleMapsLink,
            element.extraLink,
            element.extraLinkName,
            element.date,
            element.entryPrice,
            element.location,
            element.startTime,
            details));
      } else {
        advertisements.add(Advertisement(
            Color(0xfffad5b8),
            element.bulletName,
            element.eventIcon,
            element.googleMapsLink,
            element.extraLink,
            element.extraLinkName,
            element.date,
            element.entryPrice,
            element.location,
            element.startTime,
            details));
      }
      index++;
    });
    setState(() {
      advertisements;
    });

    isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        children: [
          getBulletinBody(),
          SizedBox(
              height: 100, child: MyAppBar("לוח מודעות", null, height: 100)),
        ],
      ),
    );
  }

  Widget getBulletinBody(){
    if(_isEmptyList){
      return Container(
        color: Colors.amber,
        child: Center(
          child: SizedBox(
            width: (MediaQuery.of(context).size.width / 1.5),
            child: AutoSizeText(
              "אין מודעות עדיין,\nאנא חזור מאוחר יותר",
              textDirection: TextDirection.rtl,
              maxLines: 2,
              style: TextStyle(fontSize: 1000.0, color: Colors.black.withOpacity(0.65), fontFamily: 'FontSkia'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }else{
      return Container(
        color: Colors.amber,
        child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 40),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      isInitialized
                          ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: advertisements)
                          : SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ],
                  ),
                ),
              ),
            ]
        ),
      );
    }
  }

}

//Advertisement Widget
class Advertisement extends StatefulWidget {
  String adv_name;
  String adv_location;
  String adv_date;
  String adv_entryPrice;
  String adv_startTime;
  String adv_details;
  String adv_icon;
  Color color;
  String adv_mapsLink;
  String adv_extraLink;
  String adv_extraLinkName;

  //Constructor
  Advertisement(
      this.color,
      this.adv_name,
      this.adv_icon,
      this.adv_mapsLink,
      this.adv_extraLink,
      this.adv_extraLinkName,
      this.adv_date,
      this.adv_entryPrice,
      this.adv_location,
      this.adv_startTime,
      this.adv_details);

  @override
  _AdvertisementState createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  double _width = 200;
  double _height = 100;
  bool _isOpen = false;
  String extra_link_name_to_use = "";
  String maps_links_to_use = "";


  @override
  void initState() {
    super.initState();
    extra_link_name_to_use = "\u2022 Link\b: ${widget.adv_extraLinkName}\n";
    maps_links_to_use = "\u2022 Itinerate to the Place\n";
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Cannot launch the url";
    }
  }

  void onPressed() {
    if (this.mounted) {
      setState(() {
        if (_isOpen) {
          _height -= widget.adv_details.length + extra_link_name_to_use.length + maps_links_to_use.length;
          _isOpen = false;
        } else {
          _height += widget.adv_details.length + extra_link_name_to_use.length + maps_links_to_use.length;
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
                        padding: EdgeInsets.symmetric(vertical: 10.0),
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          widget.adv_details,
                                          maxLines: 8,
                                          style: TextStyle(
                                            fontFamily: 'FontRaleway',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                            fontSize: 18,
                                            letterSpacing: 1,
                                            decorationThickness: 2,
                                            wordSpacing: 1,
                                          ),
                                        ),
                                        Container(
                                          transform: Matrix4.translationValues(0, -20, 0),
                                          height: double.parse(extra_link_name_to_use.length.toString()),
                                          child: RichText(
                                              text: new TextSpan(
                                                  text: extra_link_name_to_use,
                                                  style: new TextStyle(

                                                    fontFamily: 'FontRaleway',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.pink,
                                                    fontSize: 18,
                                                    letterSpacing: 1,
                                                    decorationThickness: 2,
                                                    wordSpacing: 1,
                                                  ),
                                                  // style: ,
                                                  recognizer:
                                                  new TapGestureRecognizer()
                                                    ..onTap = () {
                                                      _launchUrl(widget
                                                          .adv_extraLink);
                                                    })),
                                        ),
                                        Container(
                                          transform: Matrix4.translationValues(0, -20, 0),
                                          height: double.parse(maps_links_to_use.length.toString()),
                                          child:
                                          RichText(
                                              text: new TextSpan(
                                                  text: maps_links_to_use,
                                                  style: new TextStyle(
                                                    fontFamily: 'FontRaleway',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.pink,
                                                    fontSize: 18,
                                                    letterSpacing: 1,
                                                    decorationThickness: 2,
                                                    wordSpacing: 1,
                                                  ),
                                                  recognizer:
                                                  new TapGestureRecognizer()
                                                    ..onTap = () {
                                                      _launchUrl(widget
                                                          .adv_mapsLink);
                                                    })),
                                        )

                                      ],
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
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
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
              fontFamily: 'FontPacifico'),
        ),
      ],
    );
  }
}
