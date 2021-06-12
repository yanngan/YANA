import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yana/UI/PAGES/Utilities.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';

class SearchView extends StatefulWidget {

  @override
  _SearchViewState createState() => _SearchViewState();

}

class _SearchViewState extends State<SearchView> {

  /// [_initDone] - [bool] flag to check if the initializing process is completed or not
  /// [_seeField] - [bool] flag to determine if to show the search filters area or not
  /// [listEvents] - [List] of all the [Events] (=events) that the search gave (default is all of them)
  /// [placeByEvents] - [Map] of pairs of key [String] : value [Place] of all the places of the events
  /// [allField] - [Map] of pairs of key [String] : value [TextEditingController] of all the fields controllers
  bool _initDone = false;
  bool _seeField = false;
  List<Events> listEvents = [];
  Map<String, Place> placeByEvents = {};
  Map<String, TextEditingController> allField = {};

  /// [_searchWidth] - Desired search width
  @override
  Widget build(BuildContext context) {
    double _searchWidth = ((MediaQuery.of(context).size.width) / 2);
    if (!_initDone) {
      _init();
    }
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Container(
                height: appBarHeight,
                width: (MediaQuery.of(context).size.width),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(1000),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    "חיפוש",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              !_seeField
                ? AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.fastOutSlowIn,
                    height: MediaQuery.of(context).size.height / 2.3,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          createTextField(
                            'placeName',
                            'שם המקום',
                            'text',
                          ),
                          SizedBox(height: 15,),
                          createTextField(
                            'estimateDate',
                            'באיזה תאריך',/// todo - after yisrael make this to look for a specific day-> change the text here
                            'date',
                          ),
                          SizedBox(height: 15,),
                          createTextField(
                            'startEstimateTime',
                            'החל מאיזה שעה',
                            'time',
                          ),
                          SizedBox(height: 15,),
                          Text(
                            "כמות מקסימלית של אנשים באירוע",
                            style: TextStyle(color: Colors.grey[900]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16,0,0,0),
                                child: ElevatedButton(
                                    child: Text(
                                      '-',
                                      style: TextStyle(color: Colors.white,fontSize: 27),
                                    ),
                                    onPressed: decrementMaxNumPeople,
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(
                                          // borderRadius: BorderRadius.circular(20),
                                          //side: BorderSide(color: Colors.black38)
                                        )),
                                        backgroundColor: MaterialStateProperty.all(
                                            Colors.pink))),
                              ),
                              Container(
                                width: 20,
                                child: createTextField(
                                  'maxNumPeople',
                                  'כמות מקסימלית של אנשים באירוע',
                                  'int',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                child: ElevatedButton(
                                  child: Text(
                                    '+',
                                    style: TextStyle(color: Colors.white,fontSize: 20),
                                  ),
                                  onPressed: incrementMaxNumPeople,
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(
                                        // borderRadius: BorderRadius.circular(25),
                                        //side: BorderSide(color: Colors.black38)

                                      )),
                                      backgroundColor:
                                      MaterialStateProperty.all(Colors.pink)),
                                ),
                              ),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: (_searchWidth / 3.5)),
                                child: SizedBox(
                                  width: _searchWidth,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(Colors.pink),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          //side: BorderSide(color: Colors.black54)
                                        )),
                                      ),
                                      child: Text(
                                        "חפש",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      onPressed: _doSearch,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 30,
                                  color: Colors.pink,
                                ),
                                onPressed: _toggleSearch,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
              :
              AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                curve: Curves.bounceOut,
                height: MediaQuery.of(context).size.height /10,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: ElevatedButton(onPressed: _toggleSearch,child: Icon(Icons.search),style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    minimumSize: Size(150.0,40),
                  ),
                  ),
                ),
              ),
                // : IconButton(
                //     icon: Icon(
                //       Icons.keyboard_arrow_down,
                //       size: 40,
                //       color: Colors.pink,
                //     ),
                //     onPressed: _toggleSearch,
                //   ),
              Expanded(
                child: Container(
                  color: Colors.amber[300],
                  child: _initDone
                      ? ListView.builder(
                          itemCount: listEvents.length,
                          itemBuilder: (BuildContext context, int index) {
                            if(index == listEvents.length - 1){
                              return Padding(
                                padding: EdgeInsets.only(bottom: 90),
                                child: _createRow(index),
                              );
                            }
                            return _createRow(index);
                          })
                      : SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50.0,
                        ),
                ),
              )
            ],
          ),
        ),);
  }

  /// Method to initialize all the variables and fields we need for this page
  void _init() async {
    await Logic.getEventsByCondition().then((value) async {
      listEvents.clear();
      listEvents = value;
      for (var oneEvents in listEvents) {
        var temp = await Logic.getPlaceById(oneEvents.placeID);
        // ignore: unnecessary_null_comparison
        if (temp == null) {
          listEvents.remove(oneEvents);
          continue;
        }
        placeByEvents[oneEvents.eventID] = temp;
      }
      setState(() {
        _initDone = true;
      });
    });
  }

  /// Callback function that gets called when we need a search programmatically or when the user presses the search option
  /// [placeName] - [String] that holds the name of the place
  /// [estimateDate] - [String] that holds the estimate date that the user want
  /// [startEstimateTime] - [String] that holds the estimated time of the day the event will start
  /// [maxNumPeople] - [int] that holds the max number of people allowed in this event
  void _doSearch() async {
    String placeName = (allField['placeName']!).text;
    String estimateDate = (allField['estimateDate']!).text;
    String startEstimateTime = (allField['startEstimateTime']!).text;
    int maxNumPeople;
    if ((allField['maxNumPeople']!).text != '-') {
      maxNumPeople = int.parse((allField['maxNumPeople']!).text);
    } else {
      maxNumPeople = -1;
    }

    Logic.getEventsByCondition(
            maxNumPeople: maxNumPeople,
            estimateDate: estimateDate,
            placesName: placeName,
            startEstimateTime: startEstimateTime)
        .then((value) async {
          listEvents.clear();
      listEvents = value;
      for (var oneEvents in listEvents) {
        var temp = await Logic.getPlaceById(oneEvents.placeID);
        // ignore: unnecessary_null_comparison
        if (temp == null) {
          listEvents.remove(oneEvents);
          continue;
        }
        placeByEvents[oneEvents.eventID] = temp;
      }
      setState(() {
        _initDone = true;
      });
    });
  }

  /// Method in order to open / close the search area based on [_seeField]
  _toggleSearch() {
    setState(() {
      _seeField = !_seeField;
    });
  }

  /// Each row of the [ListView] of events is created using this function
  /// [index] - the index of [listEvents], in order to get the event we want
  _createRow(int index) {
    Color _color = Colors.amber;
    var _icon = Icons.edit;
    if (listEvents[index].userID != userMap['userID']!) {
      _color = Colors.pink[300]!;
      _icon = Icons.remove_red_eye;
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 6, 15, 6),
      child: InkWell(
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: _color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                blurRadius: 5.0,
                offset: Offset(3, 2),
                color: Colors.black.withOpacity(0.35),
                spreadRadius: 0.5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0,9,0,9),
                child: Image(image: AssetImage('assets/yana_logo.png')),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text('Event - ${listEvents[index].eventID}'),
                  Text(
                    '${(placeByEvents[listEvents[index].eventID]!).name}',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[900],
                        fontFamily: "FontRaleway"),
                  ),
                  Text(
                    '${listEvents[index].startEstimate}',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[900],
                        fontFamily: "FontRaleway"),
                  ),
                ],
              ),
              Icon(
                _icon,
                color: Colors.grey[900],
              )
            ],
          ),
        ),
        onTap: () {
          MapLogic.addEditSeePoints(context, 'see',
              theEvent: listEvents[index],
              thePlace: placeByEvents[listEvents[index].eventID],
              totallyPop: true);
        },
      ),
    );
  }

  /// A method in order to create a field of given information based on
  /// [name] - [String] that will appear before the intractable area for the user to understand what the intractable area is for
  /// [hint] - [String] that will appear in the area the user need to interact with
  /// [type] - Determine the type of the field
  createTextField(String name, String hint, String type) {
    if (!this.allField.containsKey(name)) {
      this.allField[name] = TextEditingController();
      if (type == 'int') {
        (this.allField[name]!).text = '16';
      }
    }
    switch (type) {
      case 'date':
        final format = intl.DateFormat("yyyy-MM-dd");
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: DateTimeField(
            textAlign: TextAlign.right,
            format: format,
            decoration: new InputDecoration(
                hintText: hint, hintStyle: TextStyle(color: Colors.black38)),
            controller: this.allField[name],
            onShowPicker: (context, currentValue) async {
              showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                initialDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 50)),
              ).then((value) {
                setState(() {
                  if (value != null) {
                    (this.allField[name]!).text =
                        intl.DateFormat('yyyy-MM-dd').format(value);
                  }
                });
              });
            },
            resetIcon: Icon(Icons.cancel_outlined),
          ),
        );
      case 'time':
        final format = intl.DateFormat("hh:mm:ss");
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: DateTimeField(
            textAlign: TextAlign.right,
            format: format,
            decoration: new InputDecoration(
                hintText: hint, hintStyle: TextStyle(color: Colors.black38)),
            controller: this.allField[name],
            onShowPicker: (context, currentValue) async {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                    hour: DateTime.now().hour, minute: DateTime.now().minute),
              ).then((value) {
                setState(() {
                  if (value != null) {
                    (this.allField[name]!).text = value.format(context);
                  }
                });
              });
            },
            resetIcon: Icon(Icons.cancel_outlined),
          ),
        );
      case 'int':
        return TextField(
          textAlignVertical: TextAlignVertical.center,
          readOnly: true,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black38,)),
          controller: this.allField[name],
        );
      case 'text':
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: TextField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black38),
              suffixIcon: IconButton(
                icon: Icon(Icons.cancel_outlined),
                onPressed: (){
                  allField[name]!.text = "";
                },
              ),
            ),
            controller: this.allField[name],

          ),
        );
    }
  }

  /// Method to increment the max number of people allowed in the event
  incrementMaxNumPeople() {
    if((allField['maxNumPeople']!).text == '-'){
      (allField['maxNumPeople']!).text = '2';
      return;
    }
    int res = int.parse((allField['maxNumPeople']!).text);
    if (res > 15) {
      return;
    }
    res++;
    (allField['maxNumPeople']!).text = "$res";
  }

  /// Method to decrement the max number of people allowed in the event
  decrementMaxNumPeople() {
    int res = int.parse((allField['maxNumPeople']!).text);
    if (res < 3) {
      (allField['maxNumPeople']!).text = '-';
      return;
    }
    res--;
    (allField['maxNumPeople']!).text = "$res";
  }

}
