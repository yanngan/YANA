import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(
          child: RaisedButton(
            child: Text('Login from here!'),
            onPressed: () async {
              final FacebookLoginResult result =
              await facebookSignIn.logIn(['email']);
              switch (result.status) {
                case FacebookLoginStatus.loggedIn:
                  final FacebookAccessToken accessToken = result.accessToken;
                  print('''
                     Logged in!
                     Token: ${accessToken.token}
                     User id: ${accessToken.userId}
                     Expires: ${accessToken.expires}
                     Permissions: ${accessToken.permissions}
                     Declined permissions: ${accessToken.declinedPermissions}
                     ''');
                  break;
                case FacebookLoginStatus.cancelledByUser:
                  print('Login cancelled by the user.');
                  break;
                case FacebookLoginStatus.error:
                  Fluttertoast.showToast(
                      msg: 'Something went wrong with the login process. \n'
                          'Here\'s the error Facebook gave us : ${result
                          .errorMessage}',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  print('Something went wrong with the login process.\n'
                      'Here\'s the error Facebook gave us: ${result
                      .errorMessage}');
                  break;
              }
            }
        ),
      )
    );
  }
}




