import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final action;
  final double height;
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
  Size get preferredSize => new Size.fromHeight(height);
}