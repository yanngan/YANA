import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'AllPage.dart';

class Login extends StatefulWidget {

//  Callback function related - See main.dart callback section for more info about it
  final Function callback;
  const Login(this.callback);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

//  Variables:
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;
  String imageURL = "";
//  All the elements sizes (without the facebook button size)
  var topSpace = 0.0, imageSize = 0.0, fontSizeBig = 0.0, fontSizeSmall = 0.0, fullSize = 0.0;

  @override
  void initState() {
    super.initState();
    topSpace = 45;
    imageSize = 275;
    fontSizeBig = 45;
    fontSizeSmall = 30;
    fullSize = (topSpace * 1.35) + imageSize;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        color: Colors.amber,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10, bottom: 0, right: 0, left: 0),
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
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
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 12.5),
                      child: Text(
                        '$appName',
                        style: TextStyle(
                          fontSize: fontSizeBig,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Skia",
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ), // App Name
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 3.5),
                      child: Text(
                        'You Are Not Alone',
                        style: TextStyle(
                          fontSize: fontSizeSmall,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Skia",
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    )
                  ],
                ),
              ), // Welcome Text
              TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 255),
                  duration: Duration(seconds: 4),
                  curve: Curves.easeInExpo,
                  builder: (BuildContext _, double alpha, Widget? __) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20, top: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(64),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: (alpha / 100).round().toDouble(),
                                primary: Colors.blue.withAlpha(alpha.toInt()), // background
                                onPrimary: Colors.white.withAlpha(alpha.toInt()), // foreground
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Connect with Facebook', style: TextStyle(fontSize: 24)),
                                  Image(
                                    color: Colors.white.withAlpha(alpha.toInt()),
                                    height: 50,
                                    width: 50,
                                    image: AssetImage(
                                        'assets/facebook_logo.png'
                                    )
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                List<String> permissionsWanted = const ['email', 'public_profile', 'user_birthday', 'user_gender', 'user_age_range'];
                                final LoginResult result = await FacebookAuth.instance.login(permissions: permissionsWanted); // by the fault we request the email and the public profile
                                if(result.status == LoginStatus.success) {
                                  // In this if statement the user is logged in!
                                  _accessToken =  result.accessToken!;
                                  _userData = await FacebookAuth.instance.getUserData(fields: "name,email,picture.width(150),birthday,gender,age_range",);
                                  Map<String, String> userInfo = new Map<String, String>();
                                  userInfo["id"]              =     _userData!["id"];
                                  userInfo["name"]            =     _userData!["name"];
                                  userInfo["email"]           =     _userData!["email"];
                                  userInfo["birthday"]        =     _userData!["birthday"];
                                  userInfo["gender"]          =     _userData!["gender"];
                                  userInfo["age_range"]       =     _userData!["age_range"]["min"].toString();
                                  userInfo["picture_link"]    =     _userData!["picture"]["data"]["url"].toString();
                                  userCredentials(userInfo);
                                  setState(() {
                                    imageURL = _userData!["picture"]["data"]["url"].toString();
//                          this.widget.callback(3);
                                  });
                                }
                              }
                          ) ,
                          ),
                        ), // Connect with Facebook
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20, top: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(64),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: (alpha / 100).round().toDouble(),
                                  primary: Colors.red.withAlpha(alpha.toInt()), // background
                                  onPrimary: Colors.white.withAlpha(alpha.toInt()), // foreground
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Enter with Dummy user', style: TextStyle(fontSize: 24, color: Colors.black.withAlpha(alpha.toInt()))),
                                    Image(
                                        color: Colors.black.withAlpha(alpha.toInt()),
                                        height: 50,
                                        width: 50,
                                        image: AssetImage(
                                            'assets/facebook_logo.png'
                                        )
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Map<String, String> dummyUserInfo = new Map<String, String>();
                                  dummyUserInfo["id"]              =     "01234567891234567";
                                  dummyUserInfo["name"]            =     "Adriana Lima";
                                  dummyUserInfo["email"]           =     "adrianalima@gmail.com";
                                  dummyUserInfo["birthday"]        =     "12/06/1981";
                                  dummyUserInfo["gender"]          =     "female";
                                  dummyUserInfo["age_range"]       =     "31";
                                  dummyUserInfo["picture_link"]    =     "https://upload.wikimedia.org/wikipedia/commons/8/8e/Adriana_Lima_2019_by_Glenn_Francis.jpg";
                                  userCredentials(dummyUserInfo);
                                  setState(() {
                                    this.widget.callback(3);
                                  });
                                }
                            ),
                          ),
                        ), // Connect with Dummy user
                      ],
                    );
                  }
              ),
//              Image.network(imageURL), // Temp Profile Image
            ],
          ),
        )
      ),
    );
  }

/*
 * Function that checks the user credentials against our data base in order
 * to determine if the user is new / existing / blocked.
 */
  void userCredentials(Map<String, String> credentials){
//    Text to display all the user info in the toast
    String text = "Welcome to YANA\nYou are a ";
    // TODO remove next if/else before production
    if(credentials["id"].toString() == "01234567891234567"){
      text += " Dummy User";
    }else{
      text += " Human User";
    }
    text += "\nID: " + credentials["id"].toString();
    text += "\nName: " + credentials["name"].toString();
    text += "\nEmail: " + credentials["email"].toString();
    text += "\nBirthday: " + credentials["birthday"].toString();
    text += "\nGender: " + credentials["gender"].toString();
    text += "\nAge Range: " + credentials["age_range"].toString();
    text += "\nImage URL:\n" + credentials["picture_link"].toString();
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
//    Check if user is in our database

//    If user in it, log him in

//    If user is'nt in it, go to signup ponces
  }

  Future<bool> _onBackPressed() async {
    bool finalResult = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure'),
        content: new Text('you want to exit the app?'),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("No"),
          ),
          SizedBox(height: 16),
          new TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
    return finalResult;
  }

}




