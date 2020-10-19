import 'dart:async';
import 'dart:collection';

import 'package:Optik/enums/view_state.dart';
import 'package:Optik/scoped_models/home_view_model.dart';
import 'package:Optik/services/convert_functions.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:Optik/widgets/animated_text_widget.dart';
import 'package:Optik/widgets/particle_background.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/exam.dart';
import 'package:Optik/collections/parentExam.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/collections/topic_map.dart' as map;
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/widgets/loading.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:Optik/collections/globals.dart';
import 'dart:math';
import 'package:flutter_advanced_networkimage/transition.dart';

class OptikExamInherited extends InheritedWidget {
  final User user;
  final ParentExam parentExam;
  final Exam exam;
  final Map<dynamic,dynamic> cache;
  SplayTreeMap<int,dynamic> qList;
  Map<int,dynamic> examSchedule;
  int questionNumber;

  OptikExamInherited({
    Key key,
    @required this.user,
    @required this.parentExam,
    @required this.exam,
    @required Widget child,
    this.cache,
    this.qList,
    this.examSchedule,
    this.questionNumber = 0
  }) : super(key: key, child: child);

  static OptikExamInherited of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(OptikExamInherited) as OptikExamInherited);
  }

  @override
  bool updateShouldNotify(OptikExamInherited old) => true;
}

class ExamLobby extends StatefulWidget {
  final HomeViewModel model;
  ExamLobby(this.model);
  @override
  _ExamLobbyState createState() => _ExamLobbyState();
}

class _ExamLobbyState extends State<ExamLobby> {
  bool loading;
  SplayTreeMap<int,dynamic> qList;
  User user;
  Map<dynamic,dynamic> args;
  ParentExam parentExam;
  Exam exam;
  Map<int,dynamic> examSchedule;
  bool reloadState;
  bool isTappable;

  @override
  void initState() {
    super.initState();
    loading = true;
    ON_EXAM =true;
    reloadState = false;
    isTappable = true;
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
  }

  Map<int,dynamic> getExamSchedule(SplayTreeMap<int,dynamic> qList, int reviewDuration, DateTime exactStartTime) {
    Map<int,dynamic> schedule = {
      0:{'eventEndTime':exactStartTime}
    };
    for (int i in qList.keys) {
      schedule[i]={
        'eventStartTime':schedule[i-1]['eventEndTime'],
        'holdStartTime':schedule[i-1]['eventEndTime'].add(Duration(seconds:qList[i].duration)),
        'eventEndTime':schedule[i-1]['eventEndTime'].add(Duration(seconds:qList[i].duration+HOLD_DURATION))
      };
    }
    schedule[qList.keys.reduce(max)+1]={
      'eventStartTime':schedule[qList.keys.reduce(max)]['eventEndTime'],
      'eventEndTime':schedule[qList.keys.reduce(max)]['eventEndTime'].add(Duration(seconds: reviewDuration))
    };
    return schedule;
  }

  Future<void> cacheImages(dynamic qList, dynamic exam) async {
    for (int i in qList.keys){
      try{
        await precacheImage(AdvancedNetworkImage(
          qList[i].imageUrl,
          retryLimit: 10,
          retryDurationFactor: 1,
          useDiskCache: true,
          cacheRule: CacheRule(maxAge: const Duration(days: 7)),
        ),context);
        print('CACHED: '+qList[i].imageUrl);
      } catch(e){
        // nothing to do here.
      }
      for(var j in qList[i].choices.keys){
        if(qList[i].choices[j].indexOf('http')!=-1){
          try{
            await precacheImage(AdvancedNetworkImage(
              qList[i].choices[j],
              retryLimit: 10,
              retryDurationFactor: 1,
              useDiskCache: true,
              cacheRule: CacheRule(maxAge: const Duration(days: 7)),
            ),context);
            print('CACHED: '+qList[i].choices[j]);
          } catch(e){
            // nothing to do here.
          }
        }
      }
    }
    if(exam.lobbyAd!=null){
      try{
        await precacheImage(AdvancedNetworkImage(
              exam.lobbyAd,
              retryLimit: 10,
              retryDurationFactor: 1,
              useDiskCache: true,
              cacheRule: CacheRule(maxAge: const Duration(days: 7)),
            ),context);
            print('CACHED: '+exam.lobbyAd);
      } catch(e){
        // nothing to do here.
      }
    }
    if(exam.persistentAd!=null){
      try{
        await precacheImage(AdvancedNetworkImage(
              exam.persistentAd,
              retryLimit: 10,
              retryDurationFactor: 1,
              useDiskCache: true,
              cacheRule: CacheRule(maxAge: const Duration(days: 7)),
            ),context);
            print('CACHED: '+exam.persistentAd);
      } catch(e){
        // nothing to do here.
      }
    }
  }

