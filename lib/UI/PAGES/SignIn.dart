import 'package:flutter/material.dart';
import 'package:yana/UI/main.dart';
import 'AllPage.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber,
        child: Center(child: Text("Sing In")),
      ),
    );
  }

}
