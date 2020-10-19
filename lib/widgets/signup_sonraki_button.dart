import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;

class SignupSonrakiButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  final Color color;
  const SignupSonrakiButton({
    this.onPressed, 
    this.title = 'Sonraki',
    this.color = o.Colors.optikBlue
  }
  );

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      minWidth: double.infinity,
      elevation: 0.0,
      padding: EdgeInsets.symmetric(vertical: 24.0),
      onPressed: onPressed,
      child:Text(title,
        style: o.TextStyles.optikBoldTitle.copyWith(color: o.Colors.optikWhite))
      );
  }
}