  onAfterBuild(BuildContext context) async {
    if(loading&&mounted){
      /* try{ */
        user = args['user'];
        exam = args['cache']['todaysExam'];
        parentExam = ParentExam(parentExamName: exam.parentExamName);
        print('fetching QList...');
        qList = await fetchQList(forExamLobby: true);
        print('qList fetched:\n-----------------------');
        await cacheImages(qList,exam);
        examSchedule = getExamSchedule(qList, exam.reviewDuration,exam.examDate.add(Duration(seconds: LOBBY_DURATION)));
        for (int i in examSchedule.keys){
          print('Event '+i.toString()+':');
          print(examSchedule[i]);
          print('------');
        }
        showSimpleNotification(
          Text("Tüm sorular yüklendi! Sınav az sonra başlayacak. Tüm katılımcılara başarılar dileriz.",),
          background: map.colorMap[exam.topic]
        );
        if(mounted){
            setState(() {
            loading = false;
            reloadState = false;
          });
        }
      } /* catch(e){
        print(e);
        if(mounted){
          setState(() {
            reloadState = true;
            isTappable = true;
          });
        }
      }
    } */
  }

  @override
  Widget build(BuildContext context) {
  return reloadState?Scaffold(body:Center(child:RaisedButton(
      color: o.Colors.optikBlue,
      child: Text('İnternet bağlantısı bulunamadı. Tekrar dene.',style: o.TextStyles.optikBody1White,),
      onPressed: !isTappable?(){}:() async {
        if(mounted){
          setState(() {
            isTappable = false;
          });
        }
        await onAfterBuild(context);
      },
      ))):loading?Loading(negative: true):OptikExamInherited(
      qList: qList,
      user: user,
      parentExam: parentExam,
      exam: exam,
      examSchedule: examSchedule,
      child: ExamLobbyPage(loading:loading,model:widget.model),
      cache: loading?null:args['cache']
    );
  }
}

class ExamLobbyPage extends StatefulWidget {
  final bool loading;
  final HomeViewModel model;
  const ExamLobbyPage({this.loading,this.model});
  @override
  _ExamLobbyPageState createState() => _ExamLobbyPageState();
}

