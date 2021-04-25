import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget  {
  String title;
  var action;
  double hieght;
  MyAppBar(this.title,this.action,{this.hieght});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,style: TextStyle(fontSize: 30),),
      centerTitle:true,
      backgroundColor: Colors.pink,
      actions: [],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(1000),
        ),
      ),
    );
  }
  Size get preferredSize => new Size.fromHeight(hieght ?? kToolbarHeight);
}

