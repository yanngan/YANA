import 'package:flutter/material.dart';
import 'package:yana/UX/LOGIC/CLASSES/allClasses.dart';

import 'Utilities.dart';

class ChatList extends StatefulWidget {

  Map<String, String> otherInfo = new Map<String, String>();
  final Function callback;
  ChatList(this.callback);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  String _userID = "LidorID";//userMap["id"].toString();
  Map<dynamic, dynamic> _senders = {};

  @override
  void initState() {
    super.initState();
    initChatsList();
    FirebaseHelper.createNewChat(_userID, "Lidor Name", "YisraelID", "Yisrael Name");
  }

  void initChatsList() async {
    _senders = await FirebaseHelper.getSendersInfo(_userID);
    setState(() {
      _senders; // TODO at the end of project - check for better way
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.amber,
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 15);
          },
          itemCount: _senders.length,
          itemBuilder: (context, index){
            String key = _senders.keys.elementAt(index);  // key = Other ID
            return ElevatedButton(
              onPressed: (){
                this.widget.otherInfo = {"name": _senders[key], "id" : key};
                setState(() {
                  this.widget.callback(4, userMap, this.widget.otherInfo);
                });
              },
              child: Text(_senders[key])
            );
          },
      )
    );
  }
}




















