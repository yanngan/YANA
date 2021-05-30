import 'package:flutter/material.dart';
import 'package:yana/UI/PAGES/AllPage.dart';
import 'package:yana/UI/WIDGETS/allWidgets.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';


class SeeEvent extends StatefulWidget {
  Place thePlace;
  Events theEvents;
  SeeEvent(this.thePlace,this.theEvents);
  @override
  _SeeEventState createState() => _SeeEventState();
}

class _SeeEventState extends State<SeeEvent> {

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width);
    double height = ((MediaQuery.of(context).size.height)/3);
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
              widget.theEvents.userID == userMap["id"]?ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink),),
                child: Text("ערוך"),
                onPressed: editTheEvent,
              ):ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink),),
                child: Text("בקש להצטרף"),
                onPressed: askToJoin,
              ),

            ],
          ),

        ),
    );
  }

  editTheEvent(){
    Navigator.of(context).pop();
    MapLogic.addEditSeePoints(context,'edit',theEvent:widget.theEvents,thePlace:widget.thePlace);
  }

  askToJoin(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("תממש אותי יאן!!!!",style: TextStyle(color: Colors.blueGrey),),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("אוקי",style: TextStyle(color: Colors.blueGrey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
