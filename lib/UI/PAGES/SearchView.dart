import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yana/UI/PAGES/AllPage.dart';
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
  bool _seeField = true;
  List<Events> listEvents = [];
  Map<String,Place> PlaceByEvents = {};
  Map<String,TextEditingController> allField = {};
  // @override



  @override
  Widget build(BuildContext context) {
    if(!_initDone){
      _init();
    }
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          Container(
            height: 130,
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
              child: Text("חיפוש",style: TextStyle(fontSize: 40,color: Colors.white),textAlign: TextAlign.center,),
            ),
          ),
          _seeField?Container(
            child: Column(
            children: [
              createTextField('placeName','שם המקום', 'text', ),
              createTextField('estimateDate','תאריך רצוי', 'date', ),
              createTextField('startEstimateTime','החל מאיזה שעה', 'time', ),
              Text("כמות מקסימלית של אנשים באירוע", style: TextStyle(color: Colors.blueGrey),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(child: Text('+',style: TextStyle(color: Colors.white),),onPressed: incrementmaxNumPeople,style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink)) ,),
                  Container(
                    width: 30,
                    child: createTextField('maxNumPeople','כמות מקסימלית של אנשים באירוע', 'int', ),
                  ),
                  ElevatedButton(child: Text('-',style: TextStyle(color: Colors.white),),onPressed: decrementmaxNumPeople,style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink))),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_up,color: Colors.pink,),
                    onPressed: _toggleSearch,
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width)-50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.pink),
                      ),
                      child: Text("חפש",style: TextStyle(fontSize: 20),),
                      onPressed: _doSearch,
                    ),
                  ),
                ],
              ),
            ],
          ),):IconButton(
            icon: Icon(Icons.keyboard_arrow_down,color: Colors.pink,),
            onPressed: _toggleSearch,
          ),
          Expanded(
            child: Container(
              color: Colors.amber[300],
              child: _initDone?ListView.builder(
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
        ],
      )
    );
  }


  void _init() async {
    Logic.getEventsByCondition().then((value) async {
      listEvents = value;
      for(var oneEvents in listEvents) {
        print(oneEvents.placeID);
        var temp = await Logic.getPlacesById(oneEvents.placeID);
        if(temp == null){
          listEvents.remove(oneEvents);
          continue;
        }
        print(temp.placeID);
        PlaceByEvents[oneEvents.eventID] = temp;
      }
      setState(() {
        _initDone = true;
      });
    });
  }

  void _doSearch() async{
    //placeName  estimateDate  startEstimateTime maxNumPeople
    allField.forEach((key, value) {
      print("key = $key , value = ${value.text}");
    });
    String placeName = (allField['placeName']!).text;
    String estimateDate = (allField['estimateDate']!).text;
    String startEstimateTime = (allField['startEstimateTime']!).text;
    int maxNumPeople;
    if((allField['maxNumPeople']!).text!='-'){
      maxNumPeople = int.parse((allField['maxNumPeople']!).text);
    }
    else{
      maxNumPeople = -1;
    }

    Logic.getEventsByCondition(maxNumPeople:maxNumPeople ,estimateDate: estimateDate,placesName: placeName,startEstimateTime:startEstimateTime).then((value) async {
      listEvents = value;
      for(var oneEvents in listEvents) {
        print(oneEvents.placeID);
        var temp = await Logic.getPlacesById(oneEvents.placeID);
        if(temp == null){
          listEvents.remove(oneEvents);
          continue;
        }
        print(temp.placeID);
        PlaceByEvents[oneEvents.eventID] = temp;
      }
      setState(() {
        _initDone = true;
      });
    });
  }
  _toggleSearch(){
    setState(() {
      print(listEvents);
      _seeField = !_seeField;
    });

  }

  //creat row in the list
  _createRow(int index){
    var color = Colors.pink[500];
    if(listEvents[index].userID != userMap['id']!){
      color = Colors.pink[300];
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4,right: 4,left: 4),
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
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  //Text('Event - ${listEvents[index].eventID}'),
                  Text('${(PlaceByEvents[listEvents[index].eventID]!).name}',style: TextStyle(fontSize: 20,color: Colors.white, ),),
                  Text('${listEvents[index].startEstimate}',style: TextStyle(fontSize: 15,color: Colors.white,),),
                ],
              ),
              Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,)
            ],
          ),
        ),
        onTap: (){
          MapLogic.addEditSeePoints(context,'see',theEvent:listEvents[index],thePlace: PlaceByEvents[listEvents[index].eventID],totallyPop: true);
        },
      ),
    );
  }


  createTextField(String name,String hint,String type){
    if(!this.allField.containsKey(name)){
      this.allField[name] = TextEditingController();
      if(type == 'int'){
        (this.allField[name]!).text = '2';
      }
    }
    switch(type){
      case 'date':
        final format = DateFormat("yyyy-MM-dd");
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: DateTimeField(
            textAlign: TextAlign.right,
            format: format,
            decoration: new InputDecoration(hintText: hint,hintStyle: TextStyle(color: Colors.grey )),
            controller: this.allField[name],
            onShowPicker: (context, currentValue) async {
              showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                initialDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 50)),
              ).then((value){
                setState(() {

                  if(value != null){
                    (this.allField[name]!).text = DateFormat('yyyy-MM-dd').format(value);
                    print((this.allField[name]!).text);
                  }
                });
              });

            },
          ),
        );
      case 'time':
        final format = DateFormat("hh:mm:ss");
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: DateTimeField(
            textAlign: TextAlign.right,
            format: format,
            decoration: new InputDecoration(hintText: hint,hintStyle: TextStyle(color: Colors.grey )),
            controller: this.allField[name],
            onShowPicker: (context, currentValue) async {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                    hour: DateTime.now().hour,
                    minute: DateTime.now().minute
                ),
              ).then((value){
                setState(() {
                  if(value != null){
                    (this.allField[name]!).text = value.format(context);
                    print((this.allField[name]!).text);
                  }
                });
              });

            },
          ),
        );
      case 'int':
        return TextField(
          textAlignVertical: TextAlignVertical.center,
          readOnly: true,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
              fillColor: Colors.white,
              hintText:hint,
              hintStyle: TextStyle(color: Colors.grey )
          ),
          controller: this.allField[name],
        );
      case 'text':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                fillColor: Colors.white,
                hintText:hint,
                hintStyle: TextStyle(color: Colors.grey )
            ),
            controller: this.allField[name],
          ),
        );
    }
  }

  incrementmaxNumPeople(){
    int res = int.parse((allField['maxNumPeople']!).text);
    if(res > 15 ){
      return;
    }
    res++;
    (allField['maxNumPeople']!).text = "$res";

  }
  decrementmaxNumPeople(){
    int res = int.parse((allField['maxNumPeople']!).text);
    if(res < 3){
      return;
    }
    res--;
    (allField['maxNumPeople']!).text = "$res";

  }

}
