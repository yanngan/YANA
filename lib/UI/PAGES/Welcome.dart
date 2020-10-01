import 'package:flutter/material.dart';
import 'AllPage.dart';

class Welcome extends StatefulWidget {

  final Function callback;
  const Welcome(this.callback);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.amberAccent,
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
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
                      ),
                    ],
                  ),
                ), // Logo + Welcome Text
                SizedBox(height: 120,), // Spacing
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: RaisedButton(
                    color:Colors.pink,
                    onPressed: () {
                      this.widget.callback(1);
                    },
                    textColor: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Sign In', style: TextStyle(fontSize: 30)),
                    ),
                  ),
                ), // Sign In btn
                SizedBox(height: 20,), // Spacing
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: RaisedButton(
                    color:Colors.pink,
                    onPressed: () {
                      setState(() {
                        this.widget.callback(2);
                      });
                    },
                    textColor: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Login', style: TextStyle(fontSize: 30)),
                    ),
                  ),
                ), // Login btn
                SizedBox(height: 80,), // Spacing
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: RaisedButton(
                    padding: const EdgeInsets.all(10.0),
                    color:Colors.pink,
                    onPressed: () {
                      setState(() {
                        this.widget.callback(3);
                      });
                    },
                    textColor: Colors.white,
                    child: Container(
                      child: Text(
                          'Test\nCurrent-MainAppInside',
                          style: TextStyle(fontSize: 20,),
                          textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ), // Test btn
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure'),
        content: new Text('you want to exit the app?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??false;
  }

}
