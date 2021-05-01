import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'AllPage.dart';

class Welcome extends StatefulWidget {

//  Callback function related - See main.dart callback section for more info about it
  final Function callback;
  const Welcome(this.callback);

  @override
  _WelcomeState createState() => _WelcomeState();

}

class _WelcomeState extends State<Welcome> {

//  Variables:
//  All the elements sizes
  var topSpace = 0.0, imageSize = 0.0, fontSizeBig = 0.0, fontSizeSmall = 0.0, fullSize = 0.0;

  @override
  void initState() {
    super.initState();
    topSpace = 35;
    imageSize = 300;
    fontSizeBig = 45;
    fontSizeSmall = 30;
    fullSize = (topSpace * 1.35) + imageSize;

//    In order to make this screen visible for only 7 seconds and then go to an identical screen with extra options
    Future.delayed(Duration(seconds: 5)).then((value) => {
      setState(() {
        this.widget.callback(2);
      })
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 0, left: 0, bottom: 10),
          child: Stack(
            children: [
//              Logo Animation
              TweenAnimationBuilder(
                tween: Tween<double>(begin: (MediaQuery.of(context).size.height / 3), end: 10),
                duration: Duration(seconds: 2),
                curve: Curves.easeInOut,
                builder: (BuildContext _, double marginTop, Widget? __) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: marginTop, bottom: 0, right: 0, left: 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              SizedBox(   // In order to make sure the logo will not appear on top of the status bar
                                height: topSpace,
                              ), // Top Spacing
                              Image(
                                  height: imageSize,
                                  image: AssetImage(
                                      'assets/yana_logo.png'
                                  )
                              ), // Logo
                            ],
                          ),
                        ), // Logo
                      ],
                    ),
                  );
                }
              ),
//              Texts Animation
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 255),
                duration: Duration(seconds: 4),
                curve: Curves.easeInExpo,
                builder: (BuildContext _, double alpha, Widget? __) {
                  return Padding(
                    padding: EdgeInsets.only(top: fullSize, right: 0, left: 0, bottom: 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 10),
                            child: Text(
                              '$appName',
                              style: TextStyle(
                                  fontSize: fontSizeBig,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Skia",
                                  color: Colors.black.withAlpha(alpha.toInt())
                              ),
                            ),
                          ), // App Name
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 3.5),
                            child: Text(
                              'You Are Not Alone',
                              style: TextStyle(
                                  fontSize: fontSizeSmall,
                                  fontFamily: "Skia",
                                  color: Colors.black.withAlpha(alpha.toInt())
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ); // Welcome Text
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}





