import 'package:flutter/material.dart';
import 'package:yana/UI/PAGES/Utilities.dart';

/// [Neumorphism] class defines 3 types of widgets ( with 3 different shapes ):
/// 1) Concave Neumorphism shape
/// 2) Flat Neumorphism shape
/// 3) Emboss Neumorphism shape
@override
class Neumorphism extends StatefulWidget{

  /// [type], [radius], [alignment], [color] must not be null, it's required
  /// [type] - defines which kind of widget it will be
  /// [_textObj] - the text widget, holding the display text
  /// [_width] - width of container
  /// [_height] - height of container
  /// [radius] - corners radius
  /// [alignment] - widget alignment
  /// [color] - background color
  final _textObj;
  final _width;
  final _height;
  final String type;
  final radius;
  final alignment;
  final color;
  // constructor
  Neumorphism(
    this._width,
    this._height,
    this._textObj,
    {
      required this.type,
      required this.radius,
      required this.alignment,
      required this.color
    }
  );

  @override
  _NeumorphismState createState() => _NeumorphismState(
      this._width,
      this._height,
      this._textObj,
      type: this.type,
      radius: this.radius,
      alignment: this.alignment,
      color: this.color
  );

}

class _NeumorphismState extends State<Neumorphism> {

  /// [type], [radius], [alignment], [color] must not be null, it's required
  /// [type] - defines which kind of widget it will be
  /// [_textObj] - the text widget, holding the display text
  /// [_width] - width of container
  /// [_height] - height of container
  /// [radius] - corners radius
  /// [alignment] - widget alignment
  /// [color] - background color
  final _textObj;
  final _width;
  final _height;
  final String type;
  final radius;
  final alignment;
  final color;
  // constructor
  _NeumorphismState(
    this._width,
    this._height,
    this._textObj,
    {
      required this.type,
      required this.radius,
      required this.alignment,
      required this.color
    }
  );

  @override
  Widget build(BuildContext context) {
    switch(this.type){
      case NeumorphismOuterChip:
        /// returns a concave neumorphism shape widget - limited to 1 row of text
        return neumorphismOuterChip(this._textObj, this.radius, this.alignment, this.color);
      case NeumorphismOuter:
      /// returns a flat neumorphism shape widget
        return neumorphismOuter(this._width, this._height, this._textObj, this.radius, this.alignment, this.color);
      case NeumorphismInner:
      /// returns a emboss neumorphism shape widget - limited to 1 row of text
        return neumorphismInner(this._width, this._height, this._textObj, this.radius, this.alignment, this.color);
      default:
        return Text('Some error occurred please try again.');
    }
  }

  /// Limited to 1 row only, an icon can be added as well
  /// @width  - max is 2/3 of screen width - min is 20 pixels
  /// @height  - max is 2.5/3 of screen height - min is 25 pixels
  /// [_t] : text object
  /// [_r] : radius
  /// [_a] : alignment
  /// [_c] : background color
  Widget neumorphismOuterChip( _t, _r, _a, _c){
    // Max width and height for the widget
    double _maxWidth = ((MediaQuery.of(context).size.width / 3) * 2);
    double _maxHeight = ((MediaQuery.of(context).size.height / 3) * 2.5);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Align(
        alignment: _a,
        child: Container(
          constraints: BoxConstraints(minWidth: 20, maxWidth: _maxWidth, minHeight: 25.0, maxHeight: _maxHeight),
          child: Chip(
            backgroundColor: _c,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(_r))),
            elevation: 3.5,
            label: _t,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
    );
  }

  /// multi rows enabled, an icon can be added as well
  /// [_w] : width  - max is 2/3 of screen width - min is 20 pixels
  /// [_h] : height  - max is 2.5/3 of screen height - min is 25 pixels
  /// [_t] : text object
  /// [_r] : radius
  /// [_a] : alignment
  /// [_c] : background color
  Widget neumorphismOuter(_w, _h, _t, _r, _a, _c){
    // Max width and height for the widget
    double _maxWidth = ((MediaQuery.of(context).size.width / 3) * 2);
    double _maxHeight = ((MediaQuery.of(context).size.height / 3) * 2.5);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Align(
        alignment: _a,
        child: Container(
          constraints: BoxConstraints(minWidth: 20, maxWidth: _maxWidth, minHeight: 25.0, maxHeight: _maxHeight),
          width: _w,
          height: _h,
          decoration: BoxDecoration(
            color: _c,
            borderRadius: BorderRadius.all(Radius.circular(_r)),
            boxShadow: [
              BoxShadow(
                blurRadius: 15.0,
                offset: Offset(-3.0, -2.0),
                color: Colors.white.withOpacity(0.3),
                spreadRadius: 0.5,
              ),
              BoxShadow(
                blurRadius: 13.0,
                offset: Offset(3.2, 2.2),
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 0.5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 14, right: 14),
            child: _t,
          ),
        ),
      ),
    );
  }

  /// multi rows enabled, an icon can be added as well, default size is full screen
  /// [_w] : width  - max is 2/3 of screen width - min is 20 pixels
  /// [_h] : height  - max is 2.5/3 of screen height - min is 25 pixels
  /// [_t] : text object
  /// [_r] : radius
  /// [_a] : alignment
  /// [_c] : background color
  Widget neumorphismInner(_w, _h, _t, _r, _a, _c){
    if(_width == null || _width == 0){
      _w = ((MediaQuery.of(context).size.width / 100) * 99);
    }
    if(_height == null || _height == 0){
      _h = ((MediaQuery.of(context).size.height / 10) * 9);
    }
    // Max width and height for the widget
    double _maxWidth = (MediaQuery.of(context).size.width - 5);
    double _maxHeight = ((MediaQuery.of(context).size.height / 3) * 2.5);
    return Align(
      alignment: _a,
      child: Stack(
        children: [
          Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: _maxWidth, minHeight: 25.0, maxHeight: _maxHeight),
            width: _w,
            height: _h,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_r),
              gradient: LinearGradient(
                begin: Alignment(-1, -1),
                end: Alignment(-1, -0.9),
                colors: [Colors.black12, Colors.transparent],
              ),
            ),
          ),  //  Top Shadow
          Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: _maxWidth, minHeight: 25.0, maxHeight: _maxHeight),
            width: _w,
            height: _h,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_r),
              gradient: LinearGradient(
                begin: Alignment(1, 1),
                end: Alignment(1, 0.98),
                colors: [Colors.black38, Colors.transparent],
              ),
            ),
          ),  //  Bottom Shadow
          Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: _maxWidth, minHeight: 25.0, maxHeight: _maxHeight),
            width: _w,
            height: _h,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_r),
              gradient: LinearGradient(
                begin: Alignment(1, 1),
                end: Alignment(0.85, 1),
                colors: [Colors.black12, Colors.transparent],
              ),
            ),
          ),  //  Right Shadow
          Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: _maxWidth, minHeight: 25.0, maxHeight: _maxHeight),
            width: _w,
            height: _h,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_r),
              gradient: LinearGradient(
                begin: Alignment(-1, -1),
                end: Alignment(-0.85, -1),
                colors: [Colors.black12, Colors.transparent],
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: _t,
            ),
          ),  //  Left Shadow
        ],
      ),
    );
  }

}


