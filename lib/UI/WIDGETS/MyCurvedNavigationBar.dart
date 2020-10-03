//FLUTTER
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
//PAGES
import '../PAGES/AllPage.dart';


// ignore: must_be_immutable
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
      backgroundColor: Colors.amber,
      animationCurve: Curves.easeInOut,
      index: MapView_index,
      height: 55,
      color: Colors.red[600],
      items: <Widget>[
        Icon(Icons.chat, size: 30,color:Colors.amber),      /// Chat Page
        Icon(Icons.zoom_in, size: 30,color:Colors.amber),   /// Search Page
        Icon(Icons.map, size: 30,color:Colors.amber),       /// Map Page
        Icon(Icons.dashboard, size: 30,color:Colors.amber), /// NoticeBoard Page
        Icon(Icons.settings, size: 30,color:Colors.amber),  /// Setting Page
      ],
      onTap: (index) {
        //No Need for the commented one + it cuases problems, I fixed the indexes
//        int pageIndex = 0;
//        switch (index){
//          case 0:
//            pageIndex = ChatList_index;
//            break;
//          case 1:
//            pageIndex = SearchView_index;
//            break;
//          case 2:
//            pageIndex = MapView_index;
//            break;
//          case 3:
//            pageIndex = NoticeBoard_index;
//            break;
//          case 4:
//            pageIndex = Settings_index;
//            break;
//        }
        setState(() {
          pageController.animateToPage(
//              pageIndex,
            index,
              duration: Duration(milliseconds: 500),curve: Curves.ease
          );
        });
      },
    );
  }
}
