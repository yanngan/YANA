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

//  Callback function related - See main.dart callback section for more info about it
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
  /// [_paddingRight], [_paddingLeft] - Column of user info sides padding
  /// [userName] - The name of the user, we got it from Facebook
  /// [_toggleSelectionsMap] - a list of booleans that represent the map default views
  /// [_toggleSelectionsChatsEvents] - a list of booleans that represent the chats / events default page
  /// @_controller'Name' - [TextField] controllers in order to get all the text changes
  /// [_hobbies], [_bio], [_livingArea], [_workArea], [_academicInstitution], [_fieldOfStudy], [_smoking] - User properties field in order to save them later
  bool _notification = userMap['notifications'].toString().toLowerCase() == 'true';
  bool _isExpandedAbout = false, _isExpandedGetHelp = false, _isExpandedAccount = false;
  double _radius = 14.0, _paddingRight = 30.0, _paddingLeft = 25.0;
  String userName = userMap['name'].toString();
  late List<bool> _toggleSelectionsMap, _toggleSelectionsChatsEvents;
  late TextEditingController _controllerName;
  late TextEditingController _controllerEmail;
  late TextEditingController _controllerSex;
  late TextEditingController _controllerBirthday;
  late TextEditingController _controllerAgeRange;
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
  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'yana.dev.team@gmail.com',
      queryParameters: {
        'subject': userMap['name'].toString() + ", " + 'מעוניין לדווח על תקלה',
        'body': 'בעבור התמיכה של יאנה,\nברצוני לדווח על התקלה הבאה:\n',
//        'attachments': 'assets/yana_logo.png',
      }
  );

  @override
  void initState() {
    _toggleSelectionsMap = [!defaultMapType, defaultMapType];
    _toggleSelectionsChatsEvents = [whichPage, !whichPage];
    _updateControllers();
    super.initState();
  }

  /// Initialize all the controllers with default text from the user object
  void _updateControllers() {
    _controllerName = new TextEditingController(text: userMap['name'].toString());
    _controllerEmail = new TextEditingController(text: userMap['email'].toString());
    _controllerSex = new TextEditingController(text: userMap['gender'].toString());
    _controllerBirthday = new TextEditingController(text: userMap['birthday'].toString());
    _controllerAgeRange = new TextEditingController(text: userMap['age_range'].toString());
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
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                              isSelected: _toggleSelectionsMap,
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
                                  for(int i = 0; i < _toggleSelectionsMap.length; i++){
                                    _toggleSelectionsMap[i] = !_toggleSelectionsMap[i];
                                  }
                                  // _toggleSelections[0] = Normal
                                  // _toggleSelections[1] = Hybrid
                                  if(_toggleSelectionsMap[0]){
                                    defaultMapType = false;
                                  }else if(_toggleSelectionsMap[1]){
                                    defaultMapType = true;
                                  }
                                  saveDefaultMapPreference();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),  //  Map Default State
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
                                alignment: Alignment(50.85, 0),
                                child: AutoSizeText("עמוד אירועים וצ'אטים", maxLines: 2,)
                            ),
                            leading: Icon(Icons.map),
                            trailing: ToggleButtons(
                              isSelected: _toggleSelectionsChatsEvents,
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
                                      Icon(Icons.chat),
                                      Text("צ'אטים", style: TextStyle(fontSize: 12),),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      Icon(Icons.event),
                                      Text("אירועים", style: TextStyle(fontSize: 12),),
                                    ],
                                  ),
                                ),
                              ],
                              onPressed: (int index){
                                setState(() {
                                  for(int i = 0; i < _toggleSelectionsChatsEvents.length; i++){
                                    _toggleSelectionsChatsEvents[i] = !_toggleSelectionsChatsEvents[i];
                                  }
                                  // _toggleSelections[0] = Normal
                                  // _toggleSelections[1] = Hybrid
                                  if(_toggleSelectionsChatsEvents[0]){
                                    whichPage = true;
                                  }else if(_toggleSelectionsChatsEvents[1]){
                                    whichPage = false;
                                  }
                                  saveDefaultChatsEventsPreference();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),  //  Chats / Events default page
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
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: ListTile(
                                      title: Align(
                                          alignment: Alignment(1.153, 0),
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListTile(
                              onTap: () {
                                launch(_emailLaunchUri.toString().replaceAll("+", " "));
                              },
                              title: Align(
                                  alignment: Alignment(1.153, 0),
                                  child: Text("דיווח על תקלה")
                              ),
                              leading: Icon(Icons.report_problem),
                            ),
                          )
                      ),
                    ),  //  Report An Issue
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
                              onTap: () {},
                              title: Align(
                                  alignment: Alignment(1.153, 0),
                                  child: Text("קרדיט למפתחים")
                              ),
                              leading: Icon(Icons.developer_mode, color: Color(0xFF6b81ae),),
                            ),
                          )
                      ),
                    ),  //  Developers Credits
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(_radius)),
                        child: ExpansionPanelList(
                          elevation: 0,
                          expandedHeaderPadding: EdgeInsets.all(0.0),
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isExpandedAccount = !_isExpandedAccount;
                            });
                          },
                          animationDuration: Duration(milliseconds: 300),
                          children: [
                            ExpansionPanel(
                              canTapOnHeader: true,
                              isExpanded: _isExpandedAccount,
                              backgroundColor: Colors.amber[300]!.withOpacity(0.8),
                              headerBuilder: (context, isOpen){
                                return Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: ListTile(
                                      title: Align(
                                          alignment: Alignment(1.123, 0),
                                          child: Text("חשבון")
                                      ),
                                      leading: Icon(Icons.switch_account),
                                    ),
                                  ),
                                );
                              },
                              body: Column(
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
                              ),//  Delete: All Chats / All Events / Account
                            )
                          ],
                        ),
                      ),
                    ),  //  All Account Deletion Related
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
              height: appBarHeight,
              child: MyAppBar("הגדרות", null, height: appBarHeight,)
            ),
          ],
        ),
      ),
    );
  }

  /// [userPhotoURL] - User profile photo
  /// [_h] - Height of user editing area
  /// [_w] - Width of user editing area
  /// [textFieldsHeight] - Max height of each [TextField]
  void _openUserEditSheet(){
    String userPhotoURL = "";
    double _h = ((MediaQuery.of(context).size.height / 3) * 1.75);
    double _w = ((MediaQuery.of(context).size.width / 2) * 1.45);
    double textFieldsHeight = 35.0;
    userPhotoURL = userMap["fbPhoto"].toString();
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
                                        "שם",
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
                                      controller: _controllerName,
                                      onChanged: (_text){
                                        setState(() {});
                                      },
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'שם',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),  //  Name - Read Only
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        "אימייל",
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
                                      controller: _controllerEmail,
                                      onChanged: (_text){
                                        setState(() {});
                                      },
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'אימייל',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),  //  Email - Read Only
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
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
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: _paddingLeft),
                                    child: TextField(
                                      controller: _controllerSex,
                                      onChanged: (_text){
                                        setState(() {});
                                      },
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
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
                            ),  //  Gender - Read Only
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        "יום הולדת",
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
                                      controller: _controllerBirthday,
                                      onChanged: (_text){
                                        setState(() {});
                                      },
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black26),
                                        ),
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'יום הולדת',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),  //  Birthday - Read Only
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        "גיל",
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
                                      controller: _controllerAgeRange,
                                      onChanged: (_text){
                                        setState(() {});
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
                                        hintText: 'גיל',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),  //  Age
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
                            ),  //  Hobbies
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
                            ),  //  Bio
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
                            ),  //  Living Area
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
                            ),  //  Work Area
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
                            ),  //  Academic Institution
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
                            ),  //  Field Of Study
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
                            ),  //  Smoking
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
                            ),  //  Sign Up Date
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
  appBarTapFunction(){
    print("action clicked");
  }

  /// Method in order to update the user in our database
  void updateUser() {
    updatedUser = User.fromMap(userMap);
    FirebaseHelper.sendUserToFb(updatedUser);
  }

  /// Method to check that the user didn't leave any required area empty
  void checkThenUpdateUser() {
    if(_hobbies.isEmpty){
      Fluttertoast.showToast(
          msg: "תחביבים לא יכול להישאר ריק",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0
      );
    }else if(_bio.isEmpty){
      Fluttertoast.showToast(
          msg: "תמצית לא יכול להישאר ריק",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0
      );
    }else if(_livingArea.isEmpty){
      Fluttertoast.showToast(
          msg: "איזור מגורים לא יכול להישאר ריק",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0
      );
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

  /// Method to save user default map preferences
  void saveDefaultMapPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(MAP_TYPE_KEY, defaultMapType);
  }

  /// Method to save user default map preferences
  void saveDefaultChatsEventsPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(CHATS_EVENTS_TYPE_KEY, whichPage);
  }

  /// Method to log the user out the application ( without closing it )
  Future<void> _logOut() async {
    await FacebookAuth.instance.logOut();
//    _accessToken = null;
//    _userData = null;
    setState(() {
      this.widget.callback(0, userMap, otherInfo, MapView_index);
    });
  }

}





