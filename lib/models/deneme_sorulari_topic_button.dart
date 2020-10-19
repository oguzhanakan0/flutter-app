import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;

class TopicButton extends StatelessWidget {
  TopicButton({Key key, this.text, this.color, this.width, this.onPressed}) : super(key: key);
  final String text;
  final Color color;
  final double width;
  final Function onPressed;
  @override

  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width*3/4,
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child:RaisedButton(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: AutoSizeText(text,
          style: o.TextStyles.optikBoldTitle.copyWith(color: o.Colors.optikWhite),
          minFontSize: 6,
          textAlign: TextAlign.center,
          maxLines: 2,),
        onPressed: onPressed,
      )
    );
  }
}