// Libraries
import 'dart:async';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
// Inside stuff
import 'package:yana/UI/WIDGETS/allWidgets.dart';
import 'AllPage.dart';

String fullName = "", sex = "", hobbies = "", bio = "";
String livingArea = "", workArea = "", academicInstitution = "", fieldOfStudy = "";
String smoking = "";
var btnColor = Colors.blue;

class SignIn extends StatefulWidget {

//  Callback function related - See main.dart callback section for more info about it
  final Function callback;
  const SignIn(this.callback);

  @override
  _SignInState createState() => _SignInState();

}

class _SignInState extends State<SignIn> {

  static const int duration = 700; // 700
  static double _widthPageView = 350, _heightPageView = 600;
  double heightDivider = 1.4, widthDivider = 1.15;
  int page = 0;
  LiquidController _liquidController = LiquidController();
  bool? _checked_1 = false, _checked_2 = false, _checked_3 = false, _checked_4 = false, _checked_5 = false;

  /*
   * Backgrounds colors for the pages:
   * Page 1:  Colors.blue
   * Page 2:  Colors.deepPurpleAccent
   * Page 3:  Colors.teal
   * Page 4:  Colors.deepOrangeAccent
   */
  List<Widget> pages = [];

  // First Page Controllers
  TextEditingController _controllerFullName = new TextEditingController(text: fullName);
  TextEditingController _controllerSex = new TextEditingController(text: sex);
  TextEditingController _controllerHobbies = new TextEditingController(text: hobbies);
  TextEditingController _controllerBio = new TextEditingController(text: bio);
  // Second Page Controllers
  TextEditingController _controllerLivingArea = new TextEditingController(text: livingArea);
  TextEditingController _controllerWorkArea = new TextEditingController(text: workArea);
  TextEditingController _controllerAcademicInstitution = new TextEditingController(text: academicInstitution);
  TextEditingController _controllerFieldOfStudy = new TextEditingController(text: fieldOfStudy);
  // Third Page Controllers
  TextEditingController _controllerSmoking = new TextEditingController(text: smoking);

  @override
  void initState() {
    super.initState();
    _liquidController =   LiquidController();
    // First Page Controllers
    _controllerFullName = new TextEditingController(text: fullName);
    _controllerSex = new TextEditingController(text: sex);
    _controllerHobbies = new TextEditingController(text: hobbies);
    _controllerBio = new TextEditingController(text: bio);
    // Second Page Controllers
    _controllerLivingArea = new TextEditingController(text: livingArea);
    _controllerWorkArea = new TextEditingController(text: workArea);
    _controllerAcademicInstitution = new TextEditingController(text: academicInstitution);
    _controllerFieldOfStudy = new TextEditingController(text: fieldOfStudy);
    // Third Page Controllers
    _controllerSmoking = new TextEditingController(text: smoking);
  }

  @override
  void dispose() {
    super.dispose();
    _controllerFullName.dispose();
    _controllerSex.dispose();
    _controllerHobbies.dispose();
    _controllerBio.dispose();
    _controllerLivingArea.dispose();
    _controllerWorkArea.dispose();
    _controllerAcademicInstitution.dispose();
    _controllerFieldOfStudy.dispose();
    _controllerSmoking.dispose();
  }

  final streamController = StreamController<bool>.broadcast();
  var change = false;
  var clr = Colors.red, btnText = "Submit", _duration = 1500;
  double containerW = 300, containerH = 75;

  @override
  Widget build(BuildContext context) {
    _widthPageView = MediaQuery.of(context).size.width / widthDivider;
    _heightPageView = MediaQuery.of(context).size.height / heightDivider;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 110,),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.0),
                        child: Container(
                          height: _heightPageView,
                          width: _widthPageView,
//                          child: testBuild(),
                          child: signUp(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: 110,
                child: MyAppBar("Sign Up", null, height: 110,)
            ), // Appbar
          ],
        ),
      ),
    );
  }


