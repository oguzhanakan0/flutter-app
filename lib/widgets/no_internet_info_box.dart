import 'package:Optik/models/theme.dart' as o;
import 'package:flutter/material.dart';
import 'animated_container.dart';

class NoInternetInfoBox extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ColorChanger(
        text: Text(
          'İnternet bağlantısı bulunamadı.\nCevaplarınız kaydedilmeyebilir!',
          style: o.TextStyles.optikBody1BoldWhite,
          textAlign: TextAlign.center,),
        color1: o.Colors.optikHistogram1,
        color2: o.Colors.optikHistogram3,
        radius: 16.0,
        /* margin: 16.0, */
    );
  }
}