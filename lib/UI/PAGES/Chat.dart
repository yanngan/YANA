import 'package:flutter/material.dart';
import 'package:yana/UX/DB/users.dart';

class Chat extends StatefulWidget {
  // User user;
  // const Chat(
  //   this.user,
  //    Key? key,
  // ) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) => Scaffold(
    extendBodyBehindAppBar: true,
    backgroundColor: Colors.blue,
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     color: Colors.amber,
  //     child: Center(child: Text("Chat")),
  //   );
  // }
}