//  Widget checkAge(){
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        Text("Are you over 18 years old?", style: TextStyle(fontSize: 20),),
//        SizedBox(height: 20,),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            RaisedButton.icon(
//              onPressed: (){
//                setState(() {
//                  isOver18 = true;
//                });
//              },
//              color: Colors.transparent,
//              icon: Icon(Icons.thumb_up),
//              label: Text("Yes"),
//              shape: RoundedRectangleBorder(
//                borderRadius: new BorderRadius.circular(18.0),
//                side: BorderSide(color: Colors.black),
//              ),
//            ), // Yes I'm Over 18
//            SizedBox(width: 10,),
//            RaisedButton.icon(
//              onPressed: (){
//                Fluttertoast.showToast(
//                    msg: "We are sorry,\nbut you must be over 18 in order to use this application",
//                    toastLength: Toast.LENGTH_LONG,
//                    gravity: ToastGravity.CENTER,
//                    timeInSecForIosWeb: 1,
//                    backgroundColor: Colors.amberAccent,
//                    textColor: Colors.black54,
//                    fontSize: 16.0
//                );
//                SystemNavigator.pop();
//              },
//              color: Colors.transparent,
//              icon: Icon(Icons.thumb_down),
//              label: Text("No"),
//              shape: RoundedRectangleBorder(
//                borderRadius: new BorderRadius.circular(18.0),
//                side: BorderSide(color: Colors.black),
//              ), // No I'm Under 18
//            ),
//          ],
//        ),
//      ],
//    );
//  }

  Widget testBuild(){
    return Container(
      color: Colors.deepOrangeAccent,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 15),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset("assets/yana_logo.png",),
                    ),
                  ),
                  SizedBox(
                    width: _widthPageView - 150,
                    child: AutoSizeText(
                      'Create your $appName user!',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 30,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2, 3),
                            blurRadius: 6,
                            color: Color.fromARGB(200, 0, 0, 0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ), // Logo + Title
            Column(
              children: <Widget>[
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image(
                          height: 75,
                          image: AssetImage(
                              'assets/outer_1.png'
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10, right: 20, bottom: 0),
                      child: CheckboxListTile(
                        title: Text("I'm over 18 years old."),
                        secondary: Icon(Icons.accessibility_new),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _checked_1,
                        onChanged: (bool? val) {
                          setState(() {
                            _checked_1 = val;
                            timeDilation = val! ? 4.0 : 2.75;
                          });
                        },
//                  activeColor: Colors.green,
//                  checkColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image(
                          height: 75,
                          image: AssetImage(
                              'assets/outer_1.png'
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10, right: 20, bottom: 0),
                      child: CheckboxListTile(
                        title: Text("I agree to the term of use."),
                        secondary: Icon(Icons.miscellaneous_services),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _checked_2,
                        onChanged: (bool? val) {
                          setState(() {
                            _checked_2 = val;
                            timeDilation = val! ? 4.0 : 2.75;
                          });
                        },
//                  activeColor: Colors.green,
//                  checkColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image(
                          height: 75,
                          image: AssetImage(
                              'assets/outer_1.png'
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10, right: 20, bottom: 0),
                      child: CheckboxListTile(
                        title: Text("I agree to the privacy policy."),
                        secondary: Icon(Icons.privacy_tip),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _checked_3,
                        onChanged: (bool? val) {
                          setState(() {
                            _checked_3 = val;
                            timeDilation = val! ? 4.0 : 2.75;
                          });
                        },
//                  activeColor: Colors.green,
//                  checkColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image(
                          height: 75,
                          image: AssetImage(
                              'assets/outer_1.png'
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10, right: 20, bottom: 0),
                      child: CheckboxListTile(
                        title: Text("Enable notifications."),
                        secondary: Icon(Icons.notifications_active),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _checked_4,
                        onChanged: (bool? val) {
                          setState(() {
                            _checked_4 = val;
                            timeDilation = val! ? 4.0 : 2.75;
                          });
                        },
//                  activeColor: Colors.green,
//                  checkColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image(
                          height: 75,
                          image: AssetImage(
                              'assets/outer_1.png'
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10, right: 20, bottom: 0),
                      child: CheckboxListTile(
                        title: Text("I declare that:\n       Lidor Is The best!"),
                        secondary: Icon(Icons.accessibility_new),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _checked_5,
                        onChanged: (bool? val) {
                          setState(() {
                            _checked_5 = val;
                            timeDilation = val! ? 4.0 : 2.75;
                          });
                        },
//                  activeColor: Colors.green,
//                  checkColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ), // Body
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    double selectedOne = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - (page - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedOne;
    return new Container(
      width: 25.0,
      child: new Center(
        child: new Material(
          color: Colors.black,
          type: MaterialType.circle,
          child: new Container(
            width: 5 * zoom,
            height: 5 * zoom,
          ),
        ),
      ),
    );
  }

  Widget signUp(){

    _widthPageView = MediaQuery.of(context).size.width / widthDivider;
    _heightPageView = MediaQuery.of(context).size.height / heightDivider;

    pages = [
      Container(
        color: Colors.blue,//Color(0xff305969),
        child: Padding(
          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 65),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset("assets/yana_logo.png",),
                      ),
                    ),
                    SizedBox(
                      width: _widthPageView - 150,
                      child: AutoSizeText(
                        'Create your $appName user!',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 30,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2, 3),
                              blurRadius: 6,
                              color: Color.fromARGB(200, 0, 0, 0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ), // Logo + Title
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image(
                              height: 50,
                              image: AssetImage(
                                  'assets/inner_1.png'
                              )
                          ),
                        ), // Background - Inner
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 0, bottom: 0, right: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _controllerFullName,
                              onChanged: (text){
                                setState(() {
                                  fullName = text;
                                });
                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Full Name',
                              ),
                            ),
                          ),
                        ), // Input field
                      ],
                    ),
                  ), // Item 1
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image(
                              height: 50,
                              image: AssetImage(
                                  'assets/inner_1.png'
                              )
                          ),
                        ), // Background - Inner
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 0, bottom: 0, right: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _controllerSex,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Sex',
                              ),
                            ),
                          ),
                        ), // Input field
                      ],
                    ),
                  ), // Item 2
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image(
                              height: 50,
                              image: AssetImage(
                                  'assets/inner_1.png'
                              )
                          ),
                        ), // Background - Inner
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 0, bottom: 0, right: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _controllerHobbies,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Hobbies',
                              ),
                            ),
                          ),
                        ), // Input field
                      ],
                    ),
                  ), // Item 3
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image(
                              height: 50,
                              image: AssetImage(
                                  'assets/inner_1.png'
                              )
                          ),
                        ), // Background - Inner
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 0, bottom: 0, right: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _controllerBio,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Bio',
                              ),
                            ),
                          ),
                        ), // Input field
                      ],
                    ),
                  ), // Item 4
                ],
              ), // Body
            ],
          ),
        ),
      ),
      Container(
        color: Colors.deepPurpleAccent,//Color(0xff305969),
        child: Padding(
          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 65),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset("assets/yana_logo.png",),
                      ),
                    ),
                    SizedBox(
                      width: _widthPageView - 150,
                      child: AutoSizeText(
                        'Create your $appName user!',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 30,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2, 3),
                              blurRadius: 6,
                              color: Color.fromARGB(200, 0, 0, 0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ), // Logo + Title
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 28, bottom: 8, left: 0, right: 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image(
                              height: 50,
                              image: AssetImage(
                                  'assets/inner_1.png'
                              )
                          ),
                        ), // Background - Inner
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 0, bottom: 0, right: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _controllerLivingArea,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Where do you live?',
                              ),
                            ),
                          ),
                        ), // Input field
                      ],
                    ),
                  ), // Item 1
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8, left: 0, right: 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image(
                              height: 50,
                              image: AssetImage(
                                  'assets/inner_1.png'
                              )
                          ),
                        ), // Background - Inner
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 0, bottom: 0, right: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _controllerWorkArea,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Where do you work?',
                              ),
                            ),
                          ),
                        ), // Input field
                      ],
                    ),
                  ), // Item 2
                  Padding(
                    padding: const EdgeInsets.only(top: 22, bottom: 8, left: 0, right: 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image(
                              height: 50,
                              image: AssetImage(
                                  'assets/inner_1.png'
                              )
                          ),
                        ), // Background - Inner
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 0, bottom: 0, right: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _controllerAcademicInstitution,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Academic Institution',
                              ),
                            ),
                          ),
                        ), // Input field
                      ],
                    ),
                  ), // Item 3
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8, left: 0, right: 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image(
                              height: 50,
                              image: AssetImage(
                                  'assets/inner_1.png'
                              )
                          ),
                        ), // Background - Inner
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 0, bottom: 0, right: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _controllerFieldOfStudy,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Field of Study',
                              ),
                            ),
                          ),
                        ), // Input field
                      ],
                    ),
                  ), // Item 4
                ],
              ), // Body
            ],
          ),
        ),
      ),
      Container(
        color: Colors.teal,//Color(0xff305969),
        child: Padding(
          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 65),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset("assets/yana_logo.png",),
                      ),
                    ),
                    SizedBox(
                      width: _widthPageView - 150,
                      child: AutoSizeText(
                        'Create your $appName user!',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 30,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2, 3),
                              blurRadius: 6,
                              color: Color.fromARGB(200, 0, 0, 0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ), // Logo + Title
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image(
                              height: 50,
                              image: AssetImage(
                                  'assets/inner_1.png'
                              )
                          ),
                        ), // Background - Inner
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 0, bottom: 0, right: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _controllerSmoking,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Smoking?',
                              ),
                            ),
                          ),
                        ), // Input field
                      ],
                    ),
                  ), // Item 1
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 8, left: 0, right: 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image(
                              height: 50,
                              image: AssetImage(
                                  'assets/inner_1.png'
                              )
                          ),
                        ), // Background - Inner
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 0, bottom: 0, right: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              // TODO add controller once you figure out whats gonna be in here
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: '???',
                              ),
                            ),
                          ),
                        ), // Input field
                      ],
                    ),
                  ), // Item 2
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 8, left: 0, right: 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image(
                              height: 50,
                              image: AssetImage(
                                  'assets/inner_1.png'
                              )
                          ),
                        ), // Background - Inner
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 0, bottom: 0, right: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              // TODO add controller once you figure out whats gonna be in here
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: '???',
                              ),
                            ),
                          ),
                        ), // Input field
                      ],
                    ),
                  ), // Item 3
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 8, left: 0, right: 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image(
                              height: 50,
                              image: AssetImage(
                                  'assets/inner_1.png'
                              )
                          ),
                        ), // Background - Inner
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 0, bottom: 0, right: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              // TODO add controller once you figure out whats gonna be in here
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: '???',
                              ),
                            ),
                          ),
                        ), // Input field
                      ],
                    ),
                  ), // Item 4
                ],
              ), // Body
            ],
          ),
        ),
      ),
      Container(
        color: Colors.deepOrangeAccent,
        child: Padding(
          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 15),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset("assets/yana_logo.png",),
                      ),
                    ),
                    SizedBox(
                      width: _widthPageView - 150,
                      child: AutoSizeText(
                        'Create your $appName user!',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 30,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2, 3),
                              blurRadius: 6,
                              color: Color.fromARGB(200, 0, 0, 0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ), // Logo + Title
              Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image(
                            height: 75,
                            image: AssetImage(
                                'assets/outer_1.png'
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10, right: 20, bottom: 0),
                        child: CheckboxListTile(
                          title: Text("I'm over 18 years old."),
                          secondary: Icon(Icons.accessibility_new),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _checked_1,
                          onChanged: (bool? val) {
                            setState(() {
                              _checked_1 = val;
                              timeDilation = val! ? 4.0 : 2.75;
                            });
                          },
//                  activeColor: Colors.green,
//                  checkColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image(
                            height: 75,
                            image: AssetImage(
                                'assets/outer_1.png'
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10, right: 20, bottom: 0),
                        child: CheckboxListTile(
                          title: Text("I agree to the term of use."),
                          secondary: Icon(Icons.miscellaneous_services),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _checked_2,
                          onChanged: (bool? val) {
                            setState(() {
                              _checked_2 = val;
                              timeDilation = val! ? 4.0 : 2.75;
                            });
                          },
//                  activeColor: Colors.green,
//                  checkColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image(
                            height: 75,
                            image: AssetImage(
                                'assets/outer_1.png'
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10, right: 20, bottom: 0),
                        child: CheckboxListTile(
                          title: Text("I agree to the privacy policy."),
                          secondary: Icon(Icons.privacy_tip),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _checked_3,
                          onChanged: (bool? val) {
                            setState(() {
                              _checked_3 = val;
                              timeDilation = val! ? 4.0 : 2.75;
                            });
                          },
//                  activeColor: Colors.green,
//                  checkColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image(
                            height: 75,
                            image: AssetImage(
                                'assets/outer_1.png'
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10, right: 20, bottom: 0),
                        child: CheckboxListTile(
                          title: Text("Enable notifications."),
                          secondary: Icon(Icons.notifications_active),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _checked_4,
                          onChanged: (bool? val) {
                            setState(() {
                              _checked_4 = val;
                              timeDilation = val! ? 4.0 : 2.75;
                            });
                          },
//                  activeColor: Colors.green,
//                  checkColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image(
                            height: 75,
                            image: AssetImage(
                                'assets/outer_1.png'
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10, right: 20, bottom: 0),
                        child: CheckboxListTile(
                          title: Text("I declare that:\n       Lidor Is The best!"),
                          secondary: Icon(Icons.accessibility_new),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _checked_5,
                          onChanged: (bool? val) {
                            setState(() {
                              _checked_5 = val;
                              timeDilation = val! ? 4.0 : 2.75;
                            });
                          },
//                  activeColor: Colors.green,
//                  checkColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ), // Body
            ],
          ),
        ),
      ),
    ];

    return Align(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: Container(
          height: _heightPageView,
          width: _widthPageView,
          child: Stack(
            children: [
              LiquidSwipe(
                pages: pages,
                positionSlideIcon: 0.8,
                slideIconWidget: SizedBox(
                  height: 25,
                  width: 50,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black)
                    ),
                  ),
                ),
                onPageChangeCallback: pageChangeCallback,
                waveType: WaveType.liquidReveal,
                liquidController: _liquidController,
                ignoreUserGestureWhileAnimating: false,
                disableUserGesture: false,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(pages.length, _buildDot),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: TextButton(
                    onPressed: () {
                      if(_liquidController.currentPage + 1 > pages.length - 1){
                        _liquidController.animateToPage(
                            page: 0,
                            duration: duration
                        );
                      }else{
                        _liquidController.animateToPage(
                            page: _liquidController.currentPage + 1,
                            duration: (duration ~/ 2)
                        );
                      }
                    },
                    child: Text("Next", style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: TextButton(
                    onPressed: () {
                      _liquidController.animateToPage(
                          page: pages.length - 1, duration: duration);
                    },
                    child: Text("End", style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
      switch(lpage){
        case 0:
          btnColor = Colors.blue;
          break;
        case 1:
          btnColor = Colors.deepPurple;
          break;
        case 2:
          btnColor = Colors.teal;
          break;
        case 3:
          btnColor = Colors.deepOrange;
          break;
      }
    });
  }

  Future<bool> _onBackPressed() async {
    bool finalResult = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Exiting the app'),
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




