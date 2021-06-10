import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/CLASSES/allClasses.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';

import 'Utilities.dart';

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("התראות"),
          iconTheme: IconThemeData(
            color: Colors.amber, //change your color here
          ),
          backgroundColor: Colors.pink,
        ),
        backgroundColor: Colors.amber,
        body: Container(
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
      case MyNotification.EVENTS_ASK_TO_JOIN_BEEN_APPROVE: //MyNotification.EVENTS_ASK_TO_JOIN_BEEN_APPROVE
        return _createBeenApprove(index);
      case MyNotification.EVENTS_ASK_TO_JOIN: //MyNotification.EVENTS_ASK_TO_JOIN
        return _createAskToJoin(index);
      case MyNotification.EVENTS_CHANGE: //MyNotification.EVENTS_CHANGE
        return _createEventHaveChange(index);
    }
  }

  /// Method that create a row of type [MyNotification.EVENTS_ASK_TO_JOIN]
  /// [index] - Represents the index of the list we want to create a row for
  _createAskToJoin(int index){
    return Padding(
      padding: const EdgeInsets.only(top: 4,right: 4,left: 4),
      child: Wrap(
        children: [
          Container(
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
                    Text(listNotification[index].statusForUser!=1?'בקשת הצטרפות לאירוע שטרם אישרת':'בקשת הצטרפות לאירוע שכבר אישרת',style: TextStyle(fontSize: 20,color: Colors.white, ),textAlign: TextAlign.center,),
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
                        child: listNotification[index].statusForUser!=1?ElevatedButton(
                          child: Text("אישור"),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                          onPressed: (){
                            approveOrRejectRequestToJoinEvent(index,true);
                          },
                        ):SizedBox(height: 1,),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: listNotification[index].statusForUser!=1?ElevatedButton(
                          child: Text("דחייה"),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                          onPressed: (){
                            approveOrRejectRequestToJoinEvent(index,false);
                          },
                        ):SizedBox(height: 1,),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Method that create a row of type [MyNotification.EVENTS_ASK_TO_JOIN_BEEN_APPROVE]
  /// [index] - Represents the index of the list we want to create a row for
  _createBeenApprove(int index){
    return Padding(
      padding: const EdgeInsets.only(top: 4,right: 4,left: 4),
      child: Wrap(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ברכות! בקשתך להצטרף לאירוע אושרה, כעת תוכל לשוחח עם מארגן האירוע בחלונית הצאט', style: TextStyle(fontSize: 20, color: Colors.white,), textAlign: TextAlign.center,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("צפה באירוע"),
                      onPressed: () {
                        seeEvents(index);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Method that create a row of type [MyNotification.EVENTS_CHANGE]
  /// [index] - Represents the index of the list we want to create a row for
  _createEventHaveChange(int index){
    return Padding(
      padding: const EdgeInsets.only(top: 4,right: 4,left: 4),
      child: Wrap(
        children: [
          Container(
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
        ],
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
  /// [_notificationCreatorID] - The ID of the person that we got the notification from
  /// [notificationsCreatorUser] - The User object of the same person we got form Firebase FireStore
  /// [creatorPhoto] - Same user photo link
  /// [_height] - Height of the user show area
  /// [_paddingRight], [_paddingLeft] - Padding to user in all of the rows
  seeProfile(int index) async {
    String _notificationCreatorID =  listNotification[index].userID;
    User notificationsCreatorUser = await Logic.getUserByIDFromFireBase(_notificationCreatorID);
    String creatorPhoto = notificationsCreatorUser.fbPhoto;
    double _height = ((MediaQuery.of(context).size.height / 3) * 1.25);
    double _paddingRight = 30.0, _paddingLeft = 25.0;
    showModalBottomSheet(
      context: context,
      builder: (context){
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            constraints: new BoxConstraints(maxHeight: _height,),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    constraints: new BoxConstraints(maxHeight: (_height - 75.0),),
                    decoration: BoxDecoration(
                      color: bodyColor.withOpacity(1),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(75), topRight: Radius.circular(75)),
                    ),
                  ),
                ),  //  Background
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 89.35),
                    child: NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overScroll) {
                        overScroll.disallowGlow();
                        return true;
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 42.35, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        "שם",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 42.35, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        notificationsCreatorUser.name,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),  //  Name - Read Only
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        "מין",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        notificationsCreatorUser.gender,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),  //  Gender - Read Only
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        "גיל",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        notificationsCreatorUser.age_range.toString(),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),  //  Age - Read Only
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        "תחביבים",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        notificationsCreatorUser.hobbies,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),  //  Hobbies - Read Only
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        "תמצית",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        notificationsCreatorUser.bio,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),  //  Bio - Read Only
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        "מוסד אקדמאי",
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        notificationsCreatorUser.academicInstitution,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),  //  Academic Institution - Read Only
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        "תחום לימודי",
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        notificationsCreatorUser.fieldOfStudy,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),  //  Field Of Study - Read Only
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          "עישון",
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: _paddingRight),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          notificationsCreatorUser.smoking,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),  //  Smoking - Read Only
                          ],
                        ),
                      ),
                    ),
                  ),
                ),  //  Body
                Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(creatorPhoto),
                    backgroundColor: Colors.transparent,
                  ),
                ),  //  User Photo
              ],
            ),
          ),
        );
      },
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  /// [index] - Represents the index of the list we want to approve / reject
  /// [approve] - A boolean flag that indicates if we need to approve or denied the request
  approveOrRejectRequestToJoinEvent(int index, bool approve) async {
    var theEvents = await FirebaseHelper.getEventByID(listNotification[index].eventsID);
    if(theEvents == null){
      _makeToast('אירעה תקלה, נסה שנית מאוחר יותר',Colors.pink);
      return;
    }
    var theOtherUser = await FirebaseHelper.getCurrentUser(listNotification[index].userID);
    if(theOtherUser == null){
      _makeToast("אירעה שגיאה, עמכם הסליחה",Colors.red);
      return;
    }
    await Logic.approveOrRejectRequestToJoinEvent(theOtherUser,theEvents,approve).then((value){
      setState(() {});
    });
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




















