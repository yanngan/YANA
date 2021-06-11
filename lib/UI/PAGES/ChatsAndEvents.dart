import 'package:flutter/material.dart';
import 'Utilities.dart';

// ignore: must_be_immutable
class ChatsAndEvents extends StatefulWidget {

  /// [goToChats] - [bool] flag to determine to go to the chat page
  bool goToChats;
//  Callback function related - See main.dart callback section for more info about it
  final Function callback;
  // constructor
  ChatsAndEvents(this.callback,{this.goToChats = false});

  @override
  _ChatsAndEventsState createState() => _ChatsAndEventsState();

}

class _ChatsAndEventsState extends State<ChatsAndEvents> {

  /// [_whichPage] - determine which page is selected ( Events / Chats )
  bool _whichPage = whichPage;

  /// [screen]  - Determine which screen the user will see
  /// [theBackgroundColor]  - Entire page background color
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
  /// [page] - A [String] representing the page we want to show / see
  switchPage(String page) async {
    if ((page == 'chat' && _whichPage) || (page == 'listEvent' && !_whichPage)) {
      return; // do nothing
    }
    setState(() {
      _whichPage = !_whichPage;
    });
  }
}
