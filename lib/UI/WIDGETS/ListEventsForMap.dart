import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';

class ListEventsForMap extends StatefulWidget {
  Place thePlace;
  ListEventsForMap(this.thePlace);

  @override
  _ListEventsForMapState createState() => _ListEventsForMapState();
}

class _ListEventsForMapState extends State<ListEventsForMap> {
  bool initDone = false;
  List<Events> listEvents = [];
  @override
  Widget build(BuildContext context) {
    if(!initDone){
      _init();
    }
    return AlertDialog(
      title: new Text(widget.thePlace.name),
      backgroundColor: Colors.amber,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      insetPadding: EdgeInsets.symmetric(vertical: 200),
      content:Scaffold(
        appBar: null,
        body:  Container(
          color: Colors.amber,
          child: ListView.builder(
            itemCount: listEvents.length,
            itemBuilder: (BuildContext context, int index) {
              return _createRow(index);
            }
          ),
        ),
      ),
      actions: [
        new TextButton(
          child: new Text("Add +",style: TextStyle(color: Colors.blueGrey),),
          onPressed: () {
            MapLogic.addEditSeePoints(context);
          },
        ),
        new TextButton(
          child: new Text("Close",style: TextStyle(color: Colors.blueGrey),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }



  _init(){
    Logic.getEventsByPlace(widget.thePlace.placeID).then((value){
      listEvents = value;
      setState(() {
        initDone = true;
      });
    });
  }

  _createRow(int index){
    return InkWell(
      child: Container(
        height: 50,
        color: Colors.amber[300 + ((index%2)*100)],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Text('Event - ${listEvents[index].eventID}'),
                Text('time - ${listEvents[index].startEstimate}',style: TextStyle(fontSize: 15),),
              ],
            ),
            Icon(Icons.arrow_forward_ios_outlined)
          ],
        ),
      ),
      onTap: (){
        MapLogic.addEditSeePoints(context);
      },
    );
  }
}
