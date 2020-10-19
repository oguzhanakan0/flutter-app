import 'dart:collection';

import 'package:Optik/collections/globals.dart';
import 'package:Optik/widgets/loading.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Optik/collections/exam.dart';
import 'package:Optik/collections/parentExam.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/models/exam_review_timer.dart';
import 'package:Optik/models/review_widget.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/exam_lobby_page.dart';
import 'package:Optik/services/post_functions.dart';
import 'package:Optik/widgets/exam_end_button.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:Optik/collections/topic_map.dart' as map;

class ReviewPageInherited extends InheritedWidget {
  final _OptikExamReviewPageState args;

  ReviewPageInherited({
    Key key,
    @required this.args,
    @required Widget child
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ReviewPageInherited old) => true;
}

class OptikExamReviewPage extends StatefulWidget {
  final Widget child;
  const OptikExamReviewPage({this.child});
  @override
  _OptikExamReviewPageState createState() => _OptikExamReviewPageState();

  static _OptikExamReviewPageState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ReviewPageInherited)
            as ReviewPageInherited)
            .args
        ;
  }
}

class _OptikExamReviewPageState extends State<OptikExamReviewPage> with SingleTickerProviderStateMixin,WidgetsBindingObserver {

  ParentExam parentExam;
  Exam exam;
  User user;
  SplayTreeMap<int,dynamic> qList;
  int reviewDuration;
  OptikExamInherited args;
  bool loading;

  @override
  void initState() {
    super.initState();
    ON_REVIEW = true;
    loading = false;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    user = args.user;
    qList = args.qList;
    parentExam = args.parentExam;
    exam = args.exam;
    reviewDuration = args.exam.reviewDuration;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print('review page disposed');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        print('paused state');
        sendAnswersInBatch(userID: args.user.id,qList: args.qList.values.toList(),examID: args.exam.id);
        break;
      case AppLifecycleState.resumed:
        print('resumed state');
        DateTime returnTime = DateTime.now().add(Duration(milliseconds: timeOffset));
        List<int> searchList = args.examSchedule.keys.toList();
        searchList.remove(0);
        searchList.remove(searchList.reduce(max));
        if(returnTime.isAfter(args.examSchedule[searchList.reduce(max)+1]['eventEndTime'])){
          showSimpleNotification(
            Text("Sen gittiğinde sınav sona erdi.",style: o.TextStyles.optikBody1White),
            background: map.colorMap[args.exam.topic],
            autoDismiss: true);
          print('Pushing to results page');
          ON_EXAM = false;
          Navigator.pushReplacementNamed(
            context,
            '/exam_before_results_page',
            arguments: args
          );
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
	Widget build(context) {
    final nav = Navigator.of(context);
    final OptikExamInherited args = ModalRoute.of(context).settings.arguments;
    return WillPopScope(
      onWillPop: (){
        showSimpleNotification(
          Text("Testten şu an çıkış yapamazsınız."),
          background: map.colorMap[args.exam.topic],
          autoDismiss: true,
          trailing: Builder(builder: (context) {
            return FlatButton(
                textColor: Colors.yellow,
                onPressed: () {
                  OverlaySupportEntry.of(context).dismiss();
                },
                child: Text('Tamam'));
          }));
          return null;
      },
      child:Stack(children:[Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: o.Colors.optikWhite,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text('Gözden Geçir',
                style:o.TextStyles.optikBoldTitle),
              Container(
              width: 90.0,
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: o.Colors.optikBlack,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child:Center(child:Text(parentExam.parentExamName,style: o.TextStyles.optikBody2White))
            )
            ]
          ),
        ),
      body:Column(
        children:[
          SizedBox(height: 8.0,),
          Text('Kalan Süre',
            style: o.TextStyles.optikBody1Bold),
          ExamReviewTimer(PageStorageKey('reviewTimer'),reviewDuration,ModalRoute.of(context).settings.arguments),
          Expanded(child:ReviewPageInherited(
            args: this,
            child:ReviewWidget())),
          ExamEndButton(
            onPressed: (){

              showDialog (
              context: context,
              builder: (BuildContext context) {
                return AlertDialog (
                  title: Text("Uyarı",style: o.TextStyles.optikBody1Bold,),
                  content: Wrap(children:[
                    Text("Testi bitirmek istiyor musunuz?",style: o.TextStyles.optikTitle),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:[
                        GestureDetector(
                          onTap: DateTime.now().add(Duration(milliseconds: timeOffset)).isAfter(args.examSchedule[qList.keys.reduce(max)+1]['eventEndTime'])?(){
                            setState(() {
                              loading = false;
                            });
                          }:
                          () async {
                            setState(() {
                              loading = true;
                            });
                            Navigator.pop(context);
                            bool res = await sendAnswersInBatch(userID: args.user.id,qList: args.qList.values, examID: args.exam.examID);
                            print('answers sent in batch?:');
                            print(res);
                            if(!res){showSimpleNotification(Text('İnternet bağlantından dolayı cevaplar yüklenemedi. Gözden geçirme sayfasına kadar verdiğin cevaplar geçerli olacak.'));}
                            ON_EXAM = false;
                            if(mounted){
                              nav.pushReplacementNamed(
                                '/exam_before_results_page',
                                arguments: args
                              );
                            }
                          },
                          child: Text('Testi Bitir',style: o.TextStyles.optikBody1Bold)
                        ),
                        GestureDetector(
                        onTap: (){Navigator.pop(context);},
                        child: Container(
                          decoration: BoxDecoration(
                            color: o.Colors.optikBlue,
                            borderRadius: BorderRadius.circular(4.0)),
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.only(left:8.0),
                          child:Text('Devam Et',
                          style: o.TextStyles.optikBody1BoldWhite,))
                      )
                    ])
                  ])
                );
              }
            );

            }
          ),
        ]
      ),
    ),
    loading?Loading(negative: true,transparent: true,opacity: 0.5,):SizedBox()
    ])
    );
  }
}