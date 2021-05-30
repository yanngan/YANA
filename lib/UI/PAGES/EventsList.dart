import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/CLASSES/allClasses.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';

import 'AllPage.dart';

class EventsList extends StatefulWidget {
  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  bool initDone = false;
  List<Events> listEvents = [];
  Map<String, Place> PlaceByEvents = {};
  @override
  Widget build(BuildContext context) {
    if (!initDone) {
      _init();
    }
    return Scaffold(
      appBar: null,
      //floatingActionButton: FloatingActionButton(onPressed: (){Logic.getAllUserEvent();},),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                height: 60,
                child: Text("אירועים שאתה פתחת\n יופיעו בצבע זה"),
                color: Colors.pink,
              )),
              Expanded(
                  child: Container(
                height: 60,
                child: Text("אירועים שביקשת להצטרף אליהם\n יופיעו בצבע זה"),
                color: Colors.pink[200],
              )),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.amber[300],
              child: initDone
                  ? ListView.builder(
                      itemCount: listEvents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _createRow(index);
                      })
                  : SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.0,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  _init() {
    Logic.getAllUserEvent().then((value) async {
      listEvents = value;
      for (var oneEvents in listEvents) {
        print(oneEvents.placeID);
        var temp = await Logic.getPlacesById(oneEvents.placeID);
        if (temp == null) {
          listEvents.remove(oneEvents);
          continue;
        }
        print(temp.placeID);
        PlaceByEvents[oneEvents.eventID] = temp;
      }
      setState(() {
        initDone = true;
      });
    });
  }

  //create row in the list
  _createRow(int index) {
    var color = Colors.pink[500];
    if (listEvents[index].userID != userMap['id']!) {
      color = Colors.pink[300];
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 4, left: 4),
      child: InkWell(
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text('Event - ${listEvents[index].eventID}'),
                  Text(
                    '${(PlaceByEvents[listEvents[index].eventID]!).name}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${listEvents[index].startEstimate}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.white,
              )
            ],
          ),
        ),
        onTap: () {
          MapLogic.addEditSeePoints(context, 'see',
              theEvent: listEvents[index],
              thePlace: PlaceByEvents[listEvents[index].eventID],
              totallyPop: true);
        },
      ),
    );
  }
}
