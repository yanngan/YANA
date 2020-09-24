import 'package:flutter/material.dart';
import 'AllPage.dart';


class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: (MediaQuery.of(context).size.height / 10),
              ), // Top Spacing
              Image(
                image: AssetImage(
                  'assets/yana_logo.png'
                )
              ), // Logo
              SizedBox(
                height: (MediaQuery.of(context).size.height / 40),
              ), // Spacing
              Text(
                '$appName',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ), // App Name
              SizedBox(
                height: (MediaQuery.of(context).size.height / 60),
              ), // Spacing
              Text(
                'You Are Not Alone',
                style: TextStyle(fontSize: 15, fontFamily: "Skia"),
              ), // Welcome Text
            ],
          ),
        ),
      ),
    );
  }
}
