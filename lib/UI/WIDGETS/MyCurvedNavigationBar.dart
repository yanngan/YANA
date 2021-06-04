import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../PAGES/Utilities.dart';

class MyCurvedNavigationBar extends StatefulWidget {

  PageController pageController;
  MyCurvedNavigationBar(this.pageController);

  @override
  _MyCurvedNavigationBarState createState() => _MyCurvedNavigationBarState(pageController);

}

class _MyCurvedNavigationBarState extends State<MyCurvedNavigationBar> {

  PageController pageController;
  _MyCurvedNavigationBarState(this.pageController);
  double _iconHeight = 25.0, _fontSize = 9.0;

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      index: MapView_index,
      height: 55,
      color: Colors.amber[600]!,
      items: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard, size: _iconHeight, color:Colors.red),
              Text("Chats\nEvents", style: TextStyle(fontSize: _fontSize, color:Colors.red[700]), textAlign: TextAlign.center,),
            ],
          ),
        ),  /// Chat \ Locations Page
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: _iconHeight, color:Colors.red),
              Text("Search", style: TextStyle(fontSize: _fontSize, color:Colors.red[700]), textAlign: TextAlign.center,),
            ],
          ),
        ),  /// Search Page
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map, size: _iconHeight, color:Colors.red),
              Text("Map", style: TextStyle(fontSize: _fontSize, color:Colors.red[700]), textAlign: TextAlign.center,),
            ],
          ),
        ),  /// Map Page
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.campaign, size: _iconHeight, color:Colors.red),
              Text("Bulletin\nBoard", style: TextStyle(fontSize: _fontSize, color:Colors.red[700]), textAlign: TextAlign.center,),
            ],
          ),
        ),  /// BulletinBoard Page
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.settings, size: _iconHeight, color:Colors.red),
              Text("Settings", style: TextStyle(fontSize: _fontSize, color:Colors.red[700]), textAlign: TextAlign.center,),
            ],
          ),
        ),  /// Setting Page
      ],
      onTap: (index) {
        setState(() {
          pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 500),curve: Curves.ease
          );
        });
      },
    );
  }
}
