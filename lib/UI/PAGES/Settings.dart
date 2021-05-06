//FLUTTER
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//WIDGETS
import '../WIDGETS/allWidgets.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();

}

class _SettingsState extends State<Settings> {

  bool inited = false;
  bool _notification = false;

  @override
  Widget build(BuildContext context) {
    if(!inited){
      _init();
    }
    return Scaffold(
      backgroundColor: Colors.amber,
//      appBar: MyAppBar("Setting",funcAction,height: 120,),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 120,),
                Text("Group 1", style: TextStyle(decoration: TextDecoration.underline, fontSize: 30),),
                Container(
                  height: 300,
                  child: Center(child: Padding(
                    padding: const EdgeInsets.only(top: 8,right: 8,left: 8,bottom: 8),
                    child: Container(
                        constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(
                          color: Colors.amber[300],
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Text("Settings"),
                              Switch(
                                  value: _notification,
                                  onChanged: (val){setState(() { _notification =val;});}
                              )
                            ],
                          ),
                        )
                    ),
                  )),
                ),
                Text("Group 2", style: TextStyle(decoration: TextDecoration.underline, fontSize: 30),),
                Container(
                  height: 300,
                  child: Center(child: Padding(
                    padding: const EdgeInsets.only(top: 20,right: 8,left: 8,bottom: 60),
                    child: Container(
                        constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(
                          color: Colors.amber[300],
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Text("Settings"),
                              Switch(
                                  value: _notification,
                                  onChanged: (val){setState(() { _notification =val;});}
                              )
                            ],
                          ),
                        )
                    ),
                  )),
                ),
                Text("Group 3", style: TextStyle(decoration: TextDecoration.underline, fontSize: 30,),),
                Container(
                  height: 300,
                  child: Center(child: Padding(
                    padding: const EdgeInsets.only(top: 20,right: 8,left: 8,bottom: 60),
                    child: Container(
                        constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(
                          color: Colors.amber[300],
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Text("Settings"),
                              Switch(
                                  value: _notification,
                                  onChanged: (val){setState(() { _notification =val;});}
                              )
                            ],
                          ),
                        )
                    ),
                  )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            child: MyAppBar("Setting",funcAction,height: 120,)
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





