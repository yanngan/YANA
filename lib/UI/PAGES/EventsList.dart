import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yana/UI/WIDGETS/EmptyScreen.dart';
import 'package:yana/UI/WIDGETS/allWidgets.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';
import 'Utilities.dart';

class EventsList extends StatefulWidget {

  @override
  _EventsListState createState() => _EventsListState();

}

class _EventsListState extends State<EventsList> {

  /// [_initDone] - [bool] flag representing if the initializing process is finished or not
  /// [listEvents] - [List] of [Events] holding all the events currently active
  /// [placeByEvents] - [Map] of the pairs key [String] : value [Place] holding all the places of the events
  bool _initDone = false;
  List<Events> listEvents = [];
  Map<String, Place> placeByEvents = {};

  @override
  Widget build(BuildContext context) {
    if (!_initDone) {
      _init();
    }
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.amber,
              child: _initDone
                ? (listEvents.length == 0
                    ? EmptyScreen(
                        maxLines: 3,
                        text:
                            "לא קיימים הקשורים לחשבונך ברגע זה, עליך להירשם או לבקש להצטרף לאירוע")
                    : ListView.builder(
                        itemCount: listEvents.length,
                        itemBuilder: (BuildContext context, int index) {
                          if(index == (listEvents.length - 1)){
                            return Padding(
                              padding: EdgeInsets.only(bottom: 40.0),
                              child: _createRow(index),
                            );
                          }else{
                            return _createRow(index);
                          }
                        }
                      )
                  )
                : SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.0,
                    ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  /// Method to initialize all the variables and fields we need for this page
  _init() {
    Logic.getAllUserEvent().then((value) async {
      listEvents = value;
      for (var oneEvents in listEvents) {
        var temp = await Logic.getPlaceById(oneEvents.placeID);
        // ignore: unnecessary_null_comparison
        if (temp == null) {
          listEvents.remove(oneEvents);
          continue;
        }
        placeByEvents[oneEvents.eventID] = temp;
        if (oneEvents.userID != userMap['userID']!) {
          oneEvents.statusForUser =
              await Logic.getStatusEventForUser(oneEvents.eventID);
        }
      }
      setState(() {
        _initDone = true;
      });
    });
  }

  /// Each row of the [ListView] of events is created using this function
  /// [index] - the index of [listEvents], in order to get the event we want
  _createRow(int index) {
    String textButton = "", _userName = listEvents[index].userName;
    if(_userName == userMap['name'].toString()){
      if(userMap['gender'].toString() == "female"){
        _userName = "את";
      }else{
        _userName = "אתה";
      }
    }
    var actionButton;
    if (listEvents[index].userID == userMap['userID']!) {
      textButton = "ערוך";
      actionButton = () async {
        await MapLogic.addEditSeePoints(context, 'edit',
          theEvent: listEvents[index],
          thePlace: placeByEvents[listEvents[index].eventID],
          totallyPop: true
        );
        setState(() {
          _initDone = false;
        });
      };
    } else {
      if (listEvents[index].statusForUser == Events.ASK) {
        textButton = "טרם אושר";
        actionButton = () {
          _makeToast("בקשתך נשלחה, וממתינה לאישור מארגן האירוע", Colors.pink);
        };
      } else if (listEvents[index].statusForUser == Events.GOING) {
        textButton = "בטל הגעה";
        actionButton = () {
          userCancelation(listEvents[index]);
        };
      } else {
        textButton = "שגיאה";
        actionButton = () {
          _makeToast("אנו מתנצלים אירעה שגיאה במערכת", Colors.red);
        };
      }
    }
    var theButton = Padding(
        padding: EdgeInsets.fromLTRB(2, 0, 0, 15),
        child: InkWell(
            onTap: actionButton,
            child: Neumorphism(
              null,
              null,
              Text(textButton),
              type: NeumorphismOuter,
              radius: 32.0,
              alignment: Alignment.centerLeft,
              color: Colors.amber,
            )));

    return Container(
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          begin: Alignment(-1, -1),
          end: Alignment(-1, -0.9),
          colors: [Colors.black12, Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        (placeByEvents[listEvents[index].eventID]!).placeIcon),
                    radius: 35.0,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                theButton,
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${(placeByEvents[listEvents[index].eventID]!).name}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        " - ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "${(placeByEvents[listEvents[index].eventID]!).city}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),  //  Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "$_userName",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        " : ",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "יוצר האירוע",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),  //  Creator Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${listEvents[index].startEstimate}",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        " : ",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "מתי",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),  //  Time
                  Text(
                    "כמות משתתפים מקסימלית : ${(listEvents[index].maxNumPeople)}",
                    style: TextStyle(fontSize: 15),
                  ),  //  Max participants
                  Text(
                    "כמות משתתפים נוכחית : ${listEvents[index].curNumPeople}",
                    style: TextStyle(fontSize: 15),
                  ),  //  Current participants
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible (
                        child: InkWell(
                          onTap: () {
                            _launchUrl(
                                "${(placeByEvents[listEvents[index].eventID]!).googleMapLink}");
                          },
                          child: Text(
                            "${(placeByEvents[listEvents[index].eventID]!).address}",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      Text(
                        " : ",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "כתובת",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),  //  Address
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          "${listEvents[index].note}",
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.end,
//                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        " : ",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "הערות",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),  //  Notes
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Callback function that gets called when the user opt to cancel his attendance to an event
  /// [event] - The [Events] representing the event the user wish to cancel attendance to
  userCancelation(Events event) async {
    if (await Logic.userCancelation(userMap['userID']!, event)) {
      _makeToast("בוצע ביטול", Colors.pink);
    } else {
      _makeToast("מתנצלים אירעה שגיאה, נסה שנית מאוחר יותר", Colors.pink);
    }
    setState(() {
      _initDone = false;
    });
  }

  /// Create a toast message
  /// [str] - Toast text
  /// [theColor] - Toast text color
  _makeToast(String str, var theColor) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: theColor,
        textColor: Colors.amber,
        fontSize: 16.0);
  }

  /// Method to launch a url
  /// [url] - desired url to launch using the [launch] method
  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      _makeToast("סורי - הקישור לא עובד :(", Colors.pink);
    }
  }

}


