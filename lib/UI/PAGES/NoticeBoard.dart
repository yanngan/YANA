import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../PAGES/Place_Details.dart';

class NoticeBoard extends StatefulWidget {
  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

List<Place_Details> data = [
  Place_Details(kosher: false, name: 'Chez Andi', number: 0258795461),
  Place_Details(kosher: true, name: 'Rimon', number: 0145897859),
  Place_Details(kosher: true, name: 'Katsefet', number: 0212354674),
  Place_Details(kosher: false, name: 'Gueoula', number: 0267889744),
  Place_Details(kosher: true, name: 'KoshTrip', number: 0248985431),
  Place_Details(kosher: true, name: 'KoshTrip', number: 0248985431),
  Place_Details(kosher: true, name: 'KoshTrip', number: 0248985431),
  Place_Details(kosher: true, name: 'KoshTrip', number: 0248985431),
  Place_Details(kosher: true, name: 'KoshTrip', number: 0248985431),
  Place_Details(kosher: true, name: 'KoshTrip', number: 0248985431),
  Place_Details(kosher: true, name: 'KoshTrip', number: 0248985431),
];

class _NoticeBoardState extends State<NoticeBoard> {
  @override
  void initState() {
    super.initState();
    initPlacesList();   // In order to populate our Advertisement list
    //Here will be the sorting of the data coming from firebase
  }

  List<Advertisement> advertisements = [];

  void initPlacesList(){
    for(int i = 0; i < 10; i++){
      if(i % 2 == 0){
        advertisements.add(Advertisement(Colors.purple[200]!, data[i].getName(),
            data[i].getKosher(), data[i].getNumber(), Colors.grey[900]!));
      }else{
        advertisements.add(Advertisement(Colors.purple[400]!, data[i].getName(),
            data[i].getKosher(), data[i].getNumber(), Colors.grey[400]!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: ListView(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 0, 80),
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
      // child: Center(child: Text("NoticeBoard Hi")),
    );
  }
}

class Advertisement extends StatefulWidget {
  // const Advert({
  //   Key key,
  // }) : super(key: key);
  String name;
  bool kosher;
  int number;
  Color color;
  Color expsiontilecolor;

  Advertisement(this.color, this.name, this.kosher, this.number,
      this.expsiontilecolor);

  @override
  _AdvertisementState createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  double _width = 200;
  double _height = 150;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.fromLTRB(6, 6, 6, 4.0),
      duration: Duration(milliseconds: 735),
      child: Column(
        children: <Widget>[
          Image(
              image: AssetImage(
                  'assets/yana_logo.png'
              )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0)
            ),
          ),
          ExpansionTile(
            tilePadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
            title: Text(widget.name,
              style: TextStyle(
                  fontFamily: 'Font2',
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: widget.expsiontilecolor
              ),),
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(28),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20.0, 0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/yana_logo.png'
                        ),
                        radius: 40.0,
                      ),
                    ),
                    Text(
                      'Hi everyone ! \n'
                          'My name sdi Jonas\n'
                          'Waht for u ?\n'
                          'gergfvzvsfze\n'
                          'egrregergegre\n'
                          'gertggrege\n'
                          'tjytujtyaizejz',

                      style: TextStyle(
                        backgroundColor: Colors.black.withOpacity(0.5),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}