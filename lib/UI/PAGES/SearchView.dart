import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yana/UI/PAGES/Utilities.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';
import '../WIDGETS/MyAppBar.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool _initDone = false;
  bool _seeField = false;
  List<Events> listEvents = [];
  Map<String, Place> PlaceByEvents = {};
  Map<String, TextEditingController> allField = {};
  // @override

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
              _seeField
                ? Container(
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
                  )
                : IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 40,
                      color: Colors.pink,
                    ),
                    onPressed: _toggleSearch,
                  ),
              Expanded(
                child: Container(
                  color: Colors.amber[300],
                  child: _initDone
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
        ));
  }

  void _init() async {
    await Logic.getEventsByCondition().then((value) async {
      listEvents.clear();
      listEvents = value;
      for (var oneEvents in listEvents) {
        // print(oneEvents.placeID);
        var temp = await Logic.getPlaceById(oneEvents.placeID);
        // ignore: unnecessary_null_comparison
        if (temp == null) {
          listEvents.remove(oneEvents);
          continue;
        }
        // print(temp.placeID);
        PlaceByEvents[oneEvents.eventID] = temp;
      }
      setState(() {
        _initDone = true;
      });
    });
  }

  void _doSearch() async {
    //placeName  estimateDate  startEstimateTime maxNumPeople
    allField.forEach((key, value) {
      print("key = $key , value = ${value.text}");
    });
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
        // print(oneEvents.placeID);
        var temp = await Logic.getPlaceById(oneEvents.placeID);
        if (temp == null) {
          listEvents.remove(oneEvents);
          continue;
        }
        // print(temp.placeID);
        PlaceByEvents[oneEvents.eventID] = temp;
      }
      setState(() {
        _initDone = true;
      });
    });
  }

  _toggleSearch() {
    setState(() {
      // print(listEvents);
      _seeField = !_seeField;
    });
  }

  // create row in the list
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
                    '${(PlaceByEvents[listEvents[index].eventID]!).name}',
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
              thePlace: PlaceByEvents[listEvents[index].eventID],
              totallyPop: true);
        },
      ),
    );
  }

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
                    print((this.allField[name]!).text);
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
                    print((this.allField[name]!).text);
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
