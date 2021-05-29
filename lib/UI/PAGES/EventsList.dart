import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';

class EventsList extends StatefulWidget {
  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  bool initDone = false;
  List<Events> listEvents = [];
  Map<String,dynamic> PlaceByEvents = {};
  @override
  Widget build(BuildContext context) {
    if(!initDone){
      _init();
    }
    return Scaffold(
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
    );
  }


  _init(){
    Logic.getAllUserEvent().then((value) async {
      listEvents = value;
      for(var oneEvents in listEvents) {
        print(oneEvents.placeID);
        //var temp = await Logic.getPlacesById(oneEvents.placeID)!;
        var temp = await Logic.getPlacesById('Shoshana Bar');
        print(temp.placeID);
        PlaceByEvents[oneEvents.eventID] = temp;
      }
      setState(() {
        initDone = true;
      });
    });
  }

  //create row in the list
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
        MapLogic.addEditSeePoints(context,'see',theEvent:listEvents[index],thePlace: PlaceByEvents[listEvents[index].eventID],pop:false);
      },
    );
  }
}
