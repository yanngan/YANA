// Libraries
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// Inside stuff
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 50),
        child: AppBar(
          backgroundColor: Colors.amber,
          elevation: 0,
        ),
      ),
      body: Container(
        color: Colors.amber,
        child: Center(
            child: isOver18 ? signIn() : checkAge()
        ),
      ),
    );
  }

  Widget checkAge(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Are you over 18 years old?", style: TextStyle(fontSize: 20),),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
              onPressed: (){
                setState(() {
                  isOver18 = true;
                });
              },
              color: Colors.transparent,
              icon: Icon(Icons.thumb_up),
              label: Text("Yes"),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black),
              ),
            ), // Yes I'm Over 18
            SizedBox(width: 10,),
            RaisedButton.icon(
              onPressed: (){
                Fluttertoast.showToast(
                    msg: "We are sorry,\nbut you must be over 18 in order to use this application",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.amberAccent,
                    textColor: Colors.black54,
                    fontSize: 16.0
                );
                SystemNavigator.pop();
              },
              color: Colors.transparent,
              icon: Icon(Icons.thumb_down),
              label: Text("No"),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black),
              ), // No I'm Under 18
            ),
          ],
        ),
      ],
    );
  }

  Widget signIn(){
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Create your $appName user!',
            style: TextStyle(
              fontSize: 30,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(3.5, 6.0),
                  blurRadius: 5.0,
                  color: Color.fromARGB(200, 0, 0, 0),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Label"),
                  Text("Input"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Label"),
                  Text("Input"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

}























