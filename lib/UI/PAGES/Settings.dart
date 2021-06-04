//FLUTTER
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yana/UI/PAGES/Utilities.dart';
import 'package:yana/UX/DB/users.dart';
import 'package:yana/UX/LOGIC/CLASSES/firebaseHelper.dart';
//WIDGETS
import '../WIDGETS/allWidgets.dart';

class Settings extends StatefulWidget {

  final Function callback;
  Settings(this.callback);

  @override
  _SettingsState createState() => _SettingsState();

}

class _SettingsState extends State<Settings> {

  /// [_notification] - Determine if the user would like to get popup notifications
  /// [_isExpandedAbout] - About section open / close variable
  /// [_isExpandedGetHelp] - Get Help section open / close variable
  /// [_radius] - The radius of the background of the user edit area
  /// [userName] - The name of the user, we got it from Facebook
  /// @_controller'Name' - [TextField] controllers in order to get all the text changes
  bool _notification = userMap['notifications'].toString().toLowerCase() == 'true';
  bool _isExpandedAbout = false, _isExpandedGetHelp = false;
  double _radius = 14.0, _paddingRight = 30.0, _paddingLeft = 25.0;
  String userName = userMap['name'].toString();
  late List<bool> _toggleSelections;
  late TextEditingController _controllerSex;
  late TextEditingController _controllerHobbies;
  late TextEditingController _controllerBio;
  late TextEditingController _controllerLivingArea;
  late TextEditingController _controllerWorkArea;
  late TextEditingController _controllerAcademicInstitution;
  late TextEditingController _controllerFieldOfStudy;
  late TextEditingController _controllerSmoking;
  late TextEditingController _controllerSignUpDate;
  late User updatedUser;
  String _hobbies = userMap['hobbies'].toString(), _bio = userMap['bio'].toString(),
      _livingArea = userMap['livingArea'].toString(), _workArea = userMap['workArea'].toString(),
      _academicInstitution =  userMap['academicInstitution'].toString(),
      _fieldOfStudy = userMap['fieldOfStudy'].toString(), _smoking = userMap['smoking'].toString();

  @override
  void initState() {
    _toggleSelections = [!defaultMapType, defaultMapType];
    _updateControllers();
    super.initState();
  }

