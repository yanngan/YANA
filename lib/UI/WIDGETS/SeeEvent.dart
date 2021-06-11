import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yana/UI/PAGES/Utilities.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';

// ignore: must_be_immutable
class SeeEvent extends StatefulWidget {

  /// [thePlace] - The [Place] the event is taking place in
  /// [theEvents] - The [Events] event we wish to see
  /// [totallyPop] - [bool] flag to know if totally close the edit screen
  Place thePlace;
  Events theEvents;
  bool totallyPop;
  // constructor
  SeeEvent(this.thePlace,this.theEvents,this.totallyPop);

  @override
  _SeeEventState createState() => _SeeEventState();

}

class _SeeEventState extends State<SeeEvent> {

  /// [_initDone] - A [bool] that representing if the initializing process is finished or not
  bool _initDone = false;

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width);
    double height = ((MediaQuery.of(context).size.height)/2);
    if(!_initDone){
      _init();
    }
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: [
            Container(
              width: width,
              decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20.0),),
              ),
              child: Column(
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Text("יוצר האירוע:",textDirection: TextDirection.rtl,),
                      SizedBox(width: 10,),
                      Text(widget.theEvents.userName,textDirection: TextDirection.rtl, maxLines: 2,),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Text("כמה אנשים באים:",textDirection: TextDirection.rtl,),
                      SizedBox(width: 10,),
                      Text("${widget.theEvents.curNumPeople}",textDirection: TextDirection.rtl,),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Text("התחלה:",textDirection: TextDirection.rtl,),
                      SizedBox(width: 10,),
                      Text("${widget.theEvents.startEstimate}",textDirection: TextDirection.rtl,),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Text("סיום צפוי:",textDirection: TextDirection.rtl,),
                      SizedBox(width: 10,),
                      Text("${widget.theEvents.endEstimate}",textDirection: TextDirection.rtl,),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Text("הערות:",textDirection: TextDirection.rtl,),
                      SizedBox(width: 10,),
                      Flexible(child: Text("${widget.theEvents.note}",textDirection: TextDirection.rtl,)),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _initDone?
                      (widget.theEvents.userID == userMap["userID"]?ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink),),
                        child: Text("ערוך"),
                        onPressed: editTheEvent,
                      ):ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(widget.theEvents.statusForUser == Events.NOT_ASK_YET_AND_NOT_GOING ||widget.theEvents.statusForUser == Events.DONT_KNOW ?Colors.pink:Colors.grey),),
                        child: Text("בקש להצטרף"),/// todo if have be approve by admin show "בטל הגעה"
                        onPressed: askToJoin,
                      )):SizedBox(height: 30,),
                      TextButton(
                        child: new Text(
                          "סגור", style: TextStyle(color: Colors.blueGrey),),
                        onPressed: () {
                          Navigator.of(context).pop();
//                  if (!totallyPop) {
//                    print("in popTotally");
//                    seeListEventInPlace(context, thePlace);
//                  }
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

  /// Method to initialize all the variables and fields we need for this page
  _init() async {
    widget.theEvents.statusForUser =  await Logic.getStatusEventForUser(widget.theEvents.eventID);
    setState(() {
      _initDone = true;
    });
  }

  /// Callback function that gets called when the users prompt to edit the event that is shown to them
  editTheEvent(){
    Navigator.of(context).pop();
    MapLogic.addEditSeePoints(context,'edit',theEvent:widget.theEvents,thePlace:widget.thePlace,totallyPop: widget.totallyPop);
  }

  /// Callback function that gets called when the users are requesting to join an event
  askToJoin() async {

    if(widget.theEvents.statusForUser == Events.NOT_ASK_YET_AND_NOT_GOING){
      if(await Logic.userAskToJoinEvent(userMap['userID']!,widget.theEvents.eventID,widget.theEvents.userID)){
        _makeToast("בקשתך נשלחה וממתינה לאישור מארגן האירוע");
      }
      else{
        _makeToast("אירעה תקלה, נסה שנית מאוחר יותר");
      }
    }
    else{
      _makeToast("בקשה כבר נשלחה בעבר");
    }
    setState(() {
      _initDone = false;
    });
  }

  /// A Method to make a toast
  /// [str] - [String] that will be the text of the toast
  _makeToast(String str){
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.blueGrey,
        fontSize: 16.0
    );
  }

}
