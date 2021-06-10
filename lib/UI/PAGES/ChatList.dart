import 'package:flutter/material.dart';
import 'package:yana/UI/WIDGETS/EmptyScreen.dart';
import 'package:yana/UI/WIDGETS/allWidgets.dart';
import 'package:yana/UX/LOGIC/CLASSES/allClasses.dart';

import 'Utilities.dart';

// ignore: must_be_immutable
class ChatList extends StatefulWidget {

  Map<String, String> otherInfo = new Map<String, String>();
  final Function callback;
  ChatList(this.callback);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  String _userID = userMap["userID"].toString();
  Map<dynamic, dynamic> _senders = {};
  bool _isItEmpty = true;

  @override
  void initState() {
    super.initState();
    initChatsList();
   // FirebaseHelper.createNewChat(_userID, userMap["name"].toString(), "4520991924611511", "Yann Moshe Ganem");
   // FirebaseHelper.createNewChat(_userID, userMap["name"].toString(), "01234567891234567", "Adriana Lima");
//    FirebaseHelper.createNewChat(_userID, "Lidor Name", "DavidID", "David Name");
//    FirebaseHelper.createNewChat(_userID, "Lidor Name", "SvetlanaID", "Svetlana Name");
//    FirebaseHelper.createNewChat(_userID, "Lidor Name", "DanaID", "Dana Name");
//    FirebaseHelper.createNewChat(_userID, "Lidor Name", "ZevelID", "Zevel Name");
  }

  void initChatsList() async {
    _senders = await FirebaseHelper.getSendersInfo(_userID);
    setState(() {
      _senders; // TODO at the end of project - check for better way
      _isItEmpty = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    double freeScreenHeight = (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 80);
    print(_senders.length == 0);
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          Expanded(
            child: !_isItEmpty
                ? Container(
              height: freeScreenHeight,
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 2);
                },
                itemCount: _senders.length,
                itemBuilder: (context, index){
                  String key = _senders.keys.elementAt(index);  // key = Other ID
                  return GestureDetector(
                    onTap: (){
                      this.widget.otherInfo = {"name": _senders[key], "userID" : key};
                      setState(() {
                        //                this.widget.callback(4, userMap, this.widget.otherInfo, Chat_index);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(this.widget.otherInfo)));
                      });
                    },
                    child: Neumorphism(
                      null,
                      75.0,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 2.5),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  _senders[key],
                                  style: TextStyle(fontFamily: 'FontSkia', fontSize: 24.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                      type: NeumorphismInner,
                      radius: 0.0,
                      alignment: Alignment.center,
                      color: bodyColor
                    ),
                  );
                },
              ),
            )
                : EmptyScreen(text: "אין צ'אטים פעילים כרגע"),
          ),
          SizedBox(height: 50,),
        ],
      ),
    );
  }

}



















