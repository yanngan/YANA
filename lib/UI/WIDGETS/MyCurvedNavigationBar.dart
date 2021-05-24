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

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      index: MapView_index,
      height: 50,
      color: Colors.amber[600]!,
      items: <Widget>[
        Icon(Icons.chat, size: 30,color:Colors.red),      /// Chat Page
        Icon(Icons.search, size: 30,color:Colors.red),   /// Search Page
        Icon(Icons.map, size: 30,color:Colors.red),       /// Map Page
        Icon(Icons.dashboard, size: 30,color:Colors.red), /// NoticeBoard Page
        Icon(Icons.settings, size: 30,color:Colors.red),  /// Setting Page
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