class _ExamLobbyPageState extends State<ExamLobbyPage> with WidgetsBindingObserver{
  OptikExamInherited args;
  String _text;
  int count;
  bool isLive;
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    isLive = true;
    count=0;
    _text = LOBBY_INFO_TEXT[1];
    count++;
    Timer.periodic(Duration(seconds: 3), (timer) {
        if(mounted){
          setState(() {
            _text = LOBBY_INFO_TEXT[count%LOBBY_INFO_TEXT.length];
            count++;
          });
        }
      }
    );
  }


  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    args = OptikExamInherited.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
    /* if(widget.loading){
      print('and now here');
      pushExam();
    }   */
  }

  onAfterBuild(BuildContext context) async {
    if(widget.loading==false){
      pushExam();
    }
  }

  Future pushExam() async {
    int timeLeft = args.examSchedule[0]['eventEndTime'].difference(DateTime.now().add(Duration(milliseconds: timeOffset))).inSeconds;
    await new Future.delayed(Duration(seconds: timeLeft<0?0:timeLeft), () async {
      if(mounted&&isLive) {
        print('exam starter timer thing');
        try{
          args.cache['attendeeCount'] = await fetchAttendeeCount();
        } catch(e) {
          args.cache['attendeeCount'] = '~~';
        }
        Navigator.pushReplacementNamed(
          context,
          '/exam_question_page',
          arguments: args
          );
        }
      }
    );
  }


  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch(state) {
      case AppLifecycleState.paused:
        if(mounted){
          setState(() {
            print('isLive is false now');
            isLive = false;
          });
        }
        print('paused state at:'+DateTime.now().add(Duration(milliseconds: timeOffset)).toIso8601String());
        break;
      case AppLifecycleState.resumed:
        print('resumed state at:'+DateTime.now().add(Duration(milliseconds: timeOffset)).toIso8601String());
        DateTime returnTime = DateTime.now().add(Duration(milliseconds: timeOffset));
        List<int> searchList = args.examSchedule.keys.toList();
        searchList.remove(0);
        searchList.remove(searchList.reduce(max));
        int shouldJumpTo;
        // 1. IS EXAM FINISHED?
        if(returnTime.isAfter(args.examSchedule[searchList.reduce(max)+1]['eventEndTime'])){
          showSimpleNotification(
            Text("Sen gittiğinde sınav sona erdi.",style: o.TextStyles.optikBody1White),
            background: map.colorMap[args.exam.topic],
            autoDismiss: true);
          print('Pushing to results page');
          if(mounted){
            Navigator.pushReplacementNamed(
              context,
              '/exam_before_results_page',
              arguments: args
            );
          }
        }
        // 2. IS EXAM ON REVIEW?
        else if(returnTime.isAfter(args.examSchedule[searchList.reduce(max)+1]['eventStartTime'])&&
            returnTime.isBefore(args.examSchedule[searchList.reduce(max)+1]['eventEndTime'])){
          showSimpleNotification(
            Text("Sınav sona erdi. Şimdi cevapları kontrol etme zamanı!",style: o.TextStyles.optikBody1White),
            background: map.colorMap[args.exam.topic],
            autoDismiss: true);
          print('Pushing to review page');
          args.exam.reviewDuration += args.examSchedule[args.exam.nQuestions+1]['eventStartTime'].difference(returnTime).inSeconds;
          if(mounted){
            Navigator.pushReplacementNamed(
                context,
                '/exam_review_page',
                arguments: args
            );
          }
        } 
        // 3. IS EXAM ON A QUESTION OR ON A HOLD?
        else {
          print(searchList);
          for(int i in searchList){
            if(returnTime.isAfter(args.examSchedule[i]['eventStartTime'])&&
                returnTime.isBefore(args.examSchedule[i]['holdStartTime'])){
                  if(i==args.questionNumber){
                    print('Question has not changed. Breaking.');
                    break;
                  } else {
                    shouldJumpTo = i;
                    showSimpleNotification(
                      Text("Sen lobide gittin. Şimdi "+(shouldJumpTo).toString()+". sorudayız.",style: o.TextStyles.optikBody1White),
                      background: map.colorMap[args.exam.topic],
                      autoDismiss: true);
                    args.questionNumber = shouldJumpTo-1;
                    args.qList[shouldJumpTo].duration = args.examSchedule[shouldJumpTo]['holdStartTime'].difference(returnTime).inSeconds;
                    print('Pushing to question page: Question '+(1+args.questionNumber).toString());
                    print('Duration of question page is set to:'+args.qList[shouldJumpTo].duration.toString());
                    try{
                      args.cache['attendeeCount'] = await fetchAttendeeCount();
                    } catch(e) {
                      args.cache['attendeeCount'] = '~~';
                    }
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
                      Text("Sen lobide gittin. Şimdi "+shouldJumpTo.toString()+". soru arasındayız.",style: o.TextStyles.optikBody1White),
                      background: map.colorMap[args.exam.topic],
                      autoDismiss: true);
                    args.questionNumber = shouldJumpTo;
                    args.qList[shouldJumpTo].holdDuration = args.examSchedule[shouldJumpTo]['eventEndTime'].difference(returnTime).inSeconds;
                    print('Pushing to hold page of: Question '+(args.questionNumber).toString());
                    print('Duration of hold page is set to:'+args.qList[shouldJumpTo].holdDuration.toString());
                    try{
                      args.cache['attendeeCount'] = await fetchAttendeeCount();
                    } catch(e) {
                      args.cache['attendeeCount'] = '~~';
                    }
                    Navigator.pushReplacementNamed(
                    context,
                    '/exam_hold_page',
                    arguments: args
                    );
                    break;
            }
          }
        }
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print('lobby page disposed');
    super.dispose();
  }

  
  

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: map.colorMap[args.exam.topic],
      body:Stack(children:[
        Positioned.fill(child: AnimatedBackground(
          color1: map.gradientMap[args.exam.topic][0],
          color1End: map.gradientMap[args.exam.topic][1],
          color2: map.gradientMap[args.exam.topic][0],
          color2End: map.gradientMap[args.exam.topic][1],
        )),
        Positioned.fill(child: Particles(30)),
        Center(child:
          Wrap(children:[
            args.exam.lobbyAd!=null?
              Center(child:Container(
              constraints: BoxConstraints(maxHeight: 200,maxWidth: 300),
              child:TransitionToImage(
              image: AdvancedNetworkImage(
                args.exam.lobbyAd,
                retryLimit: 10,
                retryDurationFactor: 1,
                useDiskCache: true,
                cacheRule: CacheRule(maxAge: const Duration(days: 7)),
              ),
              fit: BoxFit.scaleDown,
              ))):SizedBox(),
            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              SizedBox(height: 80),
              UserCounter(widget.model),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                height: 60, 
                child:Image(image: AssetImage('assets/images/logo_negative.png'))
              ),
              SizedBox(height: 20),
              Text('Optik Deneme Sınavı\'na hoş geldin.',style: o.TextStyles.optikWhiteTitle,textAlign: TextAlign.center,),
              AnimatedTextWidget(text: "Sınav başlamak üzere!"),
              SizedBox(height: 20,),
              Text(_text,style: o.TextStyles.optikBody1White.copyWith(fontStyle:FontStyle.italic),textAlign: TextAlign.center,),
              widget.loading?Loading(negative: false,transparent: true,opacity: 0):SizedBox(),
              ]
            )
          ]
          )
        )
        ]
      )
    );
  }
}

class UserCounter extends StatelessWidget {
  final HomeViewModel model;
  UserCounter(this.model);

  Widget _getUserCount(HomeViewModel model, BuildContext context) {
    switch (model.state) {
      case ViewState.Busy:
      case ViewState.Idle:
        print('somethin2g');
        return Center(child: CircularProgressIndicator());
      default:
        return Text(model.appStats.userCount.toString(),style: o.TextStyles.optikTitle.copyWith(fontWeight:FontWeight.w800));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: o.Colors.optikWhite,
        borderRadius: BorderRadius.circular(16.0)
      ),
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width/3),
      child:Column(
        children:[
          SizedBox(height: 8.0,),
          Text('Katılımcı Sayısı',style: o.TextStyles.optikBody1,),
          Container(
            margin: EdgeInsets.only(bottom: 8.0),
            child: _getUserCount(model, context))
        ]
      )
    );
  }
}