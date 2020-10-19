import 'package:flutter/material.dart';

class ColorChanger extends StatefulWidget {
  final Text text;
  final Color color1;
  final Color color2;
  final double radius;
  final double margin;
  ColorChanger({this.text,this.color1,this.color2,this.radius=0,this.margin=0});

  @override
    _ColorChangerState createState() => _ColorChangerState();
}

class _ColorChangerState extends State<ColorChanger>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 499));
    _colorTween = ColorTween(begin: widget.color1, end: widget.color2)
        .animate(_animationController);
    changeColors();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future changeColors() async {
    while (true) {
      await new Future.delayed(const Duration(milliseconds: 500), () {
        if(mounted){
          if (_animationController.status == AnimationStatus.completed) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Container(
        margin: EdgeInsets.all(widget.margin),
        child: Center(child:widget.text),
        height: 60.0,
        decoration: BoxDecoration(
          color:_colorTween.value,
          borderRadius: BorderRadius.all(Radius.circular(widget.radius))),
      ),
    );
  }
}