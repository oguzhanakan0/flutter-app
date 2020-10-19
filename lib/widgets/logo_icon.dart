import 'package:flutter/cupertino.dart';

class OptikIcon extends StatelessWidget {
  final String type;
  final double width;
  OptikIcon({
    this.type = 'optikexam',
    this.width
  });

  @override
  Widget build(BuildContext context) {
    var imageUrl;
    type == 'optikexam' ? 
      imageUrl = 'assets/images/logo_icon.png':
      imageUrl = 'assets/images/denemesorulari_icon.png';
    return Container(
      alignment: Alignment.center,
      height: width, 
      width: width,
      child:Image(image: AssetImage(imageUrl))
    );
  }
  
}