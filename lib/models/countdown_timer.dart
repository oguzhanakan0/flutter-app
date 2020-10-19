import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:Optik/collections/globals.dart';
import 'package:Optik/models/theme.dart' as o;

class CountdownTimer extends StatefulWidget {
  final double width;
  final double height;
  final TextStyle textStyle;
  final DateTime examDate;
  final DateTime referenceDate;
  CountdownTimer({
    this.width, 
    this.height,
    this.examDate,
    this.referenceDate,
    this.textStyle = o.TextStyles.optikWhiteTitle});
  
  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> with WidgetsBindingObserver, TickerProviderStateMixin {
  AnimationController animationController;
  bool pushed = false;

  String get timerString {
    Duration duration = animationController.duration * animationController.value;
    String _days   = duration.inDays.toString();
    String _hour   = duration.inHours   % 24 < 10 ? '0'+(duration.inHours % 24).toString() : (duration.inHours % 24).toString();
    String _minute = duration.inMinutes % 60 < 10 ? '0'+(duration.inMinutes % 60).toString() : (duration.inMinutes % 60).toString();
    String _second = duration.inSeconds % 60 < 10 ? '0'+(duration.inSeconds % 60).toString() : (duration.inSeconds % 60).toString();
    return _days!='0'?_days+' gün\n'+_hour+':'+_minute+':'+_second:
      _hour+':'+_minute+':'+_second;
  }

  @override
  void initState() {
    super.initState();
    print('countdown timer init state ran');
    animationController = AnimationController(vsync: this, duration: Duration(seconds:  widget.examDate.difference(widget.referenceDate).inSeconds));
    animationController.value = widget.examDate.difference(DateTime.now().add(Duration(milliseconds: timeOffset))).inSeconds / widget.examDate.difference(widget.referenceDate).inSeconds;
    animationController.reverse(from: animationController.value == 0.0 ? 1.0: animationController.value);
    print("animationController.value set to: "+ animationController.value.toString());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        print('[countdown timer] paused');
        print("[pause] animationController.value: "+ animationController.value.toString());
        break;
      case AppLifecycleState.resumed:
        print('[countdown timer] live');
        if(mounted){
          setState(() {
            animationController.value = widget.examDate.difference(DateTime.now().add(Duration(milliseconds: timeOffset))).inSeconds / widget.examDate.difference(widget.referenceDate).inSeconds;
            animationController.reverse(from: animationController.value == 0.0 ? 1.0: animationController.value);
          });
        }
        print("[resume] animationController.value: "+ animationController.value.toString());
        break;
      default: break;
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[Container(
        height: widget.height + 32.0,
        width: widget.width +32.0,
        child:Stack(
          key: widget.key,
          alignment: AlignmentDirectional.center,
          children: [AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget child) {
                  return CustomPaint(
                    painter: TimerPainter(
                      size1: Size(widget.width,widget.height),
                      animation: animationController,
                      backgroundColor: o.Colors.optikGray,
                      color: o.Colors.optikWhite),
                  );
                },
              ),
            AnimatedBuilder(
              animation: animationController,
              builder: (_, Widget child) {
                return Text(
                  timerString,
                  style: widget.textStyle,
                  textAlign: TextAlign.center
                );
              }
            ),
          ],
        ),
      ),
      ]
    );
  }
}

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;
  @required
  final Size size1;

  TimerPainter({this.size1, this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(0,0), size1.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset(-1*size1.width/2,-1*size1.width/2) & size1, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
