//FLUTTER
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

  bool inited = false;
  bool _notification = false;
  bool _isExpandedAbout = false, _isExpandedGetHelp = false;
  double _radius = 14.0;
  String userName = userMap['name'].toString();

  @override
  Widget build(BuildContext context) {
    if(!inited){
      _init();
    }
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
                accentColor: Colors.amberAccent
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 125,),
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
                                alignment: Alignment(-1.313, 0),
                                child: Text("Notifications")
                            ),
                            leading: Icon(Icons.notifications),
                            trailing: Switch.adaptive(
                                inactiveTrackColor: Colors.grey.withOpacity(0.4),
                                inactiveThumbColor: Colors.grey[400]!.withOpacity(0.4),
                                activeColor: Colors.green.withOpacity(0.75),
                                activeTrackColor: Colors.green.withOpacity(0.6),
                                value: _notification,
                                onChanged: (val){
                                  setState(() {
                                    _notification =val;
                                  });
                                }
                            ),
                          ),
                        )
                    ),
                  ),  //  Notifications
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
                              child: Text(userName)
                          ),
                          leading: Icon(Icons.account_circle),
                          trailing: Icon(Icons.edit),
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
                              child: Text("Delete All Locations")
                          ),
                          leading: Icon(Icons.delete_sharp),
                        ),
                      ),
                    ),
                  ),  //  Delete All Locations
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
                              child: Text("Delete All Locations")
                          ),
                          leading: Icon(Icons.delete_sharp),
                        ),
                      ),
                    ),
                  ),  //  Temp
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
                              child: Text("Delete All Locations")
                          ),
                          leading: Icon(Icons.delete_sharp),
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
            height: 110,
            child: MyAppBar("Setting",funcAction,height: 110,)
          ),
        ],
      ),
    );
  }

  _init(){

  }

  funcAction(){
    print("action clicked");
  }

}





