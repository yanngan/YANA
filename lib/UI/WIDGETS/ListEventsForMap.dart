import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
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
    String placeDetails = widget.thePlace.specialToString();
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
          child: initDone?ListView.builder(
            itemCount: listEvents.length,
            itemBuilder: (BuildContext context, int index) {
              return _createRow(index);
            }
          ):SpinKitFadingCircle(
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ),
      actions: [
        new TextButton(
          child: new Text("הוסף מפגש",style: TextStyle(color: Colors.blueGrey),),
          onPressed: () {
            Navigator.of(context).pop();
            MapLogic.addEditSeePoints(context,'add',thePlace:widget.thePlace);
          },
        ),
        new TextButton(
          child: new Text("סגור",style: TextStyle(color: Colors.blueGrey),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),new TextButton(
          child: new Text("פרטים על המקום",style: TextStyle(color: Colors.blueGrey),),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  title: Align(
                    alignment: Alignment.center,
                    child: Text(widget.thePlace.name),
                  ),
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  insetPadding: EdgeInsets.symmetric(vertical: 200),
                  content: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.center,
                      child: Directionality(child: Text(placeDetails),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("סגור"),
                    )
                  ],
                );
              },
            );//
            // Navigator.of(context).pop();

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
        Navigator.of(context).pop();
        MapLogic.addEditSeePoints(context,'see',theEvent:listEvents[index],thePlace: widget.thePlace);
      },
    );
  }

  refresh(){
    setState(() {
      initDone = false;
    });
  }
}
