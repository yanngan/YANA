import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:yana/UX/DB/users.dart';
import 'package:yana/UX/LOGIC/CLASSES/firebaseHelper.dart';
import 'AllPage.dart';

const String LOGIN_REGULAR = "REGULAR_USER";
const String LOGIN_DUMMY = "DUMMY_USER";
const String SIGN_UP = "SIGN_UP_NEW_USER";

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
    _checkIfIsLogged();
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
                  duration: Duration(seconds: 2),
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
                                  userCredentials(userInfo, LOGIN_REGULAR);
                                  setState(() {
                                    imageURL = _userData!["picture"]["data"]["url"].toString();
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
                                  dummyUserInfo["id"]                   =     "01234567891234567";
                                  dummyUserInfo["name"]                 =     "Adriana Lima";
                                  dummyUserInfo["email"]                =     "adrianalima@gmail.com";
                                  dummyUserInfo["gender"]               =     "female";
                                  dummyUserInfo["birthday"]             =     "12/06/1981";
                                  dummyUserInfo["age_range"]            =     "39";
                                  dummyUserInfo["hobbies"]              =     "Super Model, Actress";
                                  dummyUserInfo["bio"]                  =     "Most beautiful woman in the world!";
                                  dummyUserInfo["livingArea"]           =     "Salvador, Bahia, Brazil";
                                  dummyUserInfo["workArea"]             =     "New York, Los Angeles";
                                  dummyUserInfo["academicInstitution"]  =     "Creative Artists Agency";
                                  dummyUserInfo["fieldOfStudy"]         =     "Modeling";
                                  dummyUserInfo["smoking"]              =     "no";
                                  dummyUserInfo["picture_link"]         =     "https://upload.wikimedia.org/wikipedia/commons/8/8e/Adriana_Lima_2019_by_Glenn_Francis.jpg";
                                  dummyUserInfo["signUpDate"]           =     "20/09/2000";
                                  dummyUserInfo["isBlocked"]            =     "false";
                                  dummyUserInfo["notifications"]        =     "true";
                                  userCredentials(dummyUserInfo, LOGIN_DUMMY);
                                }
                            ),
                          ),
                        ), // Connect with Dummy user
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20, top: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(64),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: (alpha / 100).round().toDouble(),
                                  primary: Colors.green.withAlpha(alpha.toInt()), // background
                                  onPrimary: Colors.white.withAlpha(alpha.toInt()), // foreground
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Sign Up with Facebook', style: TextStyle(fontSize: 24)),
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
                                    userCredentials(userInfo, SIGN_UP);
                                    setState(() {
                                      imageURL = _userData!["picture"]["data"]["url"].toString();
                                    });
                                  }
                                }
                            ) ,
                          ),
                        ), // Signup
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
  void userCredentials(Map<String, String> credentials, String functionNeeded) async {
//    Text to display all the user info in the toast
//    String text = "Welcome to YANA\nYou are a ";
//    if(credentials["id"].toString() == "01234567891234567"){
//      text += " Dummy User";
//    }else{
//      text += " Human User";
//    }
//    text += "\nID: " + credentials["id"].toString();
//    text += "\nName: " + credentials["name"].toString();
//    text += "\nEmail: " + credentials["email"].toString();
//    text += "\nBirthday: " + credentials["birthday"].toString();
//    text += "\nGender: " + credentials["gender"].toString();
//    text += "\nAge Range: " + credentials["age_range"].toString();
//    text += "\nImage URL:\n" + credentials["picture_link"].toString();
    //    Check if user is in our database

    // TODO this commented section is for production, instead of the Test mode below
//    String userId = credentials["id"].toString();
//    bool exists = await FirebaseHelper.checkIfUserExists(userId);
//    exists = await FirebaseHelper.checkIfUserExists(userId).then((value) => exists = value);
//    while(true){
//      if(exists){
//        print("\n\n ********************************");
//        print("\n TRUE!!!!!!!!!!!!!!!! \n");
//        print("\n\n ********************************");
//        Fluttertoast.showToast(
//            msg: "Is the user exists?\n" + exists.toString(),
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.CENTER,
//            timeInSecForIosWeb: 1,
//            backgroundColor: Colors.red,
//            textColor: Colors.white,
//            fontSize: 16.0
//        );
//        break;
//      }else{
//        Fluttertoast.showToast(
//            msg: "Is the user exists?\n" + exists.toString(),
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.CENTER,
//            timeInSecForIosWeb: 1,
//            backgroundColor: Colors.red,
//            textColor: Colors.white,
//            fontSize: 16.0
//        );
//      }
//    }
////    User? newUser = await FirebaseHelper.getCurrentUser(userId);
//    User? newUser;
//    FirebaseHelper.getCurrentUser(userId).then((value) => newUser);
//    if(exists && newUser != null){
//      setState(() {
//        this.widget.callback(3, newUser.toMap());
//      });
//    }else{
//      setState(() {
//        this.widget.callback(1, credentials);
//      });
//    }
//    TODO --> Test mode, pre production - START
    switch (functionNeeded){
      case SIGN_UP:
        setState(() {
          this.widget.callback(1, credentials);
        });
        break;
      case LOGIN_REGULAR:
        Fluttertoast.showToast(
            msg: "Please long in with the dummy user\n\n\n\n\n\t\t\t\t\tOr Watch The World Burn!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        break;
      case LOGIN_DUMMY:
        setState(() {
          this.widget.callback(3, credentials);
        });
        break;
    }
//    TODO --> Test mode, pre production - END

  }

  Future<void> _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.accessToken;
    setState(() {
      _checking = false;
    });
    if (accessToken != null) {
       final userData = await FacebookAuth.instance.getUserData(fields: "name,email,picture.width(150),birthday,gender,age_range");
      _accessToken = accessToken;
      Map<String, String> loggedUserInfo = new Map<String, String>();
      loggedUserInfo["id"]              =     userData["id"];
      loggedUserInfo["name"]            =     userData["name"];
      loggedUserInfo["email"]           =     userData["email"];
      loggedUserInfo["birthday"]        =     userData["birthday"];
      loggedUserInfo["gender"]          =     userData["gender"];
      loggedUserInfo["age_range"]       =     userData["age_range"]["min"].toString();
      loggedUserInfo["picture_link"]    =     userData["picture"]["data"]["url"].toString();
      setState(() {
        _userData = userData;
        userCredentials(loggedUserInfo, LOGIN_REGULAR);
      });
    }
  }

  Future<bool> _onBackPressed() async {
    bool finalResult = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Exiting the app'),
        elevation: 24.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        content: new Text('You want to exit the app?'),
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




