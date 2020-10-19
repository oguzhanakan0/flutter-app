import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;

class ParentExamNameContainer extends StatelessWidget{
  final String parentExamName;
  const ParentExamNameContainer(this.parentExamName);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 90.0),
      padding: EdgeInsets.all(4.0),
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: o.Colors.optikBlack,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child:Center(child:AutoSizeText(parentExamName,style: o.TextStyles.optikBody2White)));
  }

}