import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DevelopersCreditPage extends StatefulWidget {

  @override
  _DevelopersCreditPageState createState() => _DevelopersCreditPageState();

}

class _DevelopersCreditPageState extends State<DevelopersCreditPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.amber, //change your color here
        ),
        backgroundColor: Colors.pink,
      ),
      backgroundColor: Colors.amber,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: Colors.amber,
          child: SpinKitFadingCircle(
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ),
    );
  }


}




















