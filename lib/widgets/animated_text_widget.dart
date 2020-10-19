import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;

class AnimatedTextWidget extends StatefulWidget {
  final String text;
  AnimatedTextWidget({this.text});

  @override
    _AnimatedTextWidgetState createState() => _AnimatedTextWidgetState();
}

class _AnimatedTextWidgetState extends State<AnimatedTextWidget>  {
  double opacity = 1.0;
  bool stop;

  @override
  void initState() {
    super.initState();
    stop = false;
    animate();
  }

  @override
  void dispose(){
    super.dispose();
    stop = true;
  }

  void animate() async{
    Future.delayed(Duration(milliseconds: opacity == 0 ? 500:1250), () {
      if(mounted || !stop){
        setState(() {
          opacity = opacity == 0.0 ? 1.0 : 0.0;
        });
        animate();
      }
    });
  }


  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      child: Text(widget.text,style:o.TextStyles.optikWhiteTitle, textAlign: TextAlign.center,),
      opacity: opacity,
      curve: Curves.elasticInOut,
    );
  }
}