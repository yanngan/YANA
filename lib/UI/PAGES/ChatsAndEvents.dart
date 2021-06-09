import 'package:flutter/material.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/CLASSES/Message.dart';
import 'package:yana/UX/LOGIC/CLASSES/allClasses.dart';
import 'Utilities.dart';

class ChatsAndEvents extends StatefulWidget {

//  Callback function related - See main.dart callback section for more info about it
  final Function callback;
  bool goToChats;
  ChatsAndEvents(this.callback,{this.goToChats = false});

  @override
  _ChatsAndEventsState createState() => _ChatsAndEventsState();
}

/// [_whichPage] - determine which page is selected ( Events / Chats )
class _ChatsAndEventsState extends State<ChatsAndEvents> {

  bool _whichPage = whichPage;

  @override
  Widget build(BuildContext context) {
    var screen;
    var theBackgroundColor;
    if (_whichPage || widget.goToChats) {
      screen = ChatList(this.widget.callback);
      theBackgroundColor = Colors.amber;
    } else {
      screen = EventsList();
      theBackgroundColor = Colors.amber;
    }
    return Scaffold(
      backgroundColor: theBackgroundColor,
      appBar: null,
      body: Column(
        children: [
          Container(
            height: appBarHeight,
            decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(1000),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      "אירועים",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    onPressed: () {
                      switchPage('listEvent');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          _whichPage ? Colors.pinkAccent : Colors.pink[700]),
                      shadowColor: MaterialStateProperty.all(Colors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18.0),
                            bottomLeft: Radius.circular(18.0),
                          ),
                          side: BorderSide(color: Colors.red)
                        )
                      )
                    )
                  ),
                  TextButton(
                    child: Text(
                      "צ'אטים",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    onPressed: () {
                      switchPage('chat');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          _whichPage ? Colors.pink[700] : Colors.pinkAccent),
                      shadowColor: MaterialStateProperty.all(Colors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18.0),
                            bottomRight: Radius.circular(18.0),
                          ),
                          side: BorderSide(color: Colors.red)
                        )
                      )
                    )
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              //height: MediaQuery. of(context). size. height-115,
              child: screen,
            ),
          ),
        ],
      ),
    );
  }

  /// Method in order to switch between pages ( Events / Chats )
  switchPage(String page)async {
    if ((page == 'chat' && _whichPage) || (page == 'listEvent' && !_whichPage)) {
      //do nothing
      return;
    }
    // print("hello");
    setState(() {
      _whichPage = !_whichPage;
    });
  }
}
