// Libraries
import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
// Inside stuff
import 'package:yana/UI/WIDGETS/allWidgets.dart';
import 'package:yana/UX/DB/users.dart';
import 'package:yana/UX/LOGIC/CLASSES/firebaseHelper.dart';
import 'AllPage.dart';

// TextFields content variables for the controllers
String fullName = "", sex = "", hobbies = "", bio = "";
String livingArea = "", workArea = "", academicInstitution = "", fieldOfStudy = "";
String smoking = "";
String photoURL = "";
// Submit button default color
var dynamicColor = Colors.blue;

class SignUp extends StatefulWidget {

//  Callback function related - See main.dart callback section for more info about it
  Map<String, String> userCredentials = new Map<String, String>();
  final Function callback;
  SignUp(this.callback, this.userCredentials);

  @override
  _SignUpState createState() => _SignUpState();

}

class _SignUpState extends State<SignUp> {

  // Animation default duration
  static const int duration = 700; // 700
  static double _widthPageView = 350, _heightPageView = 600;
  double heightDivider = 1.4, widthDivider = 1.15;
  int page = 0;
  LiquidController _liquidController = LiquidController();
  // CheckBoxListTiles boolean checkers
  bool? _checked18 = false, _checkedTou = false, _checkedPp = false, _checkedNotifications = false, _checked_5 = false;
  // Button Related
  final streamController = StreamController<bool>.broadcast();
  var change = false;
  var clr = Colors.red, btnText = "Submit", _duration = 1000, dur = 1000;
  double containerW = 300, containerH = 75;

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
    fillFromFacebook();

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

  void fillFromFacebook() {
    print("\n\n******************\n" + this.widget.userCredentials.toString() + "\n******************\n\n");
    fullName = this.widget.userCredentials["name"].toString();
    sex = this.widget.userCredentials["gender"].toString();
    int age = int.parse(this.widget.userCredentials["age_range"].toString());
    if(age > 18){ _checked18 = true; }
    photoURL = this.widget.userCredentials["picture_link"].toString();
  }

