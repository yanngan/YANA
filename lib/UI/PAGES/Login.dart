import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yana/UX/DB/users.dart';
import 'package:yana/UX/LOGIC/CLASSES/firebaseHelper.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'Utilities.dart';

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
  bool unknownUser = true;
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
    checkUserFacebook();
  }

  void checkUserFacebook() async {
    await Future.wait([
      _checkIfIsLogged(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Directionality(
        textDirection: TextDirection.rtl,
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
                  FutureBuilder(
                    future: _checkIfIsLogged(),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done){
                        if(snapshot.hasError){ /* Some error happened, check it! */ }
                        return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 255),
                            duration: Duration(milliseconds: 1150),
                            curve: Curves.easeInExpo,
                            builder: (BuildContext _, double alpha, Widget? __) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 10),
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
                                              Text('התחבר עם פייסבוק', style: TextStyle(fontSize: 24)),
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
                                              userInfo["userID"]          =     _userData!["id"]; /// Need to be 'id' and not 'userID'
                                              userInfo["name"]            =     _userData!["name"];
                                              userInfo["email"]           =     _userData!["email"];
                                              userInfo["birthday"]        =     _userData!["birthday"];
                                              userInfo["gender"]          =     _userData!["gender"];
                                              userInfo["age_range"]       =     _userData!["age_range"]["min"].toString();
                                              userInfo["fbPhoto"]         =     _userData!["picture"]["data"]["url"].toString();
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
                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(64),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: (alpha / 100).round().toDouble(),
                                            primary: Colors.red.withAlpha(alpha.toInt()), // background
                                            onPrimary: Colors.white.withAlpha(alpha.toInt()), // foreground
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  height: 150,
                                                  child: Image.network(
                                                      "https://scontent.fsdv3-1.fna.fbcdn.net/v/t1.18169-1/p320x320/18620299_1450180998376011_5537896693663387130_n.jpg?_nc_cat=103&ccb=1-3&_nc_sid=7206a8&_nc_ohc=1U-UN1EWuE0AX9PeIRM&_nc_ht=scontent.fsdv3-1.fna&tp=6&oh=12d9bbfd2c3b0a40b8089804b7c806b6&oe=60E597CC"
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 80.0),
                                                child: Text("משתמש לכבוד ג'ונאס", style: TextStyle(fontSize: 28, color: Colors.lightBlueAccent, fontWeight: FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                          onPressed: () { // TODO getCurrentUser(String userID)
                                            Map<String, String> dummyUserInfo = new Map<String, String>();
                                            dummyUserInfo["userID"]               =     "01234567891234567";
                                            dummyUserInfo["name"]                 =     "Adriana Lima";
                                            dummyUserInfo["email"]                =     "adrianalima@gmail.com";
                                            dummyUserInfo["gender"]               =     "female";
                                            dummyUserInfo["birthday"]             =     "12/06/1996";
                                            dummyUserInfo["age_range"]            =     "39";
                                            dummyUserInfo["hobbies"]              =     "Super Model, Actress";
                                            dummyUserInfo["bio"]                  =     "Most beautiful woman in the world!";
                                            dummyUserInfo["livingArea"]           =     "Salvador, Bahia, Brazil";
                                            dummyUserInfo["workArea"]             =     "New York, Los Angeles";
                                            dummyUserInfo["academicInstitution"]  =     "Creative Artists Agency";
                                            dummyUserInfo["fieldOfStudy"]         =     "Modeling";
                                            dummyUserInfo["smoking"]              =     "no baby";
                                            dummyUserInfo["fbPhoto"]              =     "https://upload.wikimedia.org/wikipedia/commons/8/8e/Adriana_Lima_2019_by_Glenn_Francis.jpg";
                                            dummyUserInfo["signUpDate"]           =     "20/09/2000";
                                            dummyUserInfo["isBlocked"]            =     "false";
                                            dummyUserInfo["notifications"]        =     "true";
                                            userCredentials(dummyUserInfo, LOGIN_DUMMY);
                                          }
                                      ),
                                    ),
                                  ), /// Connect with Dummy user
//                          Padding(
//                            padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 10),
//                            child: ClipRRect(
//                              borderRadius: BorderRadius.circular(64),
//                              child: ElevatedButton(
//                                  style: ElevatedButton.styleFrom(
//                                    elevation: (alpha / 100).round().toDouble(),
//                                    primary: Colors.green.withAlpha(alpha.toInt()), // background
//                                    onPrimary: Colors.white.withAlpha(alpha.toInt()), // foreground
//                                  ),
//                                  child: Row(
//                                    mainAxisSize: MainAxisSize.min,
//                                    children: [
//                                      Text('הרשמה עם פייסבוק', style: TextStyle(fontSize: 24)),
//                                      Image(
//                                          color: Colors.white.withAlpha(alpha.toInt()),
//                                          height: 50,
//                                          width: 50,
//                                          image: AssetImage(
//                                              'assets/facebook_logo.png'
//                                          )
//                                      ),
//                                    ],
//                                  ),
//                                  onPressed: () async {
//                                    List<String> permissionsWanted = const ['email', 'public_profile', 'user_birthday', 'user_gender', 'user_age_range'];
//                                    final LoginResult result = await FacebookAuth.instance.login(permissions: permissionsWanted); // by the fault we request the email and the public profile
//                                    if(result.status == LoginStatus.success) {
//                                      // In this if statement the user is logged in!
//                                      _accessToken =  result.accessToken!;
//                                      _userData = await FacebookAuth.instance.getUserData(fields: "name,email,picture.width(150),birthday,gender,age_range",);
//                                      Map<String, String> userInfo = new Map<String, String>();
//                                      userInfo["userID"]          =     _userData!["id"];
//                                      userInfo["name"]            =     _userData!["name"];
//                                      userInfo["email"]           =     _userData!["email"];
//                                      userInfo["birthday"]        =     _userData!["birthday"];
//                                      userInfo["gender"]          =     _userData!["gender"];
//                                      userInfo["age_range"]       =     _userData!["age_range"]["min"].toString();
//                                      userInfo["fbPhoto"]         =     _userData!["picture"]["data"]["url"].toString();
//                                      userCredentials(userInfo, SIGN_UP);
//                                      setState(() {
//                                        imageURL = _userData!["picture"]["data"]["url"].toString();
//                                      });
//                                    }
//                                  }
//                              ) ,
//                            ),
//                          ), // Signup
                                ],
                              );
                            }
                        );
                      }
                      return CircularProgressIndicator();   // TODO don't remove without consulting Lidor, it's for debugging
                    },
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

