import 'package:Optik/models/theme.dart' as o;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'animated_text_widget.dart';

class Loading extends StatelessWidget{
  const Loading({this.negative = false,this.transparent=false, this.size=50.0, this.opacity=0, this.warningText});
  final bool negative;
  final bool transparent;
  final String warningText;
  final double opacity;
  final double size;
  @override
  Widget build(BuildContext context) {
    Color c1 = o.Colors.optikBlue;
    Color c2 = o.Colors.optikWhite;
    return Container(
      color: (transparent&&negative)?c2.withOpacity(opacity):
        (transparent&&!negative)?c1.withOpacity(opacity):
          (!transparent&&negative)?c2:c1,
      child: warningText==null?Center(
        child:
          SpinKitCircle(
          color: negative?c1:c2,
          size: size,
        )):Scaffold(
          backgroundColor: o.Colors.optikBlue,
          body:Center(child:
            AnimatedTextWidget(text: warningText))
        ),      
    );
  }

}