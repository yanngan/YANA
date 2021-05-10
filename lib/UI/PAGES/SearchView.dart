import '../../UX/LOGIC/CLASSES/allClasses.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../WIDGETS/MyAppBar.dart';
import '../../UX/LOGIC/Logic.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  // bool _initstate = false;

  // List<Event> _events = [];

  var _eventsList;
  // @override
  // void init() async {
  //     _events = await Logic.getEventsByCondition();
  //   setState(() {
  //     print(_events);
  //     _initstate = true;
  //   });
  // }

  void sendToFb() async {
    await Firebase.initializeApp();
    await sendPlace();
  }

  dynamic sendPlace() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var place1 = new Places(
        "placeID",
        "address2",
        "pho111neNumbe2",
        "representative",
        10,
        "vibe",
        true,
        "openingHours",
        "name",
        18,
        "webLink.com",
        "googleMapLink.com");
    //write to collection
    firestore
        .collection('Places')
        .doc(place1.placeID)
        .set(place1.toJson())
        .then((_) {
      print("success!");
    });

    //read from collection
    FirebaseFirestore.instance
        .collection('Places')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["placeID"]);
        print(doc);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.amber,
    //   child: Center(child: Text("SearchView")),
    // );
    // if(!_initstate){
    //   initState();
    // }
    double topPad = (MediaQuery.of(context).size.height / 10);
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Container(
        child: Stack(
          children: [
            Container(
              child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.only(top: topPad),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 36, 20),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Note Title',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Note text',
                                    style: TextStyle(color: Colors.grey[900]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (index == 19) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: topPad),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 36, 20),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Note Title',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Note text',
                                    style: TextStyle(color: Colors.grey[900]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 36, 20),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Note Title',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Note text',
                                  style: TextStyle(color: Colors.grey[900]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }),
            ),
            SizedBox(
                height: 120,
                child: MyAppBar(
                    "Search",
                    TextButton(
                      child: Icon(Icons.search),
                      onPressed: () => {},
                    ),
                    height: 120)),
          ],
        ),
      ),
      extendBody: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: FloatingActionButton(
          child: Icon(Icons.search),
          splashColor: Colors.amber,
          backgroundColor: Colors.pink,
          onPressed: () => {print('Button Pressed')},
        ),
      ),
    );
  }
}
