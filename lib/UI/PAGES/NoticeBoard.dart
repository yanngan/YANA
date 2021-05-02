import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../PAGES/Place_Details.dart';
import '../WIDGETS/MyAppBar.dart';

class NoticeBoard extends StatefulWidget {
  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

List<Advertisement> advertisements = [];
List<Place_Details> data = [
  Place_Details(
      kosher: false,
      name: 'Chez Andi',
      number: 0258795461,
      details: 'Hi everyone ! \n'
          'My name sdi Jonas\n'
          'Waht for u ?\n'
          'gergfvzvsfze\n'
          'egrregergegre\n'
          'gertggrege\n'
          'tjytujtyaizejz'),
  Place_Details(kosher: true, name: 'Rimon', number: 0145897859, details: ''),
  Place_Details(
      kosher: true, name: 'Katsefet', number: 0212354674, details: ''),
  Place_Details(
      kosher: false, name: 'Gueoula', number: 0267889744, details: ''),
  Place_Details(
      kosher: true, name: 'KoshTrip', number: 0248985431, details: ''),
  Place_Details(kosher: true, name: 'Hey Now', number: 0248985431, details: ''),
  Place_Details(
      kosher: true, name: 'You are ', number: 0248985431, details: ''),
  Place_Details(kosher: true, name: 'An all', number: 0248985431, details: ''),
  Place_Details(
      kosher: true, name: 'Star get', number: 0248985431, details: ''),
  Place_Details(
      kosher: true, name: 'Your game on', number: 0248985431, details: ''),
  Place_Details(kosher: true, name: 'Go Play', number: 0248985431, details: ''),
];

class _NoticeBoardState extends State<NoticeBoard> {
  @override
  void initState() {
    super.initState();
    initPlacesList(); // In order to populate our Advertisement list
    //Here will be the sorting of the data coming from firebase
  }

  void initPlacesList() {
    for (int i = 0; i < 10; i++) {
      if (i % 2 == 0) {
        advertisements.add(Advertisement(
            Colors.purple[200]!,
            data[i].getName(),
            data[i].getKosher(),
            data[i].getNumber(),
            Colors.grey[900]!,
            data[i].getDetails()));
      } else {
        advertisements.add(Advertisement(
            Colors.purple[400]!,
            data[i].getName(),
            data[i].getKosher(),
            data[i].getNumber(),
            Colors.grey[400]!,
            data[i].getDetails()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar("NoticeBoard",null,height: 50),
      backgroundColor: Colors.amber,
      body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            color: Colors.amber,
            child: ListView(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 40),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    //provisional (the algorithm is basically the same to sort the firebase)
                    children: advertisements,
                    // ],
                  ),
                ),
              ),
            ]),
          ),
      ), // child: Center(child: Text("NoticeBoard Hi")),
    );
  }
}

class Advertisement extends StatefulWidget {
  // const Advert({
  //   Key key,
  // }) : super(key: key);
  String name;
  String details;
  bool kosher;
  int number;
  Color color;
  Color expansiontilecolor;

  var children = [];

  Advertisement(this.color, this.name, this.kosher, this.number,
      this.expansiontilecolor, this.details);

  @override
  _AdvertisementState createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {

  double _width = 200;
  double _height = 110;
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedContainer(

        width: _width,
        height: _height,

        margin: EdgeInsets.fromLTRB(6, 6, 6, 10.0),
        duration: Duration(milliseconds: 700),

        child: GestureDetector(
          onTap: () {
            //SetState of the open/close functionality
            setState(() {
              if (_isOpen) {
                _height -= widget.details.length + 30;
                _isOpen = false;
              } else {
                _height += widget.details.length + 30;
                _isOpen = true;
              }
            });
          },
          // I put a column in case that we want another widget in the bottom.
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(

                  //Possibility of wallpaper

                  // decoration: new BoxDecoration(
                  //   image: new DecorationImage(
                  //     image: AssetImage('assets/yana_logo.png'),
                  //     fit: BoxFit.fitHeight,
                  //     alignment: Alignment.topCenter,
                  //   ),
                  // ),
                  //Or color
                  color: widget.color,

                  //Column of the "card"
                  child: Column(
                    children: <Widget>[
                      //Title widget the does not change dynamically.
                      Cards_Title(widget.name),
                      //Advert details.
                      Expanded(
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 700),
                          opacity: _isOpen ? 1 : 0,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 2, 0, 10),
                                child: Text(
                                  widget.details,
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    decorationThickness: 2,
                                    wordSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Advert Title Widget for easier use
class Cards_Title extends StatelessWidget {
  @override
  var name;
  Cards_Title(this.name);
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/yana_logo.png'),
            radius: 40.0,
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: Text(
              name,
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                  fontFamily: 'Font2'),
            )),
      ],
    );
  }
}
