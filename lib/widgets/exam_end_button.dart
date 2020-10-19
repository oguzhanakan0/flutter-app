import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;

class ExamEndButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String header;
  final Color color;
  const ExamEndButton({
    this.onPressed, 
    this.title = 'Testi Bitir',
    this.header = 'Bütün cevaplarımı kontrol ettim.',
    this.color = o.Colors.optikBlue
  }
  );

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      minWidth: double.infinity,
      elevation: 0.0,
      padding: EdgeInsets.symmetric(vertical: 12.0),
      onPressed: onPressed,
      child:Column(
        children:[
          Text(header,
            style: o.TextStyles.optikBody1.copyWith(color: o.Colors.optikWhite)),
          Text(title,
            style: o.TextStyles.optikBoldTitle.copyWith(color: o.Colors.optikWhite))
        ])
      );
  }
}