import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/CLASSES/allClasses.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';

class NotificationPage extends StatefulWidget {

  @override
  _NotificationPageState createState() => _NotificationPageState();

}

class _NotificationPageState extends State<NotificationPage> {

  /// [_initDone] - A boolean flag that represents that the [listNotification] has been initialized
  /// [listNotification] - A [List] of [MyNotification] representing all the current user related notifications
  bool _initDone = false;
  List<MyNotification> listNotification = [];

  @override
  Widget build(BuildContext context) {
    if(!_initDone){
      _init();
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.amber, //change your color here
        ),
        backgroundColor: Colors.pink,
      ),
      backgroundColor: Colors.amber,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: Colors.amber,
          child: _initDone?ListView.builder(
              itemCount: listNotification.length,
              itemBuilder: (BuildContext context, int index) {
                return _createRow(index);
              }
          ):SpinKitFadingCircle(
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ),
    );
  }

  /// Initialized the page + variables
  _init() async{
    listNotification = await Logic.getListNotification();
    setState(() {
      _initDone = true;
    });
  }

  /// Method that creates a row to the list of the notifications
  /// [index] - Represents the index of the list we want to create a row for
  _createRow(int index){
    print(listNotification[index]);
    switch(listNotification[index].type){
      case MyNotification.EVENTS_ASK_TO_JOIN: //MyNotification.EVENTS_ASK_TO_JOIN
        print("EVENTS_ASK_TO_JOIN");
        return _createAskToJoin(index);
      case MyNotification.EVENTS_ASK_TO_JOIN_BEEN_APPROVE://MyNotification.EVENTS_ASK_TO_JOIN_BEEN_APPROVE
        print("EVENTS_ASK_TO_JOIN_BEEN_APPROVE");
        return _createBeenApprove(index);
      case MyNotification.EVENTS_CHANGE://MyNotification.EVENTS_CHANGE
        print("EVENTS_CHANGE");
        return _createEventHaveChange(index);
    }
  }

  /// Method that create a row of type [MyNotification.EVENTS_ASK_TO_JOIN]
  /// [index] - Represents the index of the list we want to create a row for
  _createAskToJoin(int index){
    return Padding(
      padding: const EdgeInsets.only(top: 4,right: 4,left: 4),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.pink,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('בקשת הצטרפות לאירוע שטרם אישרת',style: TextStyle(fontSize: 20,color: Colors.white, ),textAlign: TextAlign.center,),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("צפה באירוע"),
                  onPressed: (){
                    seeEvents(index);
                  },
                ),
                ElevatedButton(
                  child: Text("צפה בפרופיל"),
                  onPressed: (){
                    seeProfile(index);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text("אישור"),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                      onPressed: (){
                        approveOrRejectRequestToJoinEvent(index,true);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text("דחייה"),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                      onPressed: (){
                        approveOrRejectRequestToJoinEvent(index,false);
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// Method that create a row of type [MyNotification.EVENTS_ASK_TO_JOIN_BEEN_APPROVE]
  /// [index] - Represents the index of the list we want to create a row for
  _createBeenApprove(int index){
    return Padding(
      padding: const EdgeInsets.only(top: 4,right: 4,left: 4),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.pink,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            //Text('Event - ${listEvents[index].eventID}'),
            Text('ברכות! בקשתך להצטרף לאירוע אושרה, כעת תוכל לשוחח עם מארגן האירוע בחלונית הצאט',style: TextStyle(fontSize: 20,color: Colors.white, ),textAlign: TextAlign.center,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("צפה באירוע"),
                  onPressed: (){
                    seeEvents(index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Method that create a row of type [MyNotification.EVENTS_CHANGE]
  /// [index] - Represents the index of the list we want to create a row for
  _createEventHaveChange(int index){
    return Padding(
      padding: const EdgeInsets.only(top: 4,right: 4,left: 4),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.pink,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            //Text('Event - ${listEvents[index].eventID}'),
            Text('מעדכנים אותך כי מנהל האירוע עדכן את האירוע שנרשמת אליו',style: TextStyle(fontSize: 20,color: Colors.white, ),textAlign: TextAlign.center,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("צפה באירוע"),
                  onPressed: (){
                    seeEvents(index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// [index] - Represents the index of the list we want to see the event for
  seeEvents(int index) async {
    var theEvents = await FirebaseHelper.getEventByID(listNotification[index].eventsID);
    if(theEvents == null){
      _makeToast('אירעה תקלה, נסה שנית מאוחר יותר',Colors.pink);
      return;
    }
    var thePlace = await FirebaseHelper.getPlaceByID(theEvents.placeID);
    MapLogic.addEditSeePoints(context,'see',theEvent: theEvents,thePlace: thePlace,totallyPop: true);
  }

  /// [index] - Represents the index of the list we want to see the profile for
  seeProfile(int index) async {
    _makeToast("שירות זה עוד לא נתמך לצערנו, עובדים על זה :)",Colors.pink); /// TODO - show pop up profile of other user ( Like current user in Settings.dart )
  }

  /// [index] - Represents the index of the list we want to approve / reject
  /// [approve] - A boolean flag that indicates if we need to approve or denied the request
  approveOrRejectRequestToJoinEvent(int index, bool approve) async {
    var theEvents = await FirebaseHelper.getEventByID(listNotification[index].eventsID);
    if(theEvents == null){
      _makeToast('אירעה תקלה, נסה שנית מאוחר יותר',Colors.pink);
      return;
    }
    Logic.approveOrRejectRequestToJoinEvent(listNotification[index].userID,theEvents,approve);
  }

  /// Creates a toast message with [str] text and [theColor] color
  _makeToast(String str, var theColor){
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: theColor,
        textColor: Colors.amber,
        fontSize: 16.0
    );
  }

}




