  void _updateControllers() {
    _controllerSex = new TextEditingController(text: userMap['gender'].toString());
    _controllerHobbies = new TextEditingController(text: _hobbies);
    _controllerBio = new TextEditingController(text: _bio);
    _controllerLivingArea = new TextEditingController(text: _livingArea);
    _controllerWorkArea = new TextEditingController(text: _workArea);
    _controllerAcademicInstitution = new TextEditingController(text: _academicInstitution);
    _controllerFieldOfStudy = new TextEditingController(text: _fieldOfStudy);
    _controllerSmoking = new TextEditingController(text: _smoking);
    _controllerSignUpDate = new TextEditingController(text: userMap['signUpDate'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Theme(  // In order to make the overScroll glow color change
              data: Theme.of(context).copyWith(
                  accentColor: Colors.amberAccent
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 125,), // App Bar height space
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.amber[300]!.withOpacity(0.8),
                            borderRadius: BorderRadius.all(Radius.circular(_radius)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: ListTile(
                              title: Align(
                                  alignment: Alignment(1.153, 0),
                                  child: Text("התראות")
                              ),
                              leading: Icon(Icons.notifications),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch.adaptive(
                                      inactiveTrackColor: Colors.grey.withOpacity(0.4),
                                      inactiveThumbColor: Colors.grey[400]!.withOpacity(0.4),
                                      activeColor: Colors.green.withOpacity(0.75),
                                      activeTrackColor: Colors.green.withOpacity(0.6),
                                      value: _notification,
                                      onChanged: (val){
                                        setState(() {
                                          _notification = val;
                                          userMap['notifications'] = _notification.toString();
                                          updateUser(); // Save notifications preferences
                                        });
                                      }
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NotificationPage()
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.notifications_outlined, color: Colors.pink[600], size: 27.0,)
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                    ),  //  Notifications
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                      child: GestureDetector(
                        onTap: () => _openUserEditSheet(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.amber[300]!.withOpacity(0.8),
                            borderRadius: BorderRadius.all(Radius.circular(_radius)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListTile(
                              title: Align(
                                  alignment: Alignment(1.313, 0),
                                  child: Text(userName)
                              ),
                              leading: Icon(Icons.account_circle),
                              trailing: Icon(Icons.edit),
                            ),
                          ),
                        ),
                      ),
                    ),  //  User Profile
                    /// Not for this time period
                    /// Do not delete the Auto-Filters widget comment:
//                  Padding(
//                    padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
//                    child: Container(
//                      decoration: BoxDecoration(
//                        color: Colors.amber[300]!.withOpacity(0.8),
//                        borderRadius: BorderRadius.all(Radius.circular(_radius)),
//                      ),
//                      child: Padding(
//                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                        child: ListTile(
//                          title: Align(
//                              alignment: Alignment(-1.193, 0),
//                              child: Text("Auto Filters")
//                          ),
//                          leading: Icon(Icons.filter_list),
//                          trailing: Icon(Icons.add_box),
//                        ),
//                      ),
//                    ),
//                  ),  //  Auto Filters
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.amber[300]!.withOpacity(0.8),
                            borderRadius: BorderRadius.all(Radius.circular(_radius)),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(_radius)),
                                child: ExpansionPanelList(
                                  elevation: 0,
                                  expandedHeaderPadding: EdgeInsets.all(0.0),
                                  expansionCallback: (int index, bool isExpanded) {
                                    setState(() {
                                      _isExpandedAbout = !_isExpandedAbout;
                                    });
                                  },
                                  animationDuration: Duration(milliseconds: 300),
                                  children: [
                                    ExpansionPanel(
                                      canTapOnHeader: true,
                                      isExpanded: _isExpandedAbout,
                                      backgroundColor: Colors.amber.withOpacity(0.1),
                                      headerBuilder: (context, isOpen){
                                        return Container(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: ListTile(
                                              title: Align(
                                                  alignment: Alignment(1.193, 0),
                                                  child: Text("אודות")
                                              ),
                                              leading: Icon(Icons.info_outline),
                                            ),
                                          ),
                                        );
                                      },
                                      body: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                                        child: Text(aboutOrganization),
                                      ),
                                    )
                                  ],
                                ),
                              ),  //  About
                              // TODO Privacy Policy + Terms of Use -> Don't Touch Yet
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: ListTile(
                                  title: Align(
                                      alignment: Alignment(1.333, 0),
                                      child: Text("הצהרת פרטיות")
                                  ),
                                  leading: Icon(Icons.privacy_tip),
                                  trailing: Icon(Icons.keyboard_arrow_down),
                                ),
                              ),  //  Privacy Policy
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: ListTile(
                                  title: Align(
                                      alignment: Alignment(1.233, 0),
                                      child: Text("תנאי שימוש")
                                  ),
                                  leading: Icon(Icons.description_outlined),
                                  trailing: Icon(Icons.keyboard_arrow_down),
                                ),
                              ),  //  Terms of Use
                            ],
                          )
                      ),
                    ),  //  About & Privacy Policy & Terms of Use
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.amber[300]!.withOpacity(0.8),
                          borderRadius: BorderRadius.all(Radius.circular(_radius)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ListTile(
                            title: Align(
                                alignment: Alignment(1.5, 0),
                                child: AutoSizeText("סגנון מפה", maxLines: 2,)
                            ),
                            leading: Icon(Icons.map),
                            trailing: ToggleButtons(
                              isSelected: _toggleSelections,
                              selectedColor: Colors.green,
                              fillColor: Colors.transparent,
                              borderWidth: 2.0,
                              borderColor: Colors.transparent,
                              selectedBorderColor: Colors.transparent,
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      Icon(Icons.map_outlined),
                                      Text("רגיל", style: TextStyle(fontSize: 12),),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      Icon(Icons.satellite),
                                      Text("לווין", style: TextStyle(fontSize: 12),),
                                    ],
                                  ),
                                ),
                              ],
                              onPressed: (int index){
                                setState(() {
                                  for(int i = 0; i < _toggleSelections.length; i++){
                                    _toggleSelections[i] = !_toggleSelections[i];
                                  }
                                  // _toggleSelections[0] = Normal
                                  // _toggleSelections[1] = Hybrid
                                  if(_toggleSelections[0]){
                                    defaultMapType = false;
                                  }else if(_toggleSelections[1]){
                                    defaultMapType = true;
                                  }
                                  savePreference();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),  //  Map Default State
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(_radius)),
                        child: ExpansionPanelList(
                          elevation: 0,
                          expandedHeaderPadding: EdgeInsets.all(0.0),
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isExpandedGetHelp = !_isExpandedGetHelp;
                            });
                          },
                          animationDuration: Duration(milliseconds: 300),
                          children: [
                            ExpansionPanel(
                              canTapOnHeader: true,
                              isExpanded: _isExpandedGetHelp,
                              backgroundColor: Colors.amber[300]!.withOpacity(0.8),
                              headerBuilder: (context, isOpen){
                                return Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 9.5),
                                    child: ListTile(
                                      title: Align(
                                          alignment: Alignment(1.023, 0),
                                          child: Text("קבל עזרה")
                                      ),
                                      leading: ImageIcon(
                                        AssetImage('assets/get_help.png'),
                                        color: Color(0xFF6b81ae),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              body: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                    child: ListTile(
                                      onTap: (){
                                        launch(specialistNumberCall);
                                      },
                                      title: Align(
                                        alignment: Alignment(1.251, 0),
                                        child: Text("התקשר אל מומחה")
                                      ),
                                      leading: Icon(Icons.call),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                    child: ListTile(
                                      onTap: (){
                                        launch("https://wa.me/$specialistNumberSms?text=");
                                      },
                                      title: Align(
                                        alignment: Alignment(1.251, 0),
                                        child: Text("שלח הודעה למומחה")
                                      ),
                                      leading: Icon(Icons.message),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),  //  Get Help
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.amber[300]!.withOpacity(0.8),
                          borderRadius: BorderRadius.all(Radius.circular(_radius)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ListTile(
                                onTap: (){
                                  FirebaseHelper.deleteAllUserChats("LidorID");// TODO userMap['id']);
                                },
                                title: Align(
                                    alignment: Alignment(1.314, 0),
                                    child: Text("מחק את כול הצ'אטים")
                                ),
                                leading: Icon(Icons.delete_outline),
                              ),
                            ),  //  Delete All Chats
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ListTile(
                                onTap: (){
                                  FirebaseHelper.deleteAllUserEvents(userMap['id']);
                                },
                                title: Align(
                                    alignment: Alignment(1.35, 0),
                                    child: Text("מחק את כול האירועים")
                                ),
                                leading: Icon(Icons.delete_sharp),
                              ),
                            ),  //  Delete All Events
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ListTile(
                                onTap: (){
                                  FirebaseHelper.deleteUserAccount("yisrael"); // TODO userMap['id']);
                                  _logOut();
                                },
                                title: Align(
                                    alignment: Alignment(1.18, 0),
                                    child: Text("מחק משתמש")
                                ),
                                leading: Icon(Icons.delete_forever),
                              ),
                            ),  //  Delete My Account
                          ],
                        ),
                      ),
                    ),  //  Delete: All Chats / All Events / Account
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 10.0, bottom: 75.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.amber[300]!.withOpacity(0.8),
                          borderRadius: BorderRadius.all(Radius.circular(_radius)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ListTile(
                            onTap: (){
                              _logOut();
                            },
                            title: Align(
                                alignment: Alignment(1.115, 0),
                                child: Text("התנתק")
                            ),
                            leading: ImageIcon(
                              AssetImage('assets/logout.png'),
                            ),
                          ),
                        ),
                      ),
                    ),  //  Logout
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: MyAppBar("הגדרות", funcAction, height: 100,)
            ),
          ],
        ),
      ),
    );
  }

  /// [userPhotoURL]
  /// [_h]
  /// [_w]
  /// [textFieldsHeight]
  /// [_leftSideWidth]
  /// [_rightSideWidth]
  void _openUserEditSheet(){
    String userPhotoURL = "";
    double _h = ((MediaQuery.of(context).size.height / 3) * 1.75);
    double _w = ((MediaQuery.of(context).size.width / 2) * 1.45);
    double textFieldsHeight = 35.0, _leftSideWidth = _w / 3.0, _rightSideWidth = ((_w / 1.5) - 5.0);
    userPhotoURL = userMap["picture_link"].toString();
    showModalBottomSheet(
      context: context,
      builder: (context){
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            constraints: new BoxConstraints(maxHeight: _h,),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    constraints: new BoxConstraints(maxHeight: (_h - 75.0),),
                    decoration: BoxDecoration(
                        color: bodyColor.withOpacity(1),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(75), topRight: Radius.circular(75)),
                    ),
                  ),
                ),  //  Background
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 89.35),
                    child: NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overScroll) {
                        overScroll.disallowGlow();
                        return true;
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 42.35, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        "מין",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 42.35, bottom: 10.0, left: _paddingLeft),
                                    child: TextField(
                                      controller: _controllerSex,
                                      onChanged: (_text){
                                        setState(() {});
                                      },
                                      enabled: false,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'Sex',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        "תחביבים",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: _paddingLeft),
                                    child: TextField(
                                      controller: _controllerHobbies,
                                      onChanged: (_text){
                                        setState(() {
                                          _hobbies = _text;
                                        });
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'Hobbies',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        "תמצית",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: _paddingLeft),
                                    child: TextField(
                                      controller: _controllerBio,
                                      onChanged: (_text){
                                        setState(() {
                                          _bio = _text;
                                        });
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'Bio',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        "מגורים",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: _paddingLeft),
                                    child: TextField(
                                      controller: _controllerLivingArea,
                                      onChanged: (_text){
                                        setState(() {
                                          _livingArea = _text;
                                        });
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'Living Area',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        "עבודה",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: _paddingLeft),
                                    child: TextField(
                                      controller: _controllerWorkArea,
                                      onChanged: (_text){
                                        setState(() {
                                          _workArea = _text;
                                        });
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'Work Area',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        "מוסד אקדמאי",
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: _paddingLeft),
                                    child: TextField(
                                      controller: _controllerAcademicInstitution,
                                      onChanged: (_text){
                                        setState(() {
                                          _academicInstitution = _text;
                                        });
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'Academic Institution',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        "תחום לימודי",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: _paddingLeft),
                                    child: TextField(
                                      controller: _controllerFieldOfStudy,
                                      onChanged: (_text){
                                        setState(() {
                                          _fieldOfStudy = _text;
                                        });
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'Field Of Study',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        "עישון",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: _paddingLeft),
                                    child: TextField(
                                      controller: _controllerSmoking,
                                      onChanged: (_text){
                                        setState(() {
                                          _smoking = _text;
                                        });
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'Smoking',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 75.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        "תאריך הרשמה",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 75.0, left: _paddingLeft),
                                    child: TextField(
                                      controller: _controllerSignUpDate,
                                      onChanged: (_text){
                                        setState(() {});
                                      },
                                      enabled: false,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'Sign-Up Date',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: [
//                                Column(
//                                  children: [
//                                    Padding(
//                                      padding: const EdgeInsets.only(top: 42.35, bottom: 10.0),
//                                      child: SizedBox(
//                                        height: textFieldsHeight,
//                                        width: _leftSideWidth,
//                                        child: Align(
//                                          alignment: Alignment.centerRight,
//                                          child: AutoSizeText(
//                                            "מין",
//                                            maxLines: 1,
//                                          ),
//                                        ),
//                                      ),
//                                    ),// V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: SizedBox(
//                                        height: textFieldsHeight,
//                                        width: _leftSideWidth,
//                                        child: Align(
//                                          alignment: Alignment.centerRight,
//                                          child: AutoSizeText(
//                                            "תחביבים",
//                                            maxLines: 1,
//                                          ),
//                                        ),
//                                      ),
//                                    ),//V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: SizedBox(
//                                        height: textFieldsHeight,
//                                        width: _leftSideWidth,
//                                        child: Align(
//                                          alignment: Alignment.centerRight,
//                                          child: AutoSizeText(
//                                            "תמצית",
//                                            maxLines: 1,
//                                          ),
//                                        ),
//                                      ),
//                                    ),//V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: SizedBox(
//                                        height: textFieldsHeight,
//                                        width: _leftSideWidth,
//                                        child: Align(
//                                          alignment: Alignment.centerRight,
//                                          child: AutoSizeText(
//                                            "מגורים",
//                                            maxLines: 1,
//                                          ),
//                                        ),
//                                      ),
//                                    ),//V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: SizedBox(
//                                        height: textFieldsHeight,
//                                        width: _leftSideWidth,
//                                        child: Align(
//                                          alignment: Alignment.centerRight,
//                                          child: AutoSizeText(
//                                            "עבודה",
//                                            maxLines: 1,
//                                          ),
//                                        ),
//                                      ),
//                                    ),//V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: SizedBox(
//                                        height: textFieldsHeight,
//                                        width: _leftSideWidth,
//                                        child: Align(
//                                          alignment: Alignment.centerRight,
//                                          child: AutoSizeText(
//                                            "מוסד אקדמאי",
//                                            maxLines: 2,
//                                          ),
//                                        ),
//                                      ),
//                                    ),//V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: SizedBox(
//                                        height: textFieldsHeight,
//                                        width: _leftSideWidth,
//                                        child: Align(
//                                          alignment: Alignment.centerRight,
//                                          child: AutoSizeText(
//                                            "תחום לימודי",
//                                            maxLines: 1,
//                                          ),
//                                        ),
//                                      ),
//                                    ),//V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: SizedBox(
//                                        height: textFieldsHeight,
//                                        width: _leftSideWidth,
//                                        child: Align(
//                                          alignment: Alignment.centerRight,
//                                          child: AutoSizeText(
//                                            "עישון",
//                                            maxLines: 1,
//                                          ),
//                                        ),
//                                      ),
//                                    ),//V
//                                    Padding(
//                                      padding: const EdgeInsets.only(top: 10.0, bottom: 75.0),
//                                      child: SizedBox(
//                                        height: textFieldsHeight,
//                                        width: _leftSideWidth,
//                                        child: Align(
//                                          alignment: Alignment.centerRight,
//                                          child: AutoSizeText(
//                                            "תאריך הרשמה",
//                                            maxLines: 1,
//                                          ),
//                                        ),
//                                      ),
//                                    ),//V
//                                  ],
//                                ),
//                                Column(
//                                  children: [
//                                    Padding(
//                                      padding: const EdgeInsets.only(top: 42.35, bottom: 10.0),
//                                      child: Container(
//                                        height: textFieldsHeight,
//                                        width: _rightSideWidth,
//                                        child: TextField(
//                                          controller: _controllerSex,
//                                          onChanged: (_text){
//                                            setState(() {});
//                                          },
//                                          enabled: false,
//                                          textAlign: TextAlign.center,
//                                          decoration: InputDecoration(
//                                            border: InputBorder.none,
//                                            focusedBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black),
//                                            ),
//                                            enabledBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black26),
//                                            ),
//                                            errorBorder: InputBorder.none,
//                                            disabledBorder: InputBorder.none,
//                                            hintText: 'Sex',
//                                          ),
//                                        ),
//                                      ),
//                                    ),  //  Sex V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: Container(
//                                        height: textFieldsHeight,
//                                        width: _rightSideWidth,
//                                        child: TextField(
//                                      controller: _controllerHobbies,
//                                          onChanged: (_text){
//                                            setState(() {
//                                              _hobbies = _text;
//                                            });
//                                          },
//                                          textAlign: TextAlign.center,
//                                          decoration: InputDecoration(
//                                            border: InputBorder.none,
//                                            focusedBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black),
//                                            ),
//                                            enabledBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black26),
//                                            ),
//                                            errorBorder: InputBorder.none,
//                                            disabledBorder: InputBorder.none,
//                                            hintText: 'Hobbies',
//                                          ),
//                                        ),
//                                      ),
//                                    ),  //  Hobbies V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: Container(
//                                        height: textFieldsHeight,
//                                        width: _rightSideWidth,
//                                        child: TextField(
//                                          controller: _controllerBio,
//                                          onChanged: (_text){
//                                            setState(() {
//                                              _bio = _text;
//                                            });
//                                          },
//                                          textAlign: TextAlign.center,
//                                          decoration: InputDecoration(
//                                            border: InputBorder.none,
//                                            focusedBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black),
//                                            ),
//                                            enabledBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black26),
//                                            ),
//                                            errorBorder: InputBorder.none,
//                                            disabledBorder: InputBorder.none,
//                                            hintText: 'Bio',
//                                          ),
//                                        ),
//                                      ),
//                                    ),  //  Bio V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: Container(
//                                        height: textFieldsHeight,
//                                        width: _rightSideWidth,
//                                        child: TextField(
//                                      controller: _controllerLivingArea,
//                                          onChanged: (_text){
//                                            setState(() {
//                                              _livingArea = _text;
//                                            });
//                                          },
//                                          textAlign: TextAlign.center,
//                                          decoration: InputDecoration(
//                                            border: InputBorder.none,
//                                            focusedBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black),
//                                            ),
//                                            enabledBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black26),
//                                            ),
//                                            errorBorder: InputBorder.none,
//                                            disabledBorder: InputBorder.none,
//                                            hintText: 'Living Area',
//                                          ),
//                                        ),
//                                      ),
//                                    ),  //  Living Area V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: Container(
//                                        height: textFieldsHeight,
//                                        width: _rightSideWidth,
//                                        child: TextField(
//                                      controller: _controllerWorkArea,
//                                          onChanged: (_text){
//                                            setState(() {
//                                              _workArea = _text;
//                                            });
//                                          },
//                                          textAlign: TextAlign.center,
//                                          decoration: InputDecoration(
//                                            border: InputBorder.none,
//                                            focusedBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black),
//                                            ),
//                                            enabledBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black26),
//                                            ),
//                                            errorBorder: InputBorder.none,
//                                            disabledBorder: InputBorder.none,
//                                            hintText: 'Work Area',
//                                          ),
//                                        ),
//                                      ),
//                                    ),  //  Work Area V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: Container(
//                                        height: textFieldsHeight,
//                                        width: _rightSideWidth,
//                                        child: TextField(
//                                      controller: _controllerAcademicInstitution,
//                                          onChanged: (_text){
//                                            setState(() {
//                                              _academicInstitution = _text;
//                                            });
//                                          },
//                                          textAlign: TextAlign.center,
//                                          decoration: InputDecoration(
//                                            border: InputBorder.none,
//                                            focusedBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black),
//                                            ),
//                                            enabledBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black26),
//                                            ),
//                                            errorBorder: InputBorder.none,
//                                            disabledBorder: InputBorder.none,
//                                            hintText: 'Academic Institution',
//                                          ),
//                                        ),
//                                      ),
//                                    ),  //  Academic Institution V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: Container(
//                                        height: textFieldsHeight,
//                                        width: _rightSideWidth,
//                                        child: TextField(
//                                      controller: _controllerFieldOfStudy,
//                                          onChanged: (_text){
//                                            setState(() {
//                                              _fieldOfStudy = _text;
//                                            });
//                                          },
//                                          textAlign: TextAlign.center,
//                                          decoration: InputDecoration(
//                                            border: InputBorder.none,
//                                            focusedBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black),
//                                            ),
//                                            enabledBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black26),
//                                            ),
//                                            errorBorder: InputBorder.none,
//                                            disabledBorder: InputBorder.none,
//                                            hintText: 'Field Of Study',
//                                          ),
//                                        ),
//                                      ),
//                                    ),  //  Field Of Study V
//                                    Padding(
//                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                      child: Container(
//                                        height: textFieldsHeight,
//                                        width: _rightSideWidth,
//                                        child: TextField(
//                                      controller: _controllerSmoking,
//                                          onChanged: (_text){
//                                            setState(() {
//                                              _smoking = _text;
//                                            });
//                                          },
//                                          textAlign: TextAlign.center,
//                                          decoration: InputDecoration(
//                                            border: InputBorder.none,
//                                            focusedBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black),
//                                            ),
//                                            enabledBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black26),
//                                            ),
//                                            errorBorder: InputBorder.none,
//                                            disabledBorder: InputBorder.none,
//                                            hintText: 'Smoking',
//                                          ),
//                                        ),
//                                      ),
//                                    ),  //  Smoking V
//                                    Padding(
//                                      padding: const EdgeInsets.only(top: 10.0, bottom: 75.0),
//                                      child: Container(
//                                        height: textFieldsHeight,
//                                        width: _rightSideWidth,
//                                        child: TextField(
//                                      controller: _controllerSignUpDate,
//                                          onChanged: (_text){
//                                            setState(() {});
//                                          },
//                                          enabled: false,
//                                          textAlign: TextAlign.center,
//                                          decoration: InputDecoration(
//                                            border: InputBorder.none,
//                                            focusedBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black),
//                                            ),
//                                            enabledBorder: UnderlineInputBorder(
//                                              borderSide: BorderSide(color: Colors.black26),
//                                            ),
//                                            errorBorder: InputBorder.none,
//                                            disabledBorder: InputBorder.none,
//                                            hintText: 'Sign-Up Date',
//                                          ),
//                                        ),
//                                      ),
//                                    ),  //  Sign-Up Date V
//                                  ],
//                                ),
//                              ],
//                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),  //  Body
                Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(userPhotoURL),
                    backgroundColor: Colors.transparent,
                  ),
                ),  //  User Photo
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Wrap(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Neumorphism(
                              _w / 2.25,
                              41.0,
                              Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("בטל", style: TextStyle(fontSize: 18.0),)
                                  )
                              ),
                              type: NeumorphismOuterChip,
                              radius: 32.0,
                              alignment: Alignment.center,
                              color: bodyColor[600]!.withOpacity(0.95),
                            ),  //  Discard
                            Neumorphism(
                              _w / 2.25,
                              41.0,
                              Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      checkThenUpdateUser();
                                      Navigator.pop(context);
                                    },
                                    child: Text("שמור", style: TextStyle(fontSize: 18.0),)
                                  )
                              ),
                              type: NeumorphismOuterChip,
                              radius: 32.0,
                              alignment: Alignment.center,
                              color: bodyColor[600]!.withOpacity(0.95),
                            ),  //  Save
                          ],
                        ),
                      ],
                    ),
                  ),
                ),  //  Buttons
              ],
            ),
          ),
        );
      },
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  /// App Bar tap callback function
  funcAction(){
    print("action clicked");
  }

  void updateUser() {
    updatedUser = User.fromMap(userMap);
    FirebaseHelper.sendUserToFb(updatedUser);
  }

  void checkThenUpdateUser() {
    if(_hobbies.isEmpty){
      // Toast on hobbies
    }else if(_bio.isEmpty){
      // Toast on bio
    }else if(_livingArea.isEmpty){
      // Toast on livingArea
    }
    userMap['hobbies'] = _hobbies;
    userMap['bio'] = _bio;
    userMap['livingArea'] = _livingArea;
    userMap['workArea'] = _workArea;
    userMap['academicInstitution'] = _academicInstitution;
    userMap['fieldOfStudy'] = _fieldOfStudy;
    userMap['smoking'] = _smoking;
    updateUser();
  }

  void savePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(MAP_TYPE_KEY, defaultMapType);
  }

  Future<void> _logOut() async {
    await FacebookAuth.instance.logOut();
//    _accessToken = null;
//    _userData = null;
    setState(() {
      this.widget.callback(0, userMap, otherInfo, MapView_index);
    });
  }

}