  @override
  void dispose() {
    super.dispose();
    // Disposing all the controllers at the end of this Widget \ Page cycle
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

  @override
  Widget build(BuildContext context) {
    // Body swipe pages sizes update
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
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: dynamicColor, width: 5),
//                  border: Border.all(color: Colors.black, width: 5),
                  borderRadius: BorderRadius.circular(16.0),
                  color: clr,
                ),
                duration: Duration(milliseconds: _duration),
                width: containerW,
                height: containerH,
                child: StreamBuilder<bool>(
                  stream: streamController.stream,
                  initialData: false,
                  builder: (context, snapshot){
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
//                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child,),
//                    transitionBuilder: (child, animation) => SizeTransition(sizeFactor: animation, child: child,),
                      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child,),
                      child: snapshot.data!
                          ? SizedBox(
                          width: 35,
//                          height: 50,
                          child: CircularProgressIndicator()
                      )
                          : Container(
                        width: containerW,
                        height: containerH,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11.0),
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                change = !change;
                                streamController.add(change);
                                clr = Colors.green;
                                containerW = 75;
                                checkUserCredentials();
                              });
                            },
                            child: Text(btnText, style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.cyan[600],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
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

  // Logic - checking that everything that is a must is filled and valid
  void checkUserCredentials() {
    String checkerStr = "", btnResultText = "";
    dur = 1000;
    if(!_checked_5!){ checkerStr = "Lidor is \n   The Best ! ! !"; }
    if(!_checkedNotifications!){ checkerStr = "Notification bullet"; }
    if(!_checkedPp!){ checkerStr = "Please accept the privacy policy"; }
    if(!_checkedTou!){ checkerStr = "Please accept the term of use"; }
    if(!_checked18!){ checkerStr = "18 Statement missing"; }
    if(smoking.isEmpty){ checkerStr = "Smoking missing"; }
    if(fieldOfStudy.isEmpty){ checkerStr = "Field of study missing"; }
    if(academicInstitution.isEmpty){ checkerStr = "Academic institution missing"; }
    if(workArea.isEmpty){ checkerStr = "Work area missing"; }
    if(livingArea.isEmpty){ checkerStr = "Living area missing"; }
    if(bio.isEmpty){ checkerStr = "Bio missing"; }
    if(hobbies.isEmpty){ checkerStr = "Hobbies missing"; }
    if(sex.isEmpty){ checkerStr = "Sex missing"; }
    if(fullName.isEmpty){ checkerStr = "Name missing"; }
    print("\n\n" + checkerStr + "\n\n");
    Future.delayed(const Duration(milliseconds: 2500), () {
      bool status = false;
      if(checkerStr.isEmpty){
        btnResultText = "Success!";
        status = true;
      }else{
        btnResultText = checkerStr;
      }
      setState(() {
        _duration = dur;
        change = !change;
        streamController.add(change);
        containerW = 175;
        clr = Colors.red;
        btnText = btnResultText;
        if(status){
          DateTime now = new DateTime.now();
          String formattedDate = new DateFormat('dd-MM-yyyy').format(now);
          Map<String, String> newUserInfo = new Map<String, String>();
          newUserInfo["id"]                =      this.widget.userCredentials["id"].toString();
          newUserInfo["name"]              =      this.widget.userCredentials["name"].toString();
          newUserInfo["email"]             =      this.widget.userCredentials["email"].toString();
          newUserInfo["birthday"]          =      this.widget.userCredentials["birthday"].toString();
          newUserInfo["age_range"]         =      this.widget.userCredentials["age_range"].toString();
          newUserInfo["gender"]            =      this.widget.userCredentials["gender"].toString();
          newUserInfo["hobbies"]           =      hobbies;
          newUserInfo["bio"]               =      bio;
          newUserInfo["living_area"]       =      livingArea;
          newUserInfo["work_area"]         =      workArea;
          newUserInfo["school"]            =      academicInstitution;
          newUserInfo["field_of_study"]    =      fieldOfStudy;
          newUserInfo["smoking"]           =      smoking;
          newUserInfo["signUpDate"]        =      formattedDate;
          newUserInfo["isBlocked"]         =      "false";
          newUserInfo["notifications"]     =      _checkedNotifications.toString();
          newUserInfo["picture_link"]      =      this.widget.userCredentials["picture_link"].toString();
          User newUser = new User.fromMap(newUserInfo);
          FirebaseHelper.sendUserToFb(newUser);
          logNewUserIn(newUserInfo);
        }
      });
    });
  }

  void logNewUserIn(Map<String, String> updateUserInfo){
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        Fluttertoast.showToast(
            msg: updateUserInfo.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
        );
        this.widget.callback(3, updateUserInfo);
      });
    });
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

  // Pages dots to indicate which page is the current one

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

  // Signup body (Swiping area) building
  Widget signUp(){

    // Body sizes
    _widthPageView = MediaQuery.of(context).size.width / widthDivider;
    _heightPageView = MediaQuery.of(context).size.height / heightDivider;
    // Each item padding
    const double _padding = 12.0;

    // Signup body pages (Swiping area)
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.0),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: photoURL == ""
                              ? Image.asset("assets/yana_logo.png",)
                              : Image.network(photoURL),
                        ),
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
                    padding: const EdgeInsets.only(top: _padding, bottom: _padding, left: 0, right: 0),
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
                    padding: const EdgeInsets.only(top: _padding, bottom: _padding, left: 0, right: 0),
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
                              onChanged: (_sex){
                                setState(() {
                                  sex = _sex;
                                });
                              },
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
                    padding: const EdgeInsets.only(top: _padding, bottom: _padding, left: 0, right: 0),
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
                              onChanged: (_hobbies){
                                setState(() {
                                  hobbies = _hobbies;
                                });
                              },
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
                    padding: const EdgeInsets.only(top: _padding, bottom: _padding, left: 0, right: 0),
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
                              onChanged: (_bio){
                                setState(() {
                                  bio = _bio;
                                });
                              },
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.0),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset("assets/yana_logo.png",),
                        ),
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
                    padding: const EdgeInsets.only(top: _padding, bottom: _padding, left: 0, right: 0),
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
                              onChanged: (_livingArea){
                                setState(() {
                                  livingArea = _livingArea;
                                });
                              },
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
                    padding: const EdgeInsets.only(top: _padding, bottom: _padding, left: 0, right: 0),
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
                              onChanged: (_workArea){
                                setState(() {
                                  workArea = _workArea;
                                });
                              },
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
                    padding: const EdgeInsets.only(top: _padding, bottom: _padding, left: 0, right: 0),
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
                              onChanged: (_academicInstitution){
                                setState(() {
                                  academicInstitution = _academicInstitution;
                                });
                              },
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
                    padding: const EdgeInsets.only(top: _padding, bottom: _padding, left: 0, right: 0),
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
                              onChanged: (_fieldOfStudy){
                                setState(() {
                                  fieldOfStudy = _fieldOfStudy;
                                });
                              },
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.0),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset("assets/yana_logo.png",),
                        ),
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
                    padding: const EdgeInsets.only(top: _padding, bottom: _padding, left: 0, right: 0),
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
                              onChanged: (_smoking){
                                setState(() {
                                  smoking = _smoking;
                                });
                              },
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
                    padding: const EdgeInsets.only(top: _padding, bottom: _padding, left: 0, right: 0),
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
                    padding: const EdgeInsets.only(top: _padding, bottom: _padding, left: 0, right: 0),
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
                    padding: const EdgeInsets.only(top: _padding, bottom: _padding, left: 0, right: 0),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.0),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset("assets/yana_logo.png",),
                        ),
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
                          value: _checked18,
                          onChanged: (bool? val) {
                            setState(() {
                              _checked18 = val;
//                              timeDilation = val! ? 4.0 : 2.75;
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
                          value: _checkedTou,
                          onChanged: (bool? val) {
                            setState(() {
                              _checkedTou = val;
//                              timeDilation = val! ? 4.0 : 2.75;
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
                          value: _checkedPp,
                          onChanged: (bool? val) {
                            setState(() {
                              _checkedPp = val;
//                              timeDilation = val! ? 4.0 : 2.75;
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
                          value: _checkedNotifications,
                          onChanged: (bool? val) {
                            setState(() {
                              _checkedNotifications = val;
//                              timeDilation = val! ? 4.0 : 2.75;
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
//                              timeDilation = val! ? 4.0 : 2.75;
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

  // Each page swipe callback function
  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
      switch(lpage){
        case 0:
          dynamicColor = Colors.blue;
          break;
        case 1:
          dynamicColor = Colors.deepPurple;
          break;
        case 2:
          dynamicColor = Colors.teal;
          break;
        case 3:
          dynamicColor = Colors.deepOrange;
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




