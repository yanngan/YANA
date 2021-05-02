import 'package:flutter/material.dart';


class AddSeeEvent extends StatefulWidget {
  @override
  _AddSeeEventState createState() => _AddSeeEventState();
}

class _AddSeeEventState extends State<AddSeeEvent> {
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
              TextField(decoration: InputDecoration(fillColor: Colors.white),controller: TextEditingController(text:"A"),),
              TextField(decoration: InputDecoration(fillColor: Colors.white),controller: TextEditingController(text:"B"),),
              TextField(decoration: InputDecoration(fillColor: Colors.white),controller: TextEditingController(text:"C"),),
              TextField(decoration: InputDecoration(fillColor: Colors.white),controller: TextEditingController(text:"D"),),
              TextField(decoration: InputDecoration(fillColor: Colors.white),controller: TextEditingController(text:"E"),),
            ],
          ),
        ),
    );
  }
}
