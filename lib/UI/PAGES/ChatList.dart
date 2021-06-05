import 'package:flutter/material.dart';
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

  String _userID = "LidorID";//userMap["id"].toString();  // TODO change before production
  Map<dynamic, dynamic> _senders = {};

  @override
  void initState() {
    super.initState();
    initChatsList();
//    FirebaseHelper.createNewChat(_userID, "Lidor Name", "YisraelID", "Yisrael Name");
//    FirebaseHelper.createNewChat(_userID, "Lidor Name", "DavidID", "David Name");
//    FirebaseHelper.createNewChat(_userID, "Lidor Name", "SvetlanaID", "Svetlana Name");
//    FirebaseHelper.createNewChat(_userID, "Lidor Name", "DanaID", "Dana Name");
//    FirebaseHelper.createNewChat(_userID, "Lidor Name", "ZevelID", "Zevel Name");
  }

  void initChatsList() async {
    _senders = await FirebaseHelper.getSendersInfo(_userID);
    setState(() {
      _senders; // TODO at the end of project - check for better way
    });
  }

  @override
  Widget build(BuildContext context) {

    double freeScreenHeight = (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 80);

    return Container(
      height: freeScreenHeight,
      decoration: BoxDecoration(
        color: Colors.amber,
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 15);
        },
        itemCount: _senders.length,
        itemBuilder: (context, index){
          String key = _senders.keys.elementAt(index);  // key = Other ID
          return GestureDetector(
            onTap: (){
              this.widget.otherInfo = {"name": _senders[key], "id" : key};
              setState(() {
                this.widget.callback(4, userMap, this.widget.otherInfo, Chat_index);
              });
            },
            child: Neumorphism(
                null,
                100.0,
                Text(_senders[key], style: TextStyle(fontFamily: 'FontSkia', fontSize: 24.0, fontWeight: FontWeight.w600),),
                type: NeumorphismInner,
                radius: 0.0,
                alignment: Alignment.center,
                color: bodyColor),
          );
        },
      ),
    );
  }

}



















