import 'package:flutter/material.dart';
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
    if(whichPage){
      screen = ChatList();
    }
    else{
      screen = EventsList();
    }
    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: Column(
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text("מיקומים",style: TextStyle(fontSize: 30),),
                    onPressed: switchPage(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(whichPage?Colors.pinkAccent:Colors.pink),
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
                    child: Text("צ'אטים",style: TextStyle(fontSize: 30),),
                    onPressed: switchPage(),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(whichPage?Colors.pink:Colors.pinkAccent),
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
            screen,
          ],
        ),

      ),
    );
  }


  switchPage(){
    setState(() {
      whichPage = !whichPage;
    });
  }
}
