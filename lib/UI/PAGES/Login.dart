import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Login extends StatefulWidget {

  final Function callback;
  const Login(this.callback);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;
  String imageURL = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        color: Colors.amber,
        child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20, top: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(64),
                    child: ElevatedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Connect with Facebook', style: TextStyle(fontSize: 24)),
                          Image(
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
                          _userData = await FacebookAuth.instance.getUserData(fields: "name,email,picture.width(250),birthday,gender,age_range",);
                          print("\n******************************************userData******************************************\n");
                          print(_userData);
                          Map<String, String> userInfo = new Map<String, String>();
                          userInfo["id"]              =     _userData!["id"];
                          userInfo["name"]            =     _userData!["name"];
                          userInfo["email"]           =     _userData!["email"];
                          userInfo["birthday"]        =     _userData!["birthday"];
                          userInfo["gender"]          =     _userData!["gender"];
                          userInfo["age_range"]       =     _userData!["age_range"]["min"].toString();
                          userInfo["picture_link"]    =     _userData!["picture"]["data"]["url"].toString();
                          String text = "Welcome to YANA\n";
                          text += "\nID: " + userInfo["id"].toString();
                          text += "\nName: " + userInfo["name"].toString();
                          text += "\nEmail: " + userInfo["email"].toString();
                          text += "\nBirthday: " + userInfo["birthday"].toString();
                          text += "\nGender: " + userInfo["gender"].toString();
                          text += "\nAge Range: " + userInfo["age_range"].toString();
                          text += "\nImage URL:\n" + userInfo["picture_link"].toString();
                          Fluttertoast.showToast(
                              msg: text,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                          print("\n" + userInfo.toString() + "\n");
                          print("\n******************************************userData******************************************\n");
                          setState(() {
                            imageURL = _userData!["picture"]["data"]["url"].toString();
//                          this.widget.callback(3);
                          });
                        }
                      }
                    ),
                  ),
                ), // Connect with Facebook
                Image.network(imageURL), // Temp Profile Image
              ],
            ),
        )
      ),
    );
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
              Fluttertoast.showToast(
                  msg: "NO POP",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            },
            child: Text("No"),
          ),
          SizedBox(height: 16),
          new TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Fluttertoast.showToast(
                  msg: "YEAH POP",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
    return finalResult;
  }


}




