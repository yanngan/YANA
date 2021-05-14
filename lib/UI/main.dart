//FLUTTER
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//PAGES
import 'PAGES/AllPage.dart';
//WIDGETS
import 'WIDGETS/allWidgets.dart';
// Do not delete next line!
//AIzaSyAg2GgqVtmCLI6Ge73OdoU2xTYtIW_0Fp0

/// Developers: Lidor Eliyahu Shelef, Yann Ganem, Yisrael Bar-Or and Jonas Sperling

// Global Variables
int currentIndex = MapView_index;

void main() async {
  await Firebase.initializeApp();
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
  void initState() {
    super.initState();
    // TODO This is for testing SIGNUP only!!! remove before you push it!
    _logOut();
  }

  @override
  Widget build(BuildContext context) {
    return applicationSetup();
  }

//  callback function in order to allow moving between login sign up and the inner area of the application
  void callback(int type) {
    setState(() {
      pageType = type;
    });
  }

  Widget applicationSetup(){
    if(pageType >= 0 && pageType <= 2){
      if(pageType == 0){
        return Welcome(this.callback);
      }else if(pageType == 1){
        return SignIn(this.callback);
      }else { // pageType == 2
        return Login(this.callback);
      }
    }else if(pageType > 2 && pageType < 4){
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
    if(pageType == 3) {
      return Scaffold(
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
                    case SingUp_index:
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
                    child: hideBottomNavigationBar ? SizedBox(height: 0, width: 0,) : MyCurvedNavigationBar(pageController),
//                      child: hideBottomNavigationBar ? null : MyCurvedNavigationBar(pageController),
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

  Future<void> _logOut() async {
    await FacebookAuth.instance.logOut();
    setState(() {});
  }

  Future<bool> _onBackPressed() async {
    bool finalResult = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: Text('Exiting the app'),
        elevation: 24.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You want to exit the app? Should we log you out of Facebook as well?'),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("I want to stay"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Exit, but keep me logged in"),
            ),
            TextButton(
              onPressed: () {
                _logOut();
                Navigator.of(context).pop(true);
              },
              child: Text("Exit and log me out"),
            ),
          ],
        ),
      ),
    );
    return finalResult;
  }



}