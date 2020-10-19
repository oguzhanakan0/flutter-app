import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/exam_lobby_page.dart';

class ExamHoldTimer extends StatefulWidget {
  final TextStyle textStyle;
  final int duration;
  ExamHoldTimer(this.duration, [this.textStyle = o.TextStyles.optikBody1Bold]);
  
  @override
  _ExamHoldTimerState createState() => _ExamHoldTimerState();
}

class _ExamHoldTimerState extends State<ExamHoldTimer> with TickerProviderStateMixin, WidgetsBindingObserver {
  bool isLive;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    isLive = true;
    pushNextPage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        print('[hold page] isLive is false now');
        if(mounted){
          setState(() {
            isLive = false;
          });
        }
        break;
      case AppLifecycleState.resumed:
        print('[hold page] isLive is true now');
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

  Future pushNextPage() async {
    print(widget.duration);
    await new Future.delayed(Duration(seconds: widget.duration), () {
      if(mounted&&isLive){
      OptikExamInherited args = ModalRoute.of(context).settings.arguments;
      if(args.questionNumber >= args.exam.nQuestions){
      Navigator.pushReplacementNamed(
        context,
        '/exam_review_page',
        arguments: ModalRoute.of(context).settings.arguments
        );
      } else{
      Navigator.pushReplacementNamed(
        context,
        '/exam_question_page',
        arguments: ModalRoute.of(context).settings.arguments);
      }
    }});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}