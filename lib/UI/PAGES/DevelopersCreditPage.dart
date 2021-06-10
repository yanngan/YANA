import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Utilities.dart';

class DevelopersCreditPage extends StatefulWidget {

  @override
  _DevelopersCreditPageState createState() => _DevelopersCreditPageState();

}

class _DevelopersCreditPageState extends State<DevelopersCreditPage> {

  double avatarHeight = 50.0, _paddingVertically = 10.0, _paddingHorizontally = 20.0;
  double _maxTitleFontSize = 32.0;
  double _maxDescriptionFontSize = 17.0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("קרדיט למפתחים"),
          iconTheme: IconThemeData(
            color: Colors.amber, //change your color here
          ),
          backgroundColor: Colors.pink,
        ),
        backgroundColor: Colors.amber,
        body: Container(
          color: Colors.amber,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: _paddingVertically, horizontal: _paddingHorizontally),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[300]!.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: (){
                        launch(developersLinks["Lidor"].toString());
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: _paddingHorizontally, vertical: _paddingVertically),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CircleAvatar(
                                radius: avatarHeight,
                                backgroundImage: NetworkImage("https://media-exp1.licdn.com/dms/image/C4D35AQF2Fm_IZPiMFQ/profile-framedphoto-shrink_400_400/0/1601412285939?e=1623355200&v=beta&t=8y_8MMbQtIynS4v7UMb5bDzTxi67P5JHPp5V2beoMSk"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: AutoSizeText(
                                      developersInfo.keys.elementAt(0).toString(),
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 1000.0),
                                      maxFontSize: _maxTitleFontSize,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: AutoSizeText(
                                          developersInfo.values.elementAt(0).toString(),
                                          maxLines: 3,
                                          maxFontSize: _maxDescriptionFontSize,
                                          style: TextStyle(fontSize: 1000.0),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: new Container(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),  //  Item 1 - Lidor
                Padding(
                  padding: EdgeInsets.symmetric(vertical: _paddingVertically, horizontal: _paddingHorizontally),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[300]!.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: (){
                        launch(developersLinks["Yann"].toString());
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: _paddingHorizontally, vertical: _paddingVertically),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CircleAvatar(
                                radius: avatarHeight,
                                backgroundImage: NetworkImage("https://media-exp1.licdn.com/dms/image/C4E03AQE1mUt7Llp8-A/profile-displayphoto-shrink_400_400/0/1554136002729?e=1628726400&v=beta&t=VsAFs510yz_ONUlRCgqjsb0iWH4WFbJuKjGUquAwt6E"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: AutoSizeText(
                                      developersInfo.keys.elementAt(1).toString(),
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 1000.0),
                                      maxFontSize: _maxTitleFontSize,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: AutoSizeText(
                                          developersInfo.values.elementAt(1).toString(),
                                          maxLines: 3,
                                          style: TextStyle(fontSize: 1000.0),
                                          maxFontSize: _maxDescriptionFontSize,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: new Container(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),  //  Item 2 - Yann
                Padding(
                  padding: EdgeInsets.symmetric(vertical: _paddingVertically, horizontal: _paddingHorizontally),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[300]!.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: (){
                        launch(developersLinks["Yisrael"].toString());
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: _paddingHorizontally, vertical: _paddingVertically),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CircleAvatar(
                                radius: avatarHeight,
                                backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/54192901?v=4"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: AutoSizeText(
                                      developersInfo.keys.elementAt(2).toString(),
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 1000.0),
                                      maxFontSize: _maxTitleFontSize,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: AutoSizeText(
                                          developersInfo.values.elementAt(2).toString(),
                                          maxLines: 3,
                                          style: TextStyle(fontSize: 1000.0),
                                          maxFontSize: _maxDescriptionFontSize,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: new Container(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),  //  Item 3 - Yisrael
                Padding(
                  padding: EdgeInsets.symmetric(vertical: _paddingVertically, horizontal: _paddingHorizontally),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[300]!.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: (){
                        launch(developersLinks["Jonas"].toString());
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: _paddingHorizontally, vertical: _paddingVertically),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CircleAvatar(
                                radius: avatarHeight,
                                backgroundImage: NetworkImage("https://scontent.fsdv3-1.fna.fbcdn.net/v/t1.18169-1/p320x320/18620299_1450180998376011_5537896693663387130_n.jpg?_nc_cat=103&ccb=1-3&_nc_sid=7206a8&_nc_ohc=r-I5DZhztEQAX_-l6uF&_nc_ht=scontent.fsdv3-1.fna&tp=6&oh=7168f7e0bc6592a5411213c1a4cfe7b2&oe=60E597CC"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: AutoSizeText(
                                      developersInfo.keys.elementAt(3).toString(),
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 1000.0),
                                      maxFontSize: _maxTitleFontSize,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: AutoSizeText(
                                          developersInfo.values.elementAt(3).toString(),
                                          maxLines: 3,
                                          style: TextStyle(fontSize: 1000.0),
                                          maxFontSize: _maxDescriptionFontSize,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: new Container(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),  //  Item 4 - Jonas
              ],
            ),
          ),
        ),
      ),
    );
  }

}




















