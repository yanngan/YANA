import 'dart:collection';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yana/UI/WIDGETS/EmptyScreen.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/CLASSES/firebaseHelper.dart';
import '../WIDGETS/MyAppBar.dart';
import 'Utilities.dart';

class NoticeBoard extends StatefulWidget {

  @override
  _NoticeBoardState createState() => _NoticeBoardState();

}

/// [_opened] - A [Queue] object holding all the widgets ( int the list ) in order to check when one is open and close th rest
/// [advertisements] - A [List] of [Advertisement] holding all of the advertisements
Queue _opened = Queue();
List<Advertisement> advertisements = [];

class _NoticeBoardState extends State<NoticeBoard> {

  /// [isInitialized] - [bool] flag to check if the initializing process is finished or not
  /// [_isEmptyList] - [bool] flag to indicate if the list is empty or not
  /// [details] - Each advertisement details
  bool isInitialized = false;
  bool _isEmptyList = false;
  String details = "";

  @override
  void initState() {
    super.initState();
    initBoardWithFb();
  }

  /// Initiate all the details and colors for all the Advert Card.
  /// [fbData] - [List] of [BulletinBoard] from Firebase
  /// [index] - The index of the list
  void initBoardWithFb() async {
    var fbData = await FirebaseHelper.getBulletinBoardFromFb();
    advertisements = [];
    int index = 0;
    fbData.forEach((element) {
      String details = "\u2022 כתובת\b: ${element.location}\n"
          "\u2022 תאריך\b: ${element.date}\n"
          "\u2022 עלות כניסה\b: ${element.entryPrice}\n"
          "\u2022 זמן התחלה\b: ${element.startTime}\n";
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
          details)
        );
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
          )
        );
      }
      index++;
    });
    isInitialized = true;
    setState(() {
      advertisements;
    });

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

  /// Retrieve the bulletin body as a widget ( with the [ListView] inside it )
  Widget getBulletinBody() {
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
                          )
                      )
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

}

// ignore: must_be_immutable
class Advertisement extends StatefulWidget {

  /// [advName] - Advertisement name
  /// [advLocation] - Advertisement location
  /// [advDate] - Advertisement estimated date
  /// [advEntryPrice] - Advertisement entry price ( Free / Amount in NIS )
  /// [advStartTime] - Advertisement estimated start time of the day
  /// [advDetails] - Details about the advertisement
  /// [advIcon] - Advertisement icon ( can be logo, or anything else )
  /// [advMapsLink] - Google Maps link to the location
  /// [advExtraLink] - Advertisement extra link ( can be facebook event / website / etc... )
  /// [advExtraLinkName] - Advertisement extra link name to appear
  /// [color] - Advertisement background color
  String advName;
  String advLocation;
  String advDate;
  String advEntryPrice;
  String advStartTime;
  String advDetails;
  String advIcon;
  String advMapsLink;
  String advExtraLink;
  String advExtraLinkName;
  Color color;

  // constructor
  Advertisement(
      this.color,
      this.advName,
      this.advIcon,
      this.advMapsLink,
      this.advExtraLink,
      this.advExtraLinkName,
      this.advDate,
      this.advEntryPrice,
      this.advLocation,
      this.advStartTime,
      this.advDetails);

  @override
  _AdvertisementState createState() => _AdvertisementState();

}

class _AdvertisementState extends State<Advertisement> {

  /// [_width] - The desired width for the advertisement
  /// [_height] - The desired height for the advertisement
  /// [_isOpen] - [bool] flag to indicate if the current advertisement is open or not
  /// [mapsLinkIsNonUsable] - [bool] flag to indicate if the google map link is usable ot not ( for example if its null )
  /// [extraLinkIsNonUsable] - [bool] flag to indicate if the extra link is usable ot not ( for example if its null )
  /// [extraLinkNameToUse] - The name the extra link should appear to the user with
  /// [mapsLinksToUse] - The google maps link
  /// [_scrollController] - [ScrollController] in order to make configuration to the scroll behavior of the page
  double _width = 500;
  double _height = 100;
  bool _isOpen = false;
  bool mapsLinkIsNonUsable = false;
  bool extraLinkIsNonUsable = false;
  String extraLinkNameToUse = "";
  String mapsLinksToUse = "";
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    extraLinkNameToUse = "\u2022${widget.advExtraLinkName}\n";
    if(widget.advMapsLink == 'null' || widget.advMapsLink == 'none'){
      mapsLinkIsNonUsable = true;
    }
    if(widget.advExtraLink == 'null' || widget.advExtraLink == 'none'){
      extraLinkIsNonUsable = true;
    }
    mapsLinksToUse = "\u2022 ניתוב למקום >\n";
  }

  /// Method to launch a url
  /// [url] - desired url to launch using the [launch] method
  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Cannot launch the url";
    }
  }

  /// Callback function for the user tap, the method is using [mounted]
  void onPressed() {
    if (this.mounted) {
      setState( () {
        if (_isOpen) {
          _height -= widget.advDetails.length +
              extraLinkNameToUse.length +
              mapsLinksToUse.length + widget.advName.length;
          // if(widget.adv_name.length > 18 && widget.adv_name.length < 25)
          //   _height -= widget.adv_name.length * 2;
          // else if(widget.adv_name.length <= 40 && widget.adv_name.length >= 25)
          //   _height -= widget.adv_name.length + 10;
          // else if(widget.adv_name.length > 40)
          //   _height -= widget.adv_name.length;

          _isOpen = false;
        } else {
          _height += widget.advDetails.length +
              extraLinkNameToUse.length +
              mapsLinksToUse.length + widget.advName.length;
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
                                      backgroundImage: NetworkImage(widget.advIcon),
                                      radius: 30.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: AutoSizeText(
                                      widget.advName,
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
                                  if (widget.advName.length > 25) TextButton(onPressed: ()=>{}, child: Icon(Icons.arrow_downward_rounded)),
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
                                                    widget.advDetails,
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
                                                    child: !extraLinkIsNonUsable ? RichText(
                                                        text: new TextSpan(
                                                            text: extraLinkNameToUse,
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
                                                                    .advExtraLink);
                                                              })):null
                                                  ),
                                                  Container(
                                                    transform: Matrix4.translationValues(0, -40, 0),
                                                    // height: double.parse(maps_links_to_use.length.toString()),
                                                    child: !mapsLinkIsNonUsable ? RichText(
                                                        text: new TextSpan(
                                                            text: mapsLinksToUse,
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
                                                                    .advMapsLink);
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

