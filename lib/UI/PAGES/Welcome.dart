import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Utilities.dart';

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
    imageSize = 275;
    fontSizeBig = 45;
    fontSizeSmall = 30;
    fullSize = (topSpace * 1.35) + imageSize;

//    In order to make this screen visible for only 7 seconds and then go to an identical screen with extra options
    Future.delayed(Duration(seconds: 2)).then((value) => {
      checkInternetConnection(),
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, right: 0, left: 0, bottom: 10),
            child: Stack(
              children: [
//              Logo Animation
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: (MediaQuery.of(context).size.height / 3), end: 10),
                  duration: Duration(seconds: 1),
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
                  duration: Duration(milliseconds: 1500),
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
      ),
    );
  }

  void checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool internet = false, firstDialog = true, isOpen = false;
    while(!internet){
      if (connectivityResult == ConnectivityResult.mobile) {        //  Connected to mobile network
        internet = true;
      }else if (connectivityResult == ConnectivityResult.wifi) {    //  Connected to wifi network
        internet = true;
      }else{                                                        //  Not Connected
        if(firstDialog){
          firstDialog = false;
          isOpen = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: Text("לא נמצא חיבור אינטרנטי!"),
              elevation: 24.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("צריך להיות חיבור אינטרנטי יציב על מנת להשתמש באפליקצייה."),
                  TextButton(
                    child: Text("יש אינטרנט עכשיו"),
                    onPressed: () {
                      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi ){
                        internet = true;
                        Navigator.of(context).pop();
                        setState(() {
                          this.widget.callback(2);
                        });
                      }else{
                        Fluttertoast.showToast(
                            msg: "נא לוודא כי קיים גישה לרשת אינטרנטית כולשהי.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.blueGrey,
                            textColor: Colors.redAccent,
                            fontSize: 16.0
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          );
        }
      }
      connectivityResult = await (Connectivity().checkConnectivity());
    }
    if(internet && !isOpen){
      setState(() {
        this.widget.callback(2, new Map<String, String>(), new Map<String, String>(), Welcome_index);
      });
    }
  }

  Future<bool> _onBackPressed() async {
    bool finalResult = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('יציאה מהאפליקצייה'),
        elevation: 24.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        content: new Text('האם לצאת מהאפליקצייה?'),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("לא"),
          ),
          SizedBox(height: 16),
          new TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("כן"),
          ),
        ],
      ),
    );
    return finalResult;
  }

}





