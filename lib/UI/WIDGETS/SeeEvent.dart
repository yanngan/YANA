import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yana/UI/PAGES/Utilities.dart';
import 'package:yana/UI/WIDGETS/allWidgets.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';

// ignore: must_be_immutable
class SeeEvent extends StatefulWidget {

  Place thePlace;
  Events theEvents;
  bool totallyPop;//in use to know if totally close the edit screen
  SeeEvent(this.thePlace,this.theEvents,this.totallyPop);

  @override
  _SeeEventState createState() => _SeeEventState();

}

class _SeeEventState extends State<SeeEvent> {
  bool _initDone = false;
  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width);
    double height = ((MediaQuery.of(context).size.height)/3);
    if(!_initDone){
      _init();
    }
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width,
          height: height,
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
                  Text("שם יוצר האירוע:",textDirection: TextDirection.rtl,),
                  SizedBox(width: 10,),
                  Text(widget.theEvents.userName,textDirection: TextDirection.rtl,),
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
                  Text("${widget.theEvents.note}",textDirection: TextDirection.rtl,),
                ],
              ),
              SizedBox(height: 30,),
              _initDone?
              (widget.theEvents.userID == userMap["id"]?ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink),),
                child: Text("ערוך"),
                onPressed: editTheEvent,
              ):ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(widget.theEvents.statusForUser == Events.NOT_ASK_YET_AND_NOT_GOING ||widget.theEvents.statusForUser == Events.DONT_KNOW ?Colors.pink:Colors.grey),),
                child: Text("בקש להצטרף"),/// todo if have be approve by admin show "בטל הגעה"
                onPressed: askToJoin,
              )):SizedBox(height: 30,),
            ],
          ),

        ),
    );
  }

  _init()async{
    print("in _init");
    widget.theEvents.statusForUser =  await Logic.getStatusEventForUser(widget.theEvents.eventID);
    print("init done statusForUser = ${widget.theEvents.statusForUser} ");
    setState(() {
      _initDone = true;
    });
  }

  editTheEvent(){
    Navigator.of(context).pop();
    MapLogic.addEditSeePoints(context,'edit',theEvent:widget.theEvents,thePlace:widget.thePlace,totallyPop: widget.totallyPop);
  }

  askToJoin()async{

    if(widget.theEvents.statusForUser == Events.NOT_ASK_YET_AND_NOT_GOING){
      if(await Logic.userAskToJoinEvent(userMap['id']!,widget.theEvents.eventID,widget.theEvents.userID)){
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
