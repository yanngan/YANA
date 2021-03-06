import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yana/UI/PAGES/Utilities.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:yana/UX/LOGIC/CLASSES/allClasses.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'package:yana/UX/LOGIC/MapLogic.dart';

// ignore: must_be_immutable
class AddEvent extends StatefulWidget {

  /// [thePlace] - The [Place] the event is taking place in
  Place thePlace;
  // constructor
  AddEvent(this.thePlace);

  @override
  _AddEventState createState() => _AddEventState();

}

class _AddEventState extends State<AddEvent> {

  /// [allField] - [Map] of pairs of key [String] : value [TextEditingController] of all the fields controllers
  Map<String, TextEditingController> allField = {};

  /// [width] - Desired width
  /// [height] - Desired height
  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width);
    double height = ((MediaQuery.of(context).size.height) / 2) + 50;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: [
          Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: Column(children: [
              createTextField(
                'estimateDate',
                'תאריך רצוי',
                'date',
              ),
              createTextField(
                'startEstimateTime',
                'שעת התחלה',
                'time',
              ),
              createTextField(
                'endEstimateTime',
                'שעת סיום',
                'time',
              ),
              Text(
                "?כמה אנשים תרצו להיות",
                style: TextStyle(color: Colors.blueGrey),
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
                    width: 30,
                    child: createTextField(
                      'maxNumPeople',
                      'כמה אנשים',
                      'int',
                    ),
                  ),
                  ElevatedButton(
                      child: Text(
                        '-',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: decrementMaxNumPeople,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.pink))),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              createTextField(
                'note',
                'הערות',
                'text',
              ),
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
                    },
                  ),
                ],
              ),
            ]),
          ),
        ],
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
        (this.allField[name]!).text = '2';
      }
    }
    switch (type) {
      case 'date':
        final format = DateFormat("yyyy-MM-dd");
        return DateTimeField(
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
                }
              });
            });
          },
        );
      case 'time':
        final format = DateFormat("hh:mm:ss");
        return DateTimeField(
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
                }
              });
            });
          },
        );
      case 'int':
        return TextField(
          textAlignVertical: TextAlignVertical.center,
          readOnly: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey)),
          controller: this.allField[name],
        );
      case 'text':
        return Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.transparent),
          child: TextField(
            textAlign: TextAlign.right,
            maxLines: 3,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.amber[300],
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey),
            ),
            controller: this.allField[name],
          ),
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
    } on Exception {
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
    if(startEstimateTime.compareTo(endEstimateTime)>0){
      makeErrorAlert("שעת התחלה לא יכולה להיות לאחר שעת סיום");
      return;
    }
    String newId = await FirebaseHelper.generateEventId();
    Events theNewEvents = Events(
        newId, userMap['userID']!, userMap['name']!, formattedDate, true, startEstimate,
        endEstimate, 1, maxNumPeople, widget.thePlace.placeID,
        widget.thePlace.name, (allField['note']!).text);
    var res = await Logic.createEditNewEvents(theNewEvents,true);
    if(res == null){
      makeErrorAlert("אירעה שגיאה בתהליך השמירה, נסה שנית");
    }
    // Route route = MaterialPageRoute(builder: (context) => SeeEvent(widget.thePlace,theNewEvents));
    // Navigator.pushReplacement(context, route);
    Navigator.of(context).pop();
    MapLogic.addEditSeePoints(context, 'see',
        theEvent: theNewEvents, thePlace: widget.thePlace);
  }

  /// Method to create an Error [AlertDialog] with the [text] as the bdoy [String]
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
