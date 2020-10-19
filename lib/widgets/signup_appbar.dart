import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;

class SignupAppBar extends AppBar{
  final bool centerTitle = true;
  bool automaticallyImplyLeading;
  final Color backgroundColor = o.Colors.optikWhite;
  final double elevation = 1.0;
  Text title;
  SignupAppBar({this.automaticallyImplyLeading=true, this.title =const  Text("Kaydol", style:o.TextStyles.optikTitle)});
}