//FLUTTER
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yana/UI/PAGES/Utilities.dart';
//WIDGETS
import '../WIDGETS/allWidgets.dart';

class Settings extends StatefulWidget {

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
  bool _notification = false, _isExpandedAbout = false, _isExpandedGetHelp = false;
  double _radius = 14.0;
  String userName = userMap['name'].toString();
  late List<bool> _toggleSelections;
  TextEditingController _controllerSex = new TextEditingController();
  TextEditingController _controllerHobbies = new TextEditingController();
  TextEditingController _controllerBio = new TextEditingController();
  TextEditingController _controllerLivingArea = new TextEditingController();
  TextEditingController _controllerWorkArea = new TextEditingController();
  TextEditingController _controllerAcademicInstitution = new TextEditingController();
  TextEditingController _controllerFieldOfStudy = new TextEditingController();
  TextEditingController _controllerSmoking = new TextEditingController();
  TextEditingController _controllerSignUpDate = new TextEditingController();

  @override
  void initState() {
    _toggleSelections = [true, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
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
                          child: Directionality(
                            textDirection: TextDirection.rtl,
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
                                        });
                                      }
                                  ),
                                  GestureDetector(
                                    onTap: (){},
                                    child: Icon(Icons.notifications_outlined, color: Colors.pink[600], size: 27.0,)
                                  ),
                                ],
                              ),
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
                                alignment: Alignment(-1.193, 0),
                                child: Text(userName)
                            ),
                            leading: Icon(Icons.account_circle),
                            trailing: Icon(Icons.edit),
                          ),
                        ),
                      ),
                    ),
                  ),  //  User Profile
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
                              alignment: Alignment(-1.193, 0),
                              child: Text("Auto Filters")
                          ),
                          leading: Icon(Icons.filter_list),
                          trailing: Icon(Icons.add_box),
                        ),
                      ),
                    ),
                  ),  //  Auto Filters
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
                                                alignment: Alignment(-1.193, 0),
                                                child: Text("About")
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
                                    alignment: Alignment(-1.193, 0),
                                    child: Text("Privacy Policy")
                                ),
                                leading: Icon(Icons.privacy_tip),
                                trailing: Icon(Icons.keyboard_arrow_down),
                              ),
                            ),  //  Privacy Policy
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ListTile(
                                title: Align(
                                    alignment: Alignment(-1.193, 0),
                                    child: Text("Terms of Use")
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
                                        alignment: Alignment(-1.113, 0),
                                        child: Text("Get Help")
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
                                    title: Align(
                                      alignment: Alignment(-1.1, 0),
                                      child: Text("Call a Specialist")
                                    ),
                                    leading: Icon(Icons.call),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                  child: ListTile(
                                    title: Align(
                                      alignment: Alignment(-1.1, 0),
                                      child: Text("Text a Psychologist")
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
                          title: Align(
                              alignment: Alignment(-1.18, 0),
                              child: AutoSizeText("Map Default View", maxLines: 2,)
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
                                    Text("Normal", style: TextStyle(fontSize: 12),),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.satellite),
                                    Text("Satellite", style: TextStyle(fontSize: 12),),
                                  ],
                                ),
                              ),
                            ],
                            onPressed: (int index){
                              setState(() {
//                                _toggleSelections[index] = !_toggleSelections[index];
                                for(int i = 0; i < _toggleSelections.length; i++){
                                  _toggleSelections[i] = !_toggleSelections[i];
                                }
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
                              alignment: Alignment(-1.118, 0),
                              child: Text("Delete All Chats")
                          ),
                          leading: Icon(Icons.delete_outline),
                        ),
                      ),
                    ),
                  ),  //  Delete All Chats
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
                              alignment: Alignment(-1.18, 0),
                              child: Text("Delete All Events")
                          ),
                          leading: Icon(Icons.delete_sharp),
                        ),
                      ),
                    ),
                  ),  //  Delete All Events
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
                              alignment: Alignment(-1.18, 0),
                              child: Text("Delete My Account")
                          ),
                          leading: Icon(Icons.delete_forever),
                        ),
                      ),
                    ),
                  ),  //  Temp
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 10.0, bottom: 70.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber[300]!.withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(_radius)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListTile(
                          title: Align(
                              alignment: Alignment(-1.065, 0),
                              child: Text("Sign-out")
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
        return Container(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              /// Not for this time period
                              /// Do not delete the Auto-Filters widget comment
//                              Padding(
//                                padding: const EdgeInsets.only(top: 42.35, bottom: 10.0),
//                                child: SizedBox(
//                                  height: textFieldsHeight,
//                                  width: _leftSideWidth,
//                                  child: Align(
//                                    alignment: Alignment.centerLeft,
//                                    child: AutoSizeText(
//                                      "Sex",
//                                      maxLines: 1,
//                                    ),
//                                  ),
//                                ),
//                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: SizedBox(
                                  height: textFieldsHeight,
                                  width: _leftSideWidth,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Hobbies",
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: SizedBox(
                                  height: textFieldsHeight,
                                  width: _leftSideWidth,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Bio",
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: SizedBox(
                                  height: textFieldsHeight,
                                  width: _leftSideWidth,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Living Area",
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: SizedBox(
                                  height: textFieldsHeight,
                                  width: _leftSideWidth,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Work Area",
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: SizedBox(
                                  height: textFieldsHeight,
                                  width: _leftSideWidth,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Academic Institution",
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: SizedBox(
                                  height: textFieldsHeight,
                                  width: _leftSideWidth,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Field Of Study",
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: SizedBox(
                                  height: textFieldsHeight,
                                  width: _leftSideWidth,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Smoking",
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 75.0),
                                child: SizedBox(
                                  height: textFieldsHeight,
                                  width: _leftSideWidth,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Sign-Up Date",
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 42.35, bottom: 10.0),
                                child: Container(
                                  height: textFieldsHeight,
                                  width: _rightSideWidth,
                                  child: TextField(
                                    controller: _controllerSex,
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
                                      hintText: 'Sex',
                                    ),
                                  ),
                                ),
                              ),  //  Sex
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Container(
                                  height: textFieldsHeight,
                                  width: _rightSideWidth,
                                  child: TextField(
                                controller: _controllerHobbies,
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
                                      hintText: 'Hobbies',
                                    ),
                                  ),
                                ),
                              ),  //  Hobbies
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Container(
                                  height: textFieldsHeight,
                                  width: _rightSideWidth,
                                  child: TextField(
                                controller: _controllerBio,
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
                                      hintText: 'Bio',
                                    ),
                                  ),
                                ),
                              ),  //  Bio
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Container(
                                  height: textFieldsHeight,
                                  width: _rightSideWidth,
                                  child: TextField(
                                controller: _controllerLivingArea,
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
                                      hintText: 'Living Area',
                                    ),
                                  ),
                                ),
                              ),  //  Living Area
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Container(
                                  height: textFieldsHeight,
                                  width: _rightSideWidth,
                                  child: TextField(
                                controller: _controllerWorkArea,
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
                                      hintText: 'Work Area',
                                    ),
                                  ),
                                ),
                              ),  //  Work Area
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Container(
                                  height: textFieldsHeight,
                                  width: _rightSideWidth,
                                  child: TextField(
                                controller: _controllerAcademicInstitution,
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
                                      hintText: 'Academic Institution',
                                    ),
                                  ),
                                ),
                              ),  //  Academic Institution
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Container(
                                  height: textFieldsHeight,
                                  width: _rightSideWidth,
                                  child: TextField(
                                controller: _controllerFieldOfStudy,
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
                                      hintText: 'Field Of Study',
                                    ),
                                  ),
                                ),
                              ),  //  Field Of Study
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Container(
                                  height: textFieldsHeight,
                                  width: _rightSideWidth,
                                  child: TextField(
                                controller: _controllerSmoking,
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
                                      hintText: 'Smoking',
                                    ),
                                  ),
                                ),
                              ),  //  Smoking
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 75.0),
                                child: Container(
                                  height: textFieldsHeight,
                                  width: _rightSideWidth,
                                  child: TextField(
                                controller: _controllerSignUpDate,
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
                                      hintText: 'Sign-Up Date',
                                    ),
                                  ),
                                ),
                              ),  //  Sign-Up Date
                            ],
                          ),
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
                                  child: Text("Discard", style: TextStyle(fontSize: 18.0),)
                                )
                            ),
                            type: NeumorphismOuterChip,
                            radius: 32.0,
                            alignment: Alignment.center,
                            color: bodyColor[600]!.withOpacity(0.95),
                          ),
                          Neumorphism(
                            _w / 2.25,
                            41.0,
                            Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Save", style: TextStyle(fontSize: 18.0),)
                                )
                            ),
                            type: NeumorphismOuterChip,
                            radius: 32.0,
                            alignment: Alignment.center,
                            color: bodyColor[600]!.withOpacity(0.95),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),  //  Buttons
            ],
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

}





