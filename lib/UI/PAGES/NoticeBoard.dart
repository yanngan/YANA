import 'dart:collection';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yana/UI/WIDGETS/EmptyScreen.dart';
import 'package:yana/UX/LOGIC/CLASSES/firebaseHelper.dart';
import '../WIDGETS/MyAppBar.dart';
import 'Utilities.dart';

class NoticeBoard extends StatefulWidget {
  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

Queue _opened = Queue();
List<Advertisement> advertisements = [];

class _NoticeBoardState extends State<NoticeBoard> {
  bool isInitialized = false;

//  late bool _isEmptyList;
  bool _isEmptyList = false;
  String details = "";

  @override
  void initState() {
    super.initState();
    initBoardwithFb();
  }

  //Initiate all the details and colors for all the Advert Card.
  void initBoardwithFb() async {
    var FbData = await FirebaseHelper.getBulletinBoardFromFb();
    advertisements = [];
    int index = 0;
    FbData.forEach((element) {
      String details = "\u2022 כתובת\b: ${element.location}\n"
          "\u2022 תאריך\b: ${element.date}\n"
          "\u2022 עלות כניסה\b: ${element.entryPrice}\n"
          "\u2022 זמן התחלה\b: ${element.startTime}\n";
      if (index % 2 == 0) {
        advertisements.add(Advertisement(
            // this.context,
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

            // this.context,
            this.context,
            Color(0xfffad5b8),
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
    isInitialized = true;
    setState(() {
      advertisements;
    });
  // advertisements = [];

    if (advertisements.isEmpty) {
      _isEmptyList = true;
    } else {
      _isEmptyList = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            getBulletinBody(),
            SizedBox(
                height: appBarHeight,
                child: MyAppBar("לוח מודעות", null, height: appBarHeight)),
          ],
        ),
      ),
    );
  }

  Widget getBulletinBody() {
    // if (_isEmptyList) {
    //   return EmptyScreen(text: "אין מודעות עדיין,\nאנא חזור מאוחר יותר");
    // } else {
      return Container(
        color: Colors.amber,
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 40),
            child: Container(
              child: Column(
                children: [
                  isInitialized
                      ? (advertisements.isEmpty
                          ? Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 2.7,
                              ),
                              EmptyScreen(
                                  text: "אין מודעות עדיין,\nאנא חזור מאוחר יותר"),
                            ],
                          )
                          : Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 60,
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: advertisements),
                                ],
                              ),
                            ))
                      : Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2.7,
                          ),
                          SpinKitFadingCircle(
                              color: Colors.white,
                              size: (MediaQuery.of(context).size.width / 7),
                            ),
                        ],
                      ),
                ],
              ),
            ),
          ),
        ]),
      );
    }
  // }
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
  BuildContext pagecontext;

  // BuildContext pagecontext;

  //Constructor
  Advertisement(
      //     this.pagecontext,
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
  double _width = 500;
  double _height = 100;
  bool _isOpen = false;
  String extra_link_name_to_use = "";
  String maps_links_to_use = "";

  @override
  void initState() {
    // _height = (MediaQuery.of(widget.pagecontext).size.height / 9);
    // _width = (MediaQuery.of(widget.pagecontext).size.width);
    super.initState();
    extra_link_name_to_use = "\u2022${widget.adv_extraLinkName}\n";
    maps_links_to_use = "\u2022 ניתוב למקום >\n";
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
          _height -= widget.adv_details.length +
              extra_link_name_to_use.length +
              maps_links_to_use.length +
              20;
          _isOpen = false;
        } else {
          _height += widget.adv_details.length +
              extra_link_name_to_use.length +
              maps_links_to_use.length +
              20;
          _isOpen = true;
          _opened.add(this);
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
        margin: EdgeInsets.fromLTRB(6, 6, 6, 20.0),
        duration: Duration(milliseconds: 500),
        child: GestureDetector(
          key: UniqueKey(),
          onTap: () {
            // SetState of the open/close functionality
            if (_opened.isNotEmpty) {
              if (_opened.first == this) {
                onPressed();
                _opened.clear();
                return;
              }
              _opened.first.onPressed();
              _opened.clear();
            }
            onPressed();
          },
          // I put a column in case that we want another widget in the bottom.
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5.0,
                        offset: Offset(3, 2),
                        color: Colors.black.withOpacity(0.35),
                        spreadRadius: 0.5, // Shadow position
                      ),
                    ],
                  ),

                  ///Column of the "card"
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      ///Title widget the does not change dynamically.
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(widget.adv_icon),
                                  radius: 30.0,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: AutoSizeText(
                                  widget.adv_name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[900],
                                      fontFamily: 'FontPacifico'),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: _isOpen ?
                                IconButton(
                                    onPressed: () {
                                      if (_opened.isNotEmpty) {
                                        if (_opened.first == this) {
                                          onPressed();
                                          _opened.clear();
                                          return;
                                        }
                                        _opened.first.onPressed();
                                        _opened.clear();
                                      }
                                      onPressed();
                                    },
                                    icon: Icon(Icons.arrow_circle_up))
                                    : IconButton(
                                    onPressed: () {
                                      if (_opened.isNotEmpty) {
                                        if (_opened.first == this) {
                                          onPressed();
                                          _opened.clear();
                                          return;
                                        }
                                        _opened.first.onPressed();
                                        _opened.clear();
                                      }
                                      onPressed();
                                    },
                                    icon: Icon(Icons.arrow_circle_down)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///End of Title Part.
                      //Advert details.
                      Expanded(
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 700),
                          opacity: _isOpen ? 1 : 0,
                          ///This column is here because of the expanded need to be in a directionaly widget (column,row,flex)
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          AutoSizeText(
                                            widget.adv_details,
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily: 'FontRaleway',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                              fontSize: 16,
                                              letterSpacing: 1,
                                              decorationThickness: 2,
                                              wordSpacing: 1,
                                            ),
                                          ),
                                          Container(
                                            transform: Matrix4.translationValues(0, -20, 0),
                                            // height: double.parse(extra_link_name_to_use.length.toString()),
                                            child: RichText(
                                                text: new TextSpan(
                                                    text: extra_link_name_to_use,
                                                    style: new TextStyle(
                                                      fontFamily: 'FontRaleway',
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.blueAccent,
                                                      decoration: TextDecoration.underline,
                                                      fontSize: 16,
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
                                            transform: Matrix4.translationValues(0, -40, 0),
                                            // height: double.parse(maps_links_to_use.length.toString()),
                                            child: RichText(
                                                text: new TextSpan(
                                                    text: maps_links_to_use,
                                                    style: new TextStyle(
                                                      fontFamily: 'FontRaleway',
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.blueAccent,
                                                      decoration: TextDecoration.underline,
                                                      fontSize: 16,
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
// class Cards_Title extends StatelessWidget {
//   @override
//   var name;
//   var fb;
//   Cards_Title(this.name, this.fb);
//
//   Widget build(BuildContext context) {
//     return Center(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
//             child: CircleAvatar(
//               backgroundImage: NetworkImage(fb),
//               radius: 30.0,
//             ),
//           ),
//           Text(
//             name,
//             style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.w400,
//                 color: Colors.grey[900],
//                 fontFamily: 'FontPacifico'),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 10, 15, 0),
//             child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_circle_down),splashColor: Colors.green,),
//           ),
//         ],
//       ),
//     );
//   }
// }
