import 'package:flutter/material.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/CLASSES/allClasses.dart';
import 'AllPage.dart';

class ChatsAndEvents extends StatefulWidget {
  @override
  _ChatsAndEventsState createState() => _ChatsAndEventsState();
}

class _ChatsAndEventsState extends State<ChatsAndEvents> {
  bool whichPage = false;
  @override
  Widget build(BuildContext context) {
    var screen;
    var theBackgroundColor;
    if (whichPage) {
      screen = ChatList();
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
            height: 130,
            decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(1000),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    child: Text(
                      "אירועים",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    onPressed: () {
                      switchPage('listEvent');
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            whichPage ? Colors.pinkAccent : Colors.pink[700]),
                        shadowColor: MaterialStateProperty.all(Colors.grey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(18.0),
                                      bottomLeft: Radius.circular(18.0),
                                    ),
                                    side: BorderSide(color: Colors.red))))),
                TextButton(
                    child: Text(
                      "צ'אטים",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    onPressed: () {
                      switchPage('chat');
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            whichPage ? Colors.pink[700] : Colors.pinkAccent),
                        shadowColor: MaterialStateProperty.all(Colors.grey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(18.0),
                                      bottomRight: Radius.circular(18.0),
                                    ),
                                    side: BorderSide(color: Colors.red))))),
              ],
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

  switchPage(String page) {
    if ((page == 'chat' && whichPage) || (page == 'listEvent' && !whichPage)) {
      //do nothing
      return;
    }
    print("hello");
    setState(() {
      whichPage = !whichPage;
    });
  }
}
