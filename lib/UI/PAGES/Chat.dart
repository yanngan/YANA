import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yana/UI/WIDGETS/allWidgets.dart';
import 'package:yana/UX/LOGIC/CLASSES/Message.dart';
import 'package:intl/intl.dart';
import 'package:yana/UX/LOGIC/CLASSES/firebaseHelper.dart';

import 'Utilities.dart';

// ignore: must_be_immutable
class Chat extends StatefulWidget {

  static List<Message> messages = [];
  /// Other user info map of data
  Map<String, String> otherInfo = new Map<String, String>();
//  Callback function related - See main.dart callback section for more info about it
  final Function callback;
  Chat(this.callback, this.otherInfo);

  @override
  _ChatState createState() => _ChatState();

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
  ScrollController _scrollController = new ScrollController();
  TextEditingController _controllerInput = new TextEditingController();
  List<Message> messages = [];
  TextAlign textAlign = TextAlign.end;
  String messageText = "", _me = "", _meID = "", _him = "", _himID = "";
  double bottomPadding = 14.0, topPadding = 75.0, _keyboardHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _me = userMap['name'].toString();
    _meID = userMap['id'].toString();
    _him = otherInfo['name'].toString();
    _himID = otherInfo['id'].toString();
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
  int lastMsgHeight(String str){
    int _h = 0;
    int occurrences = '\n'.allMatches(str).length;
    if(occurrences <= 1){ return 11; }
    _h = ((occurrences + 3) * 10) + 5;
    return _h;
  }

  /// [inputFieldHeight] - height of the input area
  /// [screenHeight] - The height of the screen minus the status bar + last message height
  @override
  Widget build(BuildContext context){
    /// Timer in order to "scroll" to the last message without the user noticing
    Timer(Duration(microseconds: 1), () => _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent + lastMsgHeight(messages[messages.length - 1].message))
    );

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
//                              Container(
//                                height: inputFieldHeight,
//                                color: bodyColor,
//                                child: Neumorphism(
//                                    null,
//                                    inputFieldHeight,
//                                    sendMsg(),
//                                    type: NeumorphismInner,
//                                    radius: 0.0,
//                                    alignment: Alignment.bottomCenter,
//                                    color: bodyColor
//                                ),
//                              )
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
                height: 100,
                child: MyAppBar(_him, _backButton, height: 100,)
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
            onPressed: (){
              if(messageText.isEmpty){ return; }
              DateTime now = new DateTime.now();
              String formattedDate = new DateFormat('dd-MM-yyyy hh:mm').format(now);
              Message message = Message(_me, _him, _meID, _himID, messageText, formattedDate);
              print(message.toString());
              FirebaseHelper.sendMessageToFb(message);
              _controllerInput.clear();
            },
          ),
        ),
        onChanged: (str){
          setState(() {
            messageText = str.trim();
          });
//        if(value.isNotEmpty){
////          if(regExpEn.hasMatch(value[0].toString()).toString() == "true"){
////            setState(() {
////              textAlign = TextAlign.start;
////            });
////          }else if(regExpHe.hasMatch(value[0].toString()).toString() == "true"){
////            setState(() {
////              textAlign = TextAlign.end;
////            });
////          }else{
////            setState(() {
////              textAlign = TextAlign.start;
////            });
////          }
//          if(abc.contains(value[0])){
//            setState(() {
//              textAlign = TextAlign.start;
//              Fluttertoast.showToast(
//                  msg: "This is Center Short Toast",
//                  toastLength: Toast.LENGTH_SHORT,
//                  gravity: ToastGravity.CENTER,
//                  timeInSecForIosWeb: 1,
//                  backgroundColor: Colors.red,
//                  textColor: Colors.white,
//                  fontSize: 16.0
//              );
//            });
//          }
//        }
        },
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

  /// Method that fires when the user press the back button
  Future<bool> _onBackPressed() async {
    setState(() {
      this.widget.callback(3, userMap, otherInfo, ChatsAndEvents_index);
    });
    return false;
  }

}





