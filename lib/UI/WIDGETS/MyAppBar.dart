import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  /// [title] - [String] the title of the app bar
  /// [action] - [ElevatedButton] or [TextButton] or other version of a button that can be an action, this will be in the actions area of the app bar
  /// [height] - [double] the height of the app bar
  final String title;
  final action;
  final double height;
  // constructor
  MyAppBar(this.title,this.action,{required this.height});

  @override
  Widget build(BuildContext context) {
    if(action == null){
      return AppBar(
        title: Text(title,style: TextStyle(fontSize: 27),),
        centerTitle:true,
        backgroundColor: Colors.pink,
        actions: [],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(1000),
          ),
        ),
      );
    }else{
      return AppBar(
        title: Text(title,style: TextStyle(fontSize: 27),),
        centerTitle:true,
        backgroundColor: Colors.pink,
        actions: [
          action,
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(1000),
          ),
        ),
      );
    }
  }

  /// Lambda method to get the  [height] of the app bar
  Size get preferredSize => new Size.fromHeight(height);

}