import 'package:Optik/collections/globals.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/question.dart';
import 'package:Optik/models/exam_question_timer.dart';
import 'package:Optik/models/question_widget.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/exam_lobby_page.dart';
import 'package:Optik/collections/topic_map.dart' as map;
import 'package:Optik/services/post_functions.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:math';


class OptikExamQuestionPage extends StatefulWidget {
  @override
  _OptikExamQuestionPageState createState() => _OptikExamQuestionPageState();
}

class _OptikExamQuestionPageState extends State<OptikExamQuestionPage> with WidgetsBindingObserver {
  OptikExamInherited args;
  Question thisQuestion;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print('question page disposed');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state) {
      case AppLifecycleState.paused:
        sendAnswer(
          userID:args.user.id, 
          answer:thisQuestion.userChoice, 
          questionID:thisQuestion.questionID,
          examID: args.exam.examID);
        print('paused state at:'+DateTime.now().add(Duration(milliseconds: timeOffset)).toIso8601String());
        break;
      case AppLifecycleState.resumed:
        print('resumed state at:'+DateTime.now().add(Duration(milliseconds: timeOffset)).toIso8601String());
        DateTime returnTime = DateTime.now().add(Duration(milliseconds: timeOffset));
        /* args.examSchedule[-999] = returnTime; */
        /* bool onQuestion;
        bool onHold;
        bool onReview;
        bool onFinish; */
        List<int> searchList = args.examSchedule.keys.toList();
        searchList.remove(0);
        searchList.remove(searchList.reduce(max));
        /* searchList.remove(-999); */ 
        int shouldJumpTo;
        // 1. IS EXAM FINISHED?
        if(returnTime.isAfter(args.examSchedule[searchList.reduce(max)+1]['eventEndTime'])){
          /* onFinish = true; */
          showSimpleNotification(
            Text("Sen gittiğinde sınav sona erdi.",style: o.TextStyles.optikBody1White),
            background: map.colorMap[args.exam.topic],
            autoDismiss: true);
          print('Pushing to results page');
          Navigator.pushReplacementNamed(
            context,
            '/exam_before_results_page',
            arguments: args
          );
        }
        // 2. IS EXAM ON REVIEW?
        else if(returnTime.isAfter(args.examSchedule[searchList.reduce(max)+1]['eventStartTime'])&&
            returnTime.isBefore(args.examSchedule[searchList.reduce(max)+1]['eventEndTime'])){
          /* onReview = true; */
          showSimpleNotification(
            Text("Sınav sona erdi. Şimdi cevapları kontrol etme zamanı!",style: o.TextStyles.optikBody1White),
            background: map.colorMap[args.exam.topic],
            autoDismiss: true);
          print('Pushing to review page');
          args.exam.reviewDuration += args.examSchedule[args.exam.nQuestions+1]['eventStartTime'].difference(returnTime).inSeconds;
          Navigator.pushReplacementNamed(
              context,
              '/exam_review_page',
              arguments: args
          );
        } 
        // 3. IS EXAM ON A QUESTION OR ON A HOLD?
        else {
          print(searchList);
          for(int i in searchList){
            if(returnTime.isAfter(args.examSchedule[i]['eventStartTime'])&&
                returnTime.isBefore(args.examSchedule[i]['holdStartTime'])){
                  if(i==args.questionNumber){
                    print('Question has not changed. Breaking.');
                    /* args.examSchedule[-999]=null; */
                    break;
                  } else {
                    shouldJumpTo = i;
                    /* onQuestion = true; */
                    showSimpleNotification(
                      Text("Sen "+args.questionNumber.toString()+". soruda gittin. Şimdi "+(shouldJumpTo).toString()+". sorudayız.",style: o.TextStyles.optikBody1White),
                      background: map.colorMap[args.exam.topic],
                      autoDismiss: true);
                    args.questionNumber = shouldJumpTo-1;
                    args.qList[shouldJumpTo].duration = args.examSchedule[shouldJumpTo]['holdStartTime'].difference(returnTime).inSeconds;
                    print('Pushing to question page: Question '+(1+args.questionNumber).toString());
                    print('Duration of question page is set to:'+args.qList[shouldJumpTo].duration.toString());
                    Navigator.pushReplacementNamed(
                    context,
                    '/exam_question_page',
                    arguments: args);
                    break;
                  }
            } else if(
              returnTime.isAfter(args.examSchedule[i]['holdStartTime'])&&
                returnTime.isBefore(args.examSchedule[i]['eventEndTime'])){
                  shouldJumpTo = i;
                  /* onHold = true; */
                  /* if(shouldJumpTo!=args.questionNumber){ */
                    showSimpleNotification(
                      Text("Sen "+args.questionNumber.toString()+". soruda gittin. Şimdi "+shouldJumpTo.toString()+". soru arasındayız.",style: o.TextStyles.optikBody1White),
                      background: map.colorMap[args.exam.topic],
                      autoDismiss: true);
                    args.questionNumber = shouldJumpTo;
                    args.qList[shouldJumpTo].holdDuration = args.examSchedule[shouldJumpTo]['eventEndTime'].difference(returnTime).inSeconds;
                    print('Pushing to hold page of: Question '+(args.questionNumber).toString());
                    print('Duration of hold page is set to:'+args.qList[shouldJumpTo].holdDuration.toString());
                    
                    Navigator.pushReplacementNamed(
                    context,
                    '/exam_hold_page',
                    arguments: args
                    );
                    break;
            }
          }
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

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    args.questionNumber++;
    thisQuestion = args.qList[args.questionNumber];
    print('QUESTION PAGE BUILD RAN WITH QUESTION NUMBER: '+args.questionNumber.toString());
    return WillPopScope(
      onWillPop: (){
        showSimpleNotification(
          Text("Testten şu an çıkış yapamazsınız.",style: o.TextStyles.optikBody1White),
          background: map.colorMap[args.exam.topic],
          autoDismiss: true,
          trailing: Builder(builder: (context) {
            return FlatButton(
                textColor: Colors.yellow,
                onPressed: () {
                  OverlaySupportEntry.of(context).dismiss();
                },
                child: Text('Tamam',style: o.TextStyles.optikBody1White));
          }));
          return null;
      },child: Scaffold(
      appBar: AppBar(
        backgroundColor: map.colorMap[args.exam.topic],
        automaticallyImplyLeading: false,
        title:Container(width:MediaQuery.of(context).size.width/2,
          child:AutoSizeText(
            args.exam.parentTopic+' '+map.topicMap[args.exam.parentTopic][args.exam.topic],
            style: o.TextStyles.optikBody1BoldWhite,
            minFontSize:9,
            maxLines: 2)
        ),
        actions: <Widget>[
          Center(child:Text(args.parentExam.parentExamName,style: o.TextStyles.optikBody2White)),
          Padding(padding:EdgeInsets.only(right: 16.0), child:Icon(Icons.event)),
        ],
      ),
      body: Column(children:[
        /* NO_INTERNET ? NoInternetInfoBox():SizedBox(), */
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0,color: o.Colors.optikGray),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          margin: EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
          padding: EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children:[Text('Soru: ',style: o.TextStyles.optikBody2),
                          Text(args.questionNumber.toString()+'/'+args.exam.nQuestions.toString(),style: o.TextStyles.optikBody1Bold)]),
              Row(children:[Text('Süre: ',style: o.TextStyles.optikBody2),
                            ExamQuestionTimer(PageStorageKey('q'+args.questionNumber.toString()),thisQuestion.duration,args),
              ]),
              Row(children:[Text('Katılan: ',style: o.TextStyles.optikBody2),
                          Text(args.cache['attendeeCount'],style: o.TextStyles.optikBody1Bold)]),
          ]),
        ),
        Expanded(child:
          ListView(children:[
            QuestionWidget(
              q: thisQuestion,
              active: true),
            ]
          )
        )
        ],
      ),
    ));
  }
}