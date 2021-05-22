import 'package:flutter/material.dart';
import 'package:yana/UI/PAGES/AllPage.dart';
import 'package:yana/UI/WIDGETS/allWidgets.dart';
import 'package:yana/UX/DB/allDB.dart';


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
    double height = ((MediaQuery.of(context).size.height)/2);
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
              Text("hello"),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text("שם יוצר האירוע:"),
                  SizedBox(width: 30,),
                  Text(widget.theEvents.userName),
                ],
              ),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text("כמה אנשים באים:",textDirection: TextDirection.rtl,),
                  SizedBox(width: 30,),
                  Text("${widget.theEvents.curNumPeople}"),
                ],
              ),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text("התחלה:",textDirection: TextDirection.rtl,),
                  SizedBox(width: 30,),
                  Text("${widget.theEvents.startEstimate}"),
                ],
              ),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text("סיום צפוי:",textDirection: TextDirection.rtl,),
                  SizedBox(width: 30,),
                  Text("${widget.theEvents.endEstimate}"),
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
    Route route = MaterialPageRoute(builder: (context) => EditEvent(widget.thePlace,widget.theEvents));
    Navigator.pushReplacement(context, route);
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
