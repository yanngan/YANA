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
      print(element.bulletName + ' size: ' + element.bulletName.length.toString());
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
            details
            ));
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
                                    height: MediaQuery.of(context).size.height / 13,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                        children: advertisements),
                                  ),
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
  double _width = 500;
  double _height = 100;
  bool _isOpen = false;
  bool maps_link_is_non_usable = false;
  bool extra_link_is_non_usable = false;
  String extra_link_name_to_use = "";
  String maps_links_to_use = "";
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    extra_link_name_to_use = "\u2022${widget.adv_extraLinkName}\n";
    if(widget.adv_mapsLink == 'null' || widget.adv_mapsLink == 'none'){
      maps_link_is_non_usable = true;
    }
    if(widget.adv_extraLink == 'null' || widget.adv_extraLink == 'none'){
      extra_link_is_non_usable = true;
    }

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
              maps_links_to_use.length + widget.adv_name.length;
          // if(widget.adv_name.length > 18 && widget.adv_name.length < 25)
          //   _height -= widget.adv_name.length * 2;
          // else if(widget.adv_name.length <= 40 && widget.adv_name.length >= 25)
          //   _height -= widget.adv_name.length + 10;
          // else if(widget.adv_name.length > 40)
          //   _height -= widget.adv_name.length;

          _isOpen = false;
        } else {
          _height += widget.adv_details.length +
              extra_link_name_to_use.length +
              maps_links_to_use.length + widget.adv_name.length;
          // if(widget.adv_name.length > 18 && widget.adv_name.length < 25)
          //   _height += widget.adv_name.length * 2;
          // else if(widget.adv_name.length < 40 && widget.adv_name.length > 25)
          //   _height += widget.adv_name.length + 10;
          // else if(widget.adv_name.length > 40)
          //   _height += widget.adv_name.length;

          _isOpen = true;
          _opened.add(this);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: [
          AnimatedContainer(
            width: MediaQuery.of(context).size.width,
            height: _isOpen ? _height : MediaQuery.of(context).size.height / 8.1,
            margin: EdgeInsets.fromLTRB(6, 6, 6, 20.0),
            duration: Duration(milliseconds: 500),
            child: GestureDetector(
              key: UniqueKey(),
              onTap: () {
                /// Function of the open/close functionality
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
              child: Column(
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
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(widget.adv_icon),
                                      radius: 30.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: AutoSizeText(
                                      widget.adv_name,
                                      textAlign: TextAlign.center,
                                      overflow: _isOpen ? TextOverflow.visible : TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey[900],
                                          fontFamily: 'FontPacifico'),),
                                    // !_isOpen ?
                                    // ) : SingleChildScrollView(
                                    //   child: Text(widget.adv_name,style: TextStyle(
                                    //       fontSize: 25,
                                    //       fontWeight: FontWeight.w400,
                                    //       color: Colors.grey[900],
                                    //       fontFamily: 'FontPacifico'),),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          //   child: AnimatedOpacity(
                          //     duration: Duration(milliseconds: 700),
                          //     opacity: _isOpen ? 1:0,
                          //     child: Container(
                          //       height: 1.5,
                          //       width: MediaQuery.of(context).size.width / 7,
                          //       color: Colors.grey[700],
                          //     ),
                          //   ),
                          // ),
                          ///End of Title Part.
                          //Advert details.
                          Expanded(
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 700),
                              opacity: _isOpen ? 1 : 0,
                              ///This column is here because of the expanded need to be in a directionaly widget (column,row,flex)
                              child: Column(
                                children: [
                                  if (widget.adv_name.length > 25) TextButton(onPressed: ()=>{}, child: Icon(Icons.arrow_downward_rounded)),
                                  Expanded(
                                    child: CupertinoScrollbar(
                                      controller: _scrollController,
                                      isAlwaysShown: true,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Container(
                                           decoration: BoxDecoration(

                                           ),
                                            width: MediaQuery.of(context).size.width,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
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
                                                    child: !extra_link_is_non_usable ? RichText(
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
                                                              })):null
                                                  ),
                                                  Container(
                                                    transform: Matrix4.translationValues(0, -40, 0),
                                                    // height: double.parse(maps_links_to_use.length.toString()),
                                                    child: !maps_link_is_non_usable ? RichText(
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
                                                              })):null
                                                  ),
                                                ],
                                              ),
                                            ),
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
        ],
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
