//FLUTTER
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//PAGES
import 'PAGES/AllPage.dart';
//WIDGETS
import 'WIDGETS/allWidgets.dart';
//AIzaSyAg2GgqVtmCLI6Ge73OdoU2xTYtIW_0Fp0

/// Developers: Lidor Eliyahu Shelef, Yann Ganem, Yisrael Bar-Or and Jonas Sperling

// Global Variables
int currentIndex = MapView_index;

void main(){
  runApp(
    new MaterialApp(
      home:MainPage(),
      debugShowCheckedModeBanner: false,  /// It removes the debug banner
    )
  );
}

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool hideAppBar = true;
  bool hideBottomNavigationBar = false;
  PageController pageController = PageController(initialPage:currentIndex, keepPage: true,);
  @override
  Widget build(BuildContext context) {
    return applicationSetup();
  }

  void callback(int type) {
    setState(() {
      pageType = type;
    });
  }

  Widget applicationSetup(){
    if(pageType == 0){
      return Welcome(this.callback);
    }else if(pageType > 0 && pageType < 4){
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: innerApplication(),
      );
    }else{
      return Container(
        child: Text("Some Error happened with the pageType: $pageType"),
      );
    }
  }

  Widget innerApplication(){
    if(pageType == 1){
      return SignIn();
    }else if(pageType == 2){
      return Login();
    }else if(pageType == 3) {
      return Scaffold(
//        bottomNavigationBar: hideBottomNavigationBar
//            ? null
//            : MyCurvedNavigationBar(pageController),
        body:Scaffold(
          body: Stack(
            children: <Widget>[
              PageView(
                controller: pageController,
                pageSnapping: true,
                physics: new NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  FocusScope.of(context).unfocus();
                  print(index);
                  hideBottomNavigationBar = true;
                  switch (index) {
                    case Chat_index:
                      hideBottomNavigationBar = false;
                      break;
                    case SearchView_index:
                      hideBottomNavigationBar = false;
                      break;
                    case MapView_index:
                      hideBottomNavigationBar = false;
                      break;
                    case NoticeBoard_index:
                      hideBottomNavigationBar = false;
                      break;
                    case Settings_index:
                      hideBottomNavigationBar = false;
                      break;
                    case Welcome_index:
                      break;
                    case Login_index:
                      break;
                    case SingIn_index:
                      break;
                    case ChatList_index:
                      hideBottomNavigationBar = false;
                      break;
                  }
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: [
                  Chat(),
                  SearchView(),
                  MapView(),
                  NoticeBoard(),
                  Settings(),
      //            Welcome(),
      //            Login(),
      //            SingUp(),
      //            ChatList(),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                      data: Theme.of(context)
                          .copyWith(canvasColor: Colors.transparent),
                      child: hideBottomNavigationBar
                          ? null
                          : MyCurvedNavigationBar(pageController),
                  )
              ),
            ],
          ),
        ),




      );
    }else{
      return Container(
        child: Text("Some Error happened with the pageType: $pageType"),
      );
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure'),
        content: new Text('you want to log out?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: (){
              Navigator.of(context).pop(false);
            },
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () {
              this.callback(0);
              Navigator.pop(context);
            },
            child: Text("YES"),
          ),
        ],
      ),
    ) ??false;
  }

}