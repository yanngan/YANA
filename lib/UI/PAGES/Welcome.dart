import 'package:flutter/cupertino.dart';
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
                        height: (MediaQuery.of(context).size.height / 20),
                      ), // Top Spacing
                      Image(
                        height: (MediaQuery.of(context).size.height / 3),
                        image: AssetImage(
                          'assets/yana_logo.png'
                        )
                      ), // Logo
                      Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 10),
                        child: Text(
                          '$appName',
                          style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                        ),
                      ), // App Name
                      Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 3.5),
                        child: Text(
                          'You Are Not Alone',
                          style: TextStyle(fontSize: 30, fontFamily: "Skia"),
                        ),
                      ),
                    ],
                  ),
                ), // Logo + Welcome Text
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(64),
                    child: RaisedButton(
                      color: Color(0xFF3752A8),
                      onPressed: () {
                        setState(() {
                          this.widget.callback(2);
                        });
                      },
                      textColor: Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Connect with Facebook', style: TextStyle(fontSize: 25)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                                  child: Image(
                                      height: 50,
                                      width: 50,
                                      image: AssetImage(
                                          'assets/facebook_logo.png'
                                      )
                                  ),
                                ),
                              ],
                            ),
                              Padding(
                                padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 10),
                                child: Text('Do Not Enter Here Yet!',
                                    style: TextStyle(
                                      fontSize: 40,
                                      decoration: TextDecoration.underline,
                                      decorationStyle: TextDecorationStyle.double,
                                      decorationThickness: 2,
                                      decorationColor: Colors.redAccent
                                    )
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ), // Login btn
                SizedBox(height: 20,), // Spacing
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
                          'Tester Button\nEnter without sign up',
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





