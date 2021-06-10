//FLUTTER
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//PAGES
import 'UI/NOTIFICATION/NotificationClasses.dart';
import 'UI/PAGES/Utilities.dart';
//WIDGETS
import 'UI/WIDGETS/allWidgets.dart';
import 'package:overlay_support/overlay_support.dart';
// Do not delete next line!
//AIzaSyAg2GgqVtmCLI6Ge73OdoU2xTYtIW_0Fp0

/// Developers: Lidor Eliyahu Shelef, Yann Ganem, Yisrael Bar-Or and Jonas Sperling

// Global Variables
int currentIndex = MapView_index;

void main()  {
  runApp(
      OverlaySupport(
      child: new MaterialApp(
        home:MainPage(),
        debugShowCheckedModeBanner: false,  /// It removes the debug banner
      ),
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
  late final FirebaseMessaging _messaging;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((value){
      registerNotification();
      checkForInitialMessage();
    });
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
      return Chat(otherInfo);
//      return Chat(this.callback, otherInfo);
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
                children: [
                  ChatsAndEvents(this.callback),
                  SearchView(),
                  MapView(),
                  NoticeBoard(),
                  Settings(this.callback),
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

  void registerNotification() async {
    // 1. Initialize the Firebase app
    //await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    //the Notification token to this device
    String token = await _messaging.getToken()??"";
    print("token = $token");

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        String bodyToShow = "";// = message.notification!.body!.split("#")[0];
        List<String> arr = message.notification!.body!.split("#");
        if(arr.length == 3){
          bodyToShow = arr[2];
        }
        else{
          bodyToShow = arr[0];
        }

        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: bodyToShow,
        );
        print("PushNotification.title = ${message.notification?.title}");
        print("PushNotification.body = ${message.notification?.body}");
        if (notification != null) {

          print(arr);
          bool isMessage = message.notification!.title!.contains("הודעה");
          showSimpleNotification(
              Text(notification.title??"ERROR"),
              subtitle: Text(message.notification!.body!),
              leading: isMessage?Icon(Icons.message):Icon(Icons.notifications),
              background: Colors.pink,
              duration: Duration(seconds: 3),
              trailing: TextButton(
              onPressed: (){
                if(isMessage){
                    //do nothing :)
                }
                else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                }
              },
              child: isMessage?SizedBox(height: 1,):Icon(Icons.arrow_forward_ios_outlined,color: Colors.amber,))
          );
        }


      });


      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    } else {
      print('User declined or has not accepted permission');
    }
  }

}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

/// For handling notification when the app is in terminated state
checkForInitialMessage() async {
  //await Firebase.initializeApp();
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    PushNotification notification = PushNotification(
      title: initialMessage.notification?.title,
      body: initialMessage.notification?.body,
    );
  }

}
