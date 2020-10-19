import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/exam_lobby_page.dart';
import 'package:Optik/services/post_functions.dart';

class ExamQuestionTimer extends StatefulWidget {
  final TextStyle textStyle;
  final int qDuration;
  final OptikExamInherited args;
  ExamQuestionTimer(Key key, this.qDuration, this.args, [this.textStyle = o.TextStyles.optikBody1Bold]):super(key: key);
  
  @override
  _ExamQuestionTimerState createState() => _ExamQuestionTimerState();
}

class _ExamQuestionTimerState extends State<ExamQuestionTimer> with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController animationController;
  bool isLive;

  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    String _minute = duration.inMinutes % 60 < 10 ? '0'+(duration.inMinutes % 60).toString() : (duration.inMinutes % 60).toString();
    String _second = duration.inSeconds % 60 < 10 ? '0'+(duration.inSeconds % 60).toString() : (duration.inSeconds % 60).toString();
    return _minute+':'+_second;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    isLive = true;
    animationController = AnimationController(vsync: this, duration: Duration(seconds: widget.qDuration));
    animationController.reverse(from: animationController.value == 0.0
      ? 1.0
      : animationController.value);
    pushExam();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        print('isLive is false now');
        if(mounted){
          setState(() {
            isLive = false;
          });
        }
        break;
      case AppLifecycleState.resumed:
        print('isLive is true now');
        if(mounted){
          setState(() {
            isLive = true;
          });
        }
        break;
      case AppLifecycleState.inactive:
        print('inactive state');
        break;
      case AppLifecycleState.detached:
        print('detached state');
        break;
    }
  }

  Future pushExam() async {
    await new Future.delayed(Duration(seconds: widget.qDuration), () {
      if(mounted&&isLive){
        print('exam question timer thing');
        sendAnswer(
          userID:widget.args.user.id, 
          answer:widget.args.qList[widget.args.questionNumber].userChoice, 
          questionID:widget.args.qList[widget.args.questionNumber].questionID,
          examID: widget.args.exam.examID);
        Navigator.pushReplacementNamed(
          context,
          '/exam_hold_page',
          arguments: widget.args
          );
        }
      }
    );
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
        child:Stack(
          key: widget.key,
          alignment: AlignmentDirectional.center,
          children: [
            AnimatedBuilder(
              animation: animationController,
              builder: (_, Widget child) {
                return Text(
                  timerString,
                  style: widget.textStyle,
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