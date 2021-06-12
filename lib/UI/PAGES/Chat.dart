import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yana/UI/WIDGETS/allWidgets.dart';
import 'package:yana/UX/DB/allDB.dart';
import 'package:yana/UX/LOGIC/Profanity.dart';
import 'package:yana/UX/LOGIC/CLASSES/Message.dart';
import 'package:intl/intl.dart';
import 'package:yana/UX/LOGIC/CLASSES/firebaseHelper.dart';
import 'package:yana/UX/LOGIC/Logic.dart';
import 'Utilities.dart';

// ignore: must_be_immutable
class Chat extends StatefulWidget {

  /// [messages] - [List] of [Message] holding all this current chat messages
  /// [userCredentials] - [Map] holding the other [User] information
  static List<Message> messages = [];
  Map<String, String> _otherInfo = new Map<String, String>();
  // constructor
  Chat(this._otherInfo);

  @override
  _ChatState createState() => _ChatState(this._otherInfo);

}

class _ChatState extends State<Chat> {

  /// [_scrollController] - Controller for the chat scrolling logic
  /// [_controllerInput] - [TextField] controller in order to apply the input changes
  /// [messages] - List of all the chat history [List] of [Message]
  /// [textAlign] - Text align object in order to determine which  side of the screen the message will be
  /// [messageText] - Text of each message
  /// [_me] - Current user name
  /// [_meID] - Current user ID
  /// [_him] - Other user name
  /// [_himID] - Other user ID
  /// [bottomPadding], [topPadding] - Top / Bottom padding
  /// [_keyboardHeight] - The height of the keyboard by default ( in order to keep looks when the keyboard is open )
  /// [_otherInfo] - [Map] holding the other [User] information
  /// [profanityList] - [List] of [String] made from few other [List]s containing all the profanity words we check in each language we support
  ScrollController _scrollController = new ScrollController();
  TextEditingController _controllerInput = new TextEditingController();
  List<Message> messages = [];
  TextAlign textAlign = TextAlign.end;
  String messageText = "", _me = "", _meID = "", _him = "", _himID = "";
  double bottomPadding = 14.0, topPadding = 75.0, _keyboardHeight = 0.0;
  Map<String, String> _otherInfo = new Map<String, String>();
  List<String> profanityList = new List.from(englishProfanityList)
                                      ..addAll(hebrewProfanityList)
                                      ..addAll(arabicProfanityList);
  // constructor
  _ChatState(this._otherInfo);

  @override
  void initState() {
    super.initState();

    _me = userMap['name'].toString();
    _meID = userMap['userID'].toString();
    _him =  _otherInfo['name'].toString();
    _himID =_otherInfo['userID'].toString();

    getMessages();
  }

  /// Method to get all the messages
  void getMessages() {
   final databaseReference = FirebaseDatabase.instance.reference();
   DatabaseReference messageRef = databaseReference.child('rooms/').child(_meID).child(_himID);
   messageRef.onValue.listen((event) {
     var snapshot = event.snapshot;
     messages.clear();
     if(snapshot.value == null){
       return;
     }
     Map<dynamic, dynamic> values = snapshot.value;
     values.forEach((key, values) {
       setState(() {
         messages.add(Message.fromJson(values));
       });
       }
      );
     }
   );
  }

  /// Method to get the last message height in order to apply extra padding
  /// [str] - A [String] representing the last message of the current chat
  int lastMsgHeight(String str){
    int _h = 0;
    int occurrences = '\n'.allMatches(str).length + 1;
    if(occurrences >= 1) {
      _h = ((occurrences + 3) * 11) + 7;
    }
    return _h;
  }

  /// [inputFieldHeight] - height of the input area
  /// [screenHeight] - The height of the screen minus the status bar + last message height
  @override
  Widget build(BuildContext context){
    /// Timer in order to "scroll" to the last message without the user noticing
    if(messages.length > 1){
      Timer(Duration(microseconds: 1), () {
          _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent
                  + lastMsgHeight(messages[messages.length - 1].message)
          );
        }
      );
    }

    double inputFieldHeight = (MediaQuery.of(context).size.height / 11);
    double screenHeight = (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top);

    checkKeyboard();

