//FLUTTER
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
//PAGES
import '../PAGES/AllPage.dart';


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
      color: Colors.red[600],
      items: <Widget>[
        Icon(Icons.chat, size: 30,color:Colors.amber),
        Icon(Icons.zoom_in, size: 30,color:Colors.amber),
        Icon(Icons.map, size: 30,color:Colors.amber),
        Icon(Icons.dashboard, size: 30,color:Colors.amber),
        Icon(Icons.settings, size: 30,color:Colors.amber),
      ],
      onTap: (index) {
        int pageIndex;
        switch (index){
          case 0: pageIndex = ChatList_index;break;
          case 1: pageIndex = SearchView_index;break;
          case 2: pageIndex = MapView_index;break;
          case 3: pageIndex = NoticeBoard_index;break;
          case 4: pageIndex = Settings_index;break;
        }
        pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 500),curve: Curves.bounceInOut);
      },
    );
  }
}
