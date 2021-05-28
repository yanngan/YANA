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
                    child: Text("אירועים",style: TextStyle(fontSize: 30),),
                    onPressed: switchPage,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(whichPage?Colors.pinkAccent:Colors.pink[700]),
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
                    onPressed: switchPage,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(whichPage?Colors.pink[700]:Colors.pinkAccent),
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
            Container(
              height: MediaQuery. of(context). size. height-200,
              child: screen,
            ),
          ],
        ),

      ),
    );
  }


  switchPage()async{
    print("hello");
    Place p1 = new Place("placeID11", "address", "phoneNumber", "representative", 14, "vibe", true,
        "openingHours", "yisrael name", 18, "webLink", "googleMapLink", "latitude", "longitude");
    FirebaseHelper.sendPlaceToFb(p1);
    Events e1 = new Events("eventID", "userID", "userName", "creationDate",
        true, "1997-03-03 11:22", "endEstimate", 7, 10, p1.placeID, "note");
    FirebaseHelper.sendEventToFb(e1);
    print("*******************************\n");

    // var events =await FirebaseHelper.getEventsByMaxCapacity(20);
    // print(events.length);
    // print("*******************************\n");
    //  var events =await FirebaseHelper.getEventsByName("yisrael name");
    // print(events);
    // print(events.length);
    print("*******************************\n");

    setState(() {
      whichPage = !whichPage;
    });
  }
}
