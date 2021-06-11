import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yana/UI/PAGES/Utilities.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';

// ignore: must_be_immutable
class EditEvent extends StatefulWidget {

  /// [thePlace] - The [Place] the event is taking place in
  /// [theEvents] - The [Events] event we wish to see
  /// [totallyPop] - [bool] flag to know if totally close the edit screen
  Place thePlace;
  Events theEvents;
  bool totallyPop;
  // constructor
  EditEvent(this.thePlace, this.theEvents,this.totallyPop);

  @override
  _EditEventState createState() => _EditEventState();

}

class _EditEventState extends State<EditEvent> {

  /// [allField] - [Map] of pairs of key [String] : value [TextEditingController] of all the fields controllers
  Map<String, TextEditingController> allField = {};

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width);
    double height = ((MediaQuery.of(context).size.height) / 2);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: [
          Container(
            width: width,
//        height: height,
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    createTextField('estimateDate', 'תאריך רצוי', 'date',
                        widget.theEvents.startEstimate.substring(0, 10)),
                    createTextField('startEstimateTime', 'שעת התחלה', 'time',
                        widget.theEvents.startEstimate.substring(11)),
                    createTextField('endEstimateTime', 'שעת סיום', 'time',
                        widget.theEvents.endEstimate.substring(11)),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        "?כמה אנשים תרצו להיות",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text(
                            '+',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: incrementMaxNumPeople,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.pink)),
                        ),
                        Container(
                          width: 60,
                          child: createTextField('maxNumPeople', 'כמה אנשים', 'int',
                              widget.theEvents.maxNumPeople),
                        ),
                        ElevatedButton(
                          child: Text(
                            '-',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: decrementMaxNumPeople,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.pink)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    createTextField('note', 'הערות', 'text', widget.theEvents.note),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.pink),
                          ),
                          child: Text("שמור"),
                          onPressed: saveTheEvent,
                        ),
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
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A method in order to create a field of given information based on
  /// [name] - [String] that will appear before the intractable area for the user to understand what the intractable area is for
  /// [hint] - [String] that will appear in the area the user need to interact with
  /// [type] - Determine the type of the field
  createTextField(String name, String hint, String type, var value) {
    if (!this.allField.containsKey(name)) {
      this.allField[name] = TextEditingController(text: value.toString());
    }
    var _textAlign = TextAlign.center;
    var onTap;
    switch (type) {
      case 'date':
        final format = DateFormat("yyyy-MM-dd");
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: DateTimeField(
                textAlign: TextAlign.right,
                format: format,
                decoration: new InputDecoration(
                    hintText: hint, hintStyle: TextStyle(color: Colors.grey)),
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
                            DateFormat('yyyy-MM-dd').format(value);
                        print((this.allField[name]!).text);
                      }
                    });
                  });
                },
              ),
            ),
            Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(hint, maxLines: 1, textAlign: _textAlign,)
                )
            ),
          ],
        );
      case 'time':
        final format = DateFormat("hh:mm:ss");
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: DateTimeField(
                textAlign: TextAlign.right,
                format: format,
                decoration: new InputDecoration(
                    hintText: hint, hintStyle: TextStyle(color: Colors.grey)),
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
              ),
            ),
            Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(hint, maxLines: 1, textAlign: _textAlign,)
                )
            ),
          ],
        );
      case 'int':
        return TextField(
          textAlignVertical: TextAlignVertical.center,
          readOnly: true,
          textAlign: _textAlign,
          decoration: InputDecoration(
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey)),
          controller: this.allField[name],
        );
      case 'text':
        return TextField(
          textAlign: TextAlign.right,
          maxLines: 3,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.amber[300],
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          controller: this.allField[name],
        );
    }
  }

  /// Method to save the event into FireBase
  saveTheEvent() async {
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    String estimateDate = ((allField['estimateDate']!).text);
    String startEstimateTime = ((allField['startEstimateTime']!).text);
    String startEstimate = estimateDate + " " + startEstimateTime;
    String endEstimateTime = ((allField['endEstimateTime']!).text);
    String endEstimate = estimateDate + " " + endEstimateTime;
    int maxNumPeople = -1;
    try {
      maxNumPeople = int.parse((allField['maxNumPeople']!).text);
    } on Exception catch (e) {
      maxNumPeople = -1;
    }

    //the UserID is in allPages in the Map there
    if (estimateDate == '' ||
        startEstimateTime == '' ||
        endEstimateTime == '' ||
        maxNumPeople < 2) {
      makeErrorAlert("חובה למלא את כל השדות בערכים תקינים");
      return;
    }
    Events theNewEvents = Events(widget.theEvents.eventID,userMap['userID']!,'test',formattedDate,true,startEstimate,endEstimate,1,maxNumPeople,widget.thePlace.placeID,widget.thePlace.name,(allField['note']!).text);
    widget.theEvents = theNewEvents;
    var res = await Logic.createEditNewEvents(theNewEvents, false);
    if (res == null) {
      makeErrorAlert("אירעה שגיאה בתהליך השמירה, נסה שנית");
    }
    Navigator.of(context).pop();
    if(!widget.totallyPop){
      MapLogic.addEditSeePoints(context, 'see',
          theEvent: theNewEvents, thePlace: widget.thePlace);
    }
    /*Route route = MaterialPageRoute(builder: (context) => SeeEvent(widget.thePlace,widget.theEvents));
    Navigator.pushReplacement(context, route);*/
  }

  /// Method to create an Error [AlertDialog] with the [text] as the body - [String]
  makeErrorAlert(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            text,
            style: TextStyle(color: Colors.blueGrey),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          actions: <Widget>[
            new TextButton(
              child: new Text(
                "אוקי",
                style: TextStyle(color: Colors.blueGrey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Method to increment the max number of people allowed in the event
  incrementMaxNumPeople() {
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
      return;
    }
    res--;
    (allField['maxNumPeople']!).text = "$res";
  }
}
