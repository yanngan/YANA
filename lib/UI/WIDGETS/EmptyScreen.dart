import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EmptyScreen extends StatefulWidget {

  /// [text] - [String] that will appear on the empty screen
  /// [maxLines] - [int] representing the max number of lines we allow - default is 2
  String text;
  int maxLines = 2;
  // constructor
  EmptyScreen({this.maxLines = 2, required this.text});

  @override
  _EmptyScreenState createState() => _EmptyScreenState(maxLines: this.maxLines, text: this.text);

}

class _EmptyScreenState extends State<EmptyScreen> {

  /// [text] - [String] that will appear on the empty screen
  /// [maxLines] - [int] representing the max number of lines we allow - default is 2
  String text;
  int maxLines = 2;
  // constructor
  _EmptyScreenState({this.maxLines = 2, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(
        child: SizedBox(
          width: (MediaQuery.of(context).size.width / 1.5),
          child: AutoSizeText(
            text,
            textDirection: TextDirection.rtl,
            maxLines: this.maxLines,
            style: TextStyle(fontSize: 1000.0, color: Colors.black.withOpacity(0.65), fontFamily: 'FontSkia'),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

}