    var _backButton = Padding(
      padding: EdgeInsets.only(right: 25.0),
      child: TextButton(
        child: Icon(Icons.arrow_forward_ios, color: Colors.black,),
          onPressed: (){
            _onBackPressed();
          },
      ) ,
    );

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.amberAccent,
        body: Stack(
          children: [
            SafeArea(
              child: Stack(
                children: [
                  Container(
                    height: screenHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Container(
                            alignment: Alignment.topCenter,
                            color: bodyColor,
                            child: ListView.separated(
                              controller: _scrollController,
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(height: 15);
                              },
                              shrinkWrap: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index){
                                String flag = NeumorphismOuter;
                                String _text = messages[index].message;
                                var msgColor;
                                Alignment msgAlignment;
                                if(messages[index].selfName == _me){
                                  msgColor = senderColor;
                                  msgAlignment = Alignment.centerRight;
                                }else{
                                  msgColor = receiverColor[300];
                                  msgAlignment = Alignment.centerLeft;
                                }
                                if(index == 0){
                                  return Padding(
                                    padding: EdgeInsets.only(top: topPadding),
                                    child: Neumorphism(
                                      null,
                                      null,
                                      Text(_text),
                                      type: flag,
                                      radius: 32.0,
                                      alignment: msgAlignment,
                                      color: msgColor,
                                    ),
                                  );
                                }else if(index == (messages.length - 1)){
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: bottomPadding),
                                    child: Neumorphism(
                                      null,
                                      null,
                                      Text(_text),
                                      type: flag,
                                      radius: 32.0,
                                      alignment: msgAlignment,
                                      color: msgColor,
                                    ),
                                  );
                                }else{
                                  return Neumorphism(
                                    null,
                                    null,
                                    Text(_text),
                                    type: flag,
                                    radius: 32.0,
                                    alignment: msgAlignment,
                                    color: msgColor,
                                  );
                                }
                              },
                            ),
                          ),
                        ),  // Chat Messages Area
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),  // Input Message Area
                      ],
                    ),
                  ),  // Messages History
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: inputFieldHeight,
                      color: bodyColor,
                      child: Neumorphism(
                        null,
                        inputFieldHeight,
                        sendMsg(),
                        type: NeumorphismInner,
                        radius: 0.0,
                        alignment: Alignment.bottomCenter,
                        color: bodyColor
                      ),
                    ),
                  ),  // Input field
                ],
              ),
            ),
            SizedBox(
                height: appBarHeight,
                child: MyAppBar(_him, null, height: appBarHeight,)
            ),
          ],
        ),
      ),
    );
  }

  /// Method that send a message to the firebase database
  Widget sendMsg() {
    RegExp regExpEn = new RegExp(
      r"([A-Z,a-z])",
      caseSensitive: false,
      multiLine: false,
    );
    RegExp regExpHe = new RegExp(
      r"(אבגדהוזחטיכךלמםנןסעפףצץקרשת])",
      caseSensitive: false,
      multiLine: false,
    );
    var abc = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: new TextField(
        inputFormatters: [
          WhitelistingTextInputFormatter(
            RegExp(
              r'[a-zA-Z0-9אבגדהוזחטיכךלמםנןסעפףצץקרשתАаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЫыЬьЭэЮюЯя_=!@#$&()\\-`. ?:+ ,/\"+×÷=/_€£¥₪*^%:;,~<>{}[]]*',
              multiLine: true,
              caseSensitive: false,
            )
          )
        ],
        controller: _controllerInput,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: 'הקלד הודעה...',
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: ()async{
              /// Getting the message from the input box
              messageText = _controllerInput.text.toString().trim();
              if(messageText.isEmpty){ return; }

              /// Check if the message is free of Curses and Profanity words
              if (hasProfanity(messageText))
                {
                  List<String> wordsFound = getAllProfanity(messageText);
                  _makeToast("תוכן הבא זוהה כפוגעני: "+wordsFound.toString(), Colors.red);
                  return;
                }
              _controllerInput.clear();

              DateTime now = new DateTime.now();
              String formattedDate = new DateFormat('dd-MM-yyyy hh:mm').format(now);
              /// Assemble the message and send via firebase to the other user
              Message message = Message(_me, _him, _meID, _himID, messageText, formattedDate);
              FirebaseHelper.sendMessageToFb(message);

              /// Send a notification to other user to tell him he got a new message
              /// Get other user token
              String otherToken =  await FirebaseHelper.getTokenNotificationForAUser(_himID);
              if(otherToken.isEmpty){
                return;
              }
              String title = NotificationTitle;
              String body = "$_me ${"שלח/ה לך הודעה"}"; //will be formated: <the text to show>#<userID>#<name>
              Logic.sendPushNotificationsToUsers([otherToken], title, body);
            },
          ),
        ),
      ),
    );
  }

  /// Method that checks if the keyboard is open and if he is, updated the bottom padding accordingly
  void checkKeyboard() {
    _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    double _bp = 0.0;
    if(_keyboardHeight > 0){
      _bp = 48.0;
    }else{
      _bp = 14.0;
    }
    setState(() {
      bottomPadding = _bp;
    });
  }

  /// Display on screen the Profanity words
  /// [str] - Toast text
  /// [theColor] - Toast background color
  _makeToast(String str, var theColor) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: theColor,
        textColor: Colors.amber,
        fontSize: 16.0
    );
  }

  /// Check if in a given string there is a Profanity words
  /// [inputString] - The given [String] input from the user that we need to check for profanity
  bool hasProfanity(String inputString) {
    bool isProfane = false;
    List<String> messageTextList= inputString.toLowerCase().trim().split(' ');
    messageTextList.forEach((element) {
      if( profanityList.contains(element) ){
            isProfane = true;
      }
    });
    return isProfane;
  }

  /// Return all the Profanity words that the user tried to send
  /// [inputString] - A [String] we need to retrieve all the profanity words that it contains
  List<String> getAllProfanity(String inputString) {
    List<String> found = [];
    profanityList.forEach((word) {
      if (inputString.toLowerCase().contains(word)) {
        found.add(word);
      }
    });
    return found;
  }

  /// Callback function for the user back button press
  Future<bool> _onBackPressed() async {
    setState(() {
//      this.widget.callback(3, userMap, otherInfo, ChatsAndEvents_index);
      Navigator.pop(context);
    });
    return false;
  }

}





