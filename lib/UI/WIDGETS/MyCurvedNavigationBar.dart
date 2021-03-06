import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../PAGES/Utilities.dart';

// ignore: must_be_immutable
class MyCurvedNavigationBar extends StatefulWidget {

  /// [pageController] - Controller that allows us to control the navigation bar
  PageController pageController;
  // constructor
  MyCurvedNavigationBar(this.pageController);

  @override
  _MyCurvedNavigationBarState createState() => _MyCurvedNavigationBarState(pageController);

}

class _MyCurvedNavigationBarState extends State<MyCurvedNavigationBar> {

  /// [pageController] - Controller that allows us to control the navigation bar
  /// [_iconHeight] - Each icon desired height
  /// [_fontSize] - Each icon text font size
  PageController pageController;
  double _iconHeight = 25.0, _fontSize = 9.0;
  // constructor
  _MyCurvedNavigationBarState(this.pageController);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      index: MapView_index,
      height: 60,
      color: Colors.amber[600]!,
      items: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10,),
              Icon(Icons.dashboard, size: _iconHeight, color:Colors.red),
              Text("אירועים     \nוצ'אטים     ", style: TextStyle(fontSize: _fontSize, color:Colors.red[700]), textAlign: TextAlign.center,),
            ],
          ),
        ),  /// Chat \ Locations Page
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search, size: _iconHeight, color:Colors.red),
              Text(" חיפוש ", style: TextStyle(fontSize: _fontSize, color:Colors.red[700]), textAlign: TextAlign.center,),
            ],
          ),
        ),  /// Search Page
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.map, size: _iconHeight, color:Colors.red),
              Text(" מפה ", style: TextStyle(fontSize: _fontSize, color:Colors.red[700]), textAlign: TextAlign.center,),
            ],
          ),
        ),  /// Map Page
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.campaign, size: _iconHeight, color:Colors.red),
              Text(" לוח מודעות ", style: TextStyle(fontSize: _fontSize, color:Colors.red[700]), textAlign: TextAlign.center,),
            ],
          ),
        ),  /// BulletinBoard Page
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.settings, size: _iconHeight, color:Colors.red),
              Text(" הגדרות ", style: TextStyle(fontSize: _fontSize, color:Colors.red[700]), textAlign: TextAlign.center,),
            ],
          ),
        ),  /// Setting Page
      ],
      onTap: (index) {
        pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 500),curve: Curves.easeInOut
        );
      },
    );
  }

}

