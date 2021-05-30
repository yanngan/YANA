//FLUTTER
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//PAGES
import 'PAGES/Utilities.dart';
//WIDGETS
import 'WIDGETS/allWidgets.dart';
// Do not delete next line!
//AIzaSyAg2GgqVtmCLI6Ge73OdoU2xTYtIW_0Fp0

/// Developers: Lidor Eliyahu Shelef, Yann Ganem, Yisrael Bar-Or and Jonas Sperling

// Global Variables
int currentIndex = MapView_index;

void main()  {
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
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return applicationSetup();
  }

//  callback function in order to allow moving between login sign up and the inner area of the application
  void callback(int type, Map<String, String> credentials, Map<String, String> _otherInfo, int _pageIndex) {
    setState(() {
      pageType = type;
      userMap = credentials;
      otherInfo = _otherInfo;
      currentIndex = _pageIndex;
      pageController = PageController(initialPage:currentIndex, keepPage: true,);
    });
  }

  Widget applicationSetup(){
    if(pageType >= 0 && pageType <= 2){
      if(pageType == 0){
        return Welcome(this.callback);
      }else if(pageType == 1){
        return SignUp(this.callback, userMap);
      }else { // pageType == 2
        return Login(this.callback);
      }
    }else if(pageType == 4){
      return Chat(this.callback, otherInfo);
    }else if(pageType == 3){
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
                    case ChatsAndEvents_index:
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
                    case Chat_index:
                      break;
                    case ChatsAndEvents_index:
                      hideBottomNavigationBar = false;
                      break;
                  }
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: [   // TODO add the same to them as in SignUp.dart at lines ~ 25-27 (26 not sure, consult Lidor)
                  ChatsAndEvents(this.callback),
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