/*
 * Function that checks the user credentials against our data base in order
 * to determine if the user is new / existing / blocked.
 */
  void userCredentials(Map<String, String> credentials, String functionNeeded) async {
    //    Check if user is in our database
    String userId = credentials["userID"].toString();
    if(functionNeeded == LOGIN_DUMMY){
      userId = '01234567891234567';   // Test ID of Adriana Lima
    }
    bool exists = false;
    User newUser = new User.isNULL('null');
    await Future.wait([
      FirebaseHelper.checkIfUserExists(userId).then((value) => exists = value),
      FirebaseHelper.getCurrentUser(userId).then((value) {
        if(value != null){
          newUser = value;
        }
      }),
    ]);
    if(exists){
      setState(() {
        userMap = newUser.toMap();
        Logic.saveMyRegistrationToken();
        this.widget.callback(3, newUser.toMap(), otherInfo, MapView_index);
      });
    }else{
      setState(() {
        newUser = new User.fromMap(credentials);
        Logic.saveMyRegistrationToken();
        this.widget.callback(1, credentials, otherInfo, MapView_index);
      });
    }

//    TODO --> Test mode, pre production - START
//    switch (functionNeeded){
//      case SIGN_UP:
//        setState(() {
//          this.widget.callback(1, credentials, new Map<String, String>(), SingUp_index);
//        });
//        break;
//      case LOGIN_REGULAR:
//      case LOGIN_DUMMY:
//        if(functionNeeded == LOGIN_REGULAR){
//          Fluttertoast.showToast(
//              msg: "אנא התחבר עם משתמש דמה!\n\n\n\n\n\t\t\t\t\tאו צפה בעולם נשרף!!",
//              toastLength: Toast.LENGTH_SHORT,
//              gravity: ToastGravity.CENTER,
//              timeInSecForIosWeb: 1,
//              backgroundColor: Colors.red,
//              textColor: Colors.black54,
//              fontSize: 16.0
//          );
//        }
//        setState(() {
//          userMap = credentials;
//          getPreference();
//          this.widget.callback(3, credentials, new Map<String, String>(), MapView_index);
//        });
//        break;
//    }
//    TODO --> Test mode, pre production - END

  }

  void getPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    defaultMapType = (prefs.getBool(MAP_TYPE_KEY) ?? false);
    whichPage = (prefs.getBool(CHATS_EVENTS_TYPE_KEY) ?? false);
  }

  Future<void> _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      final userData = await FacebookAuth.instance.getUserData(fields: "name,email,picture.width(150),birthday,gender,age_range");
      _accessToken = accessToken;
      Map<String, String> loggedUserInfo = new Map<String, String>();
      loggedUserInfo["userID"]          =     userData["id"]; /// Need to be 'id' and not 'userID'
      loggedUserInfo["name"]            =     userData["name"];
      loggedUserInfo["email"]           =     userData["email"];
      loggedUserInfo["birthday"]        =     userData["birthday"];
      loggedUserInfo["gender"]          =     userData["gender"];
      loggedUserInfo["age_range"]       =     userData["age_range"]["min"].toString();
      loggedUserInfo["fbPhoto"]         =     userData["picture"]["data"]["url"].toString();

      bool exists = false;
      await Future.wait([
        FirebaseHelper.checkIfUserExists(loggedUserInfo["userID"].toString()).then((value) => exists = value),
      ]);
      setState(() {
        _userData = userData;
        if(exists){
          userCredentials(loggedUserInfo, LOGIN_REGULAR);
        }
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



