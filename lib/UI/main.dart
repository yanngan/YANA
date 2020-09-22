//FLUTTER
import 'package:flutter/material.dart';
//PAGES
import 'PAGES/AllPage.dart';
//WEDGETS
import 'WIDGETS/allWidgets.dart';

/// Developers: Lidor Eliyahu & Yann Ganem

void main()=>runApp(MaterialApp(home:MainPage(),));


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool hideAppBar = true;
  bool hideBottomNavigationBar = false;
  PageController pageController = PageController(initialPage:MapView_index);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        bottomNavigationBar: hideBottomNavigationBar?null:MyCurvedNavigationBar(pageController),
        body: PageView(
          pageSnapping: true,
          physics:new NeverScrollableScrollPhysics(),
          onPageChanged: (index){
            FocusScope.of(context).unfocus();
            print(index);
            hideBottomNavigationBar = true;
            switch(index){
              case Welcome_index: break;
              case Login_index: break;
              case SingUp_index: break;
              case MapView_index:hideBottomNavigationBar = false; break;
              case SearchView_index:hideBottomNavigationBar = false; break;
              case Settings_index:hideBottomNavigationBar = false; break;
              case ChatList_index:hideBottomNavigationBar = false; break;
              case Chat_index:hideBottomNavigationBar = false; break;
              case NoticeBoard_index:hideBottomNavigationBar = false; break;
            }
            //setState((){});
          },
          controller: pageController,
          children: [
            Welcome(),
            Login(),
            SingUp(),
            MapView(),
            SearchView(),
            Settings(),
            ChatList(),
            Chat(),
            NoticeBoard(),
          ],
        ),
      ),
    );
  }


  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure'),
        content: new Text('do you want to exit the app?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??false;
  }
}