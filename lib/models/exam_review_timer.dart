import 'package:Optik/collections/globals.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/exam_lobby_page.dart';
import 'package:Optik/services/post_functions.dart';
import 'package:overlay_support/overlay_support.dart';

class ExamReviewTimer extends StatefulWidget {
  final TextStyle textStyle;
  final int duration;
  final OptikExamInherited args;
  ExamReviewTimer(Key key, this.duration, this.args, [this.textStyle = o.TextStyles.optikBoldTitle]):super(key: key);
  
  @override
  _ExamReviewTimerState createState() => _ExamReviewTimerState();
}

class _ExamReviewTimerState extends State<ExamReviewTimer> with TickerProviderStateMixin {
  AnimationController animationController;
  bool pushed = false;

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
    animationController = AnimationController(vsync: this, duration: Duration(seconds: widget.duration));
    animationController.reverse(from: animationController.value == 0.0
      ? 1.0
      : animationController.value);
    pushExam();
  }

  Future pushExam() async {
    await new Future.delayed(Duration(seconds: widget.duration), () async {
      if(mounted){
        bool res = await sendAnswersInBatch(userID: widget.args.user.id,qList: widget.args.qList.values.toList(),examID: widget.args.exam.examID);
        print('answers sent in batch?:');
        print(res);
        if(mounted&&ON_EXAM){
          ON_EXAM = false;
          if(!res){showSimpleNotification(Text('İnternet bağlantından dolayı cevaplar yüklenemedi. Gözden geçirme sayfasına kadar verdiğin cevaplar geçerli olacak.'));}
          if(mounted){
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/exam_before_results_page',
              ModalRoute.withName('/home'),
              arguments: widget.args
              );
          }
        }
      }
    }
    );
  }


  @override
  void dispose() {
    animationController.dispose();
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