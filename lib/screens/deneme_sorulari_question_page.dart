import 'dart:collection';
import 'package:intl/date_symbol_data_local.dart';
import 'package:Optik/collections/globals.dart';
import 'package:Optik/models/deneme_sorulari_topic_button.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/question.dart';
import 'package:Optik/models/question_widget_denemesorulari.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/deneme_sorulari_select_parenttopic_page.dart';
import 'package:Optik/services/convert_functions.dart';
import 'package:Optik/services/post_functions.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:Optik/widgets/signup_sonraki_button.dart';
import 'package:overlay_support/overlay_support.dart';

class DenemeSorulariQuestionPage extends StatefulWidget {
  DenemeSorulariQuestionPage({Key key}) : super(key: key);  
  @override
  State<DenemeSorulariQuestionPage> createState() => _DenemeSorulariQuestionPageState();
}

class _DenemeSorulariQuestionPageState extends State<DenemeSorulariQuestionPage> {
  bool loading;
  DenemeSorulariInherited args;
  bool sending;
  bool noQuestionLeft;
  bool reloadState;
  bool isTappable;

  @override
  void initState() {
    super.initState();
    loading = true;
    sending = false;
    noQuestionLeft = true;
    reloadState = false;
    isTappable = true;
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
  }

  onAfterBuild(BuildContext context) async {
    print(loading);
    print(mounted);
    if(loading&&mounted){
      if(!NO_INTERNET){
        try{
          args.pageArgs.qCount ++;
          // STEP 1. BRING A QUESTION
          args.questions[args.pageArgs.qCount] = await fetchQuestion(isDenemeSorusu: true, 
            subtopic:args.pageArgs.subTopicCode,
              userID: args.args['user'].id
          ).then((response)=>convertQuestion(response));
          // STEP 2. CHECK IF THE QUESTION IS NULL (MEANS: THERE'S NO QUESTION LEFT)
          if(args.questions[args.pageArgs.qCount]==null){
            args.pageArgs.qCount --;
            // STEP 3. CHECK IF THIS IS THE FIRST QUESTION. IF SO, POP CONTEXT DIRECTLY
            if(args.pageArgs.qCount == 0){
              showSimpleNotification(
                Text("Bu konudaki bütün soruları çözdün, tebrikler!"),
                background: o.Colors.optikBlue,
                autoDismiss:false,
                trailing: Builder(builder: (context) {
                  return FlatButton(
                      textColor: Colors.yellow,
                      onPressed: () {
                        OverlaySupportEntry.of(context).dismiss();
                      },
                      child: Text('Tamam'));
                  }));
              Navigator.of(context).pop();
            } else {
              // STEP 4. IF THE QUESTION SOMEWHERE IN THE MIDDLE, CHANGE THE SCREEN
              if(mounted){
                setState(() {
                  noQuestionLeft = true;
                });
              }
            }
          } else {
            if(mounted){
              setState(() {
                noQuestionLeft = false;
              });
            }
          }
          if(mounted){
              setState(() {
                reloadState = false;
                loading=false;
            });
          }
        } catch(e) {
          if(mounted){
            setState(() {
              reloadState = true;
              isTappable = true;
            });
          }
        }
      } else{
        if(mounted){
          setState(() {
            reloadState = true;
            isTappable = true;
          });
        }
      }
    }
  }

  void addQuestionToCache({dynamic cache, Question thisQuestion, String subtopic, int questionNumber, @required String topic }){
    thisQuestion.answerTime = DateTime.now().add(Duration(milliseconds: timeOffset));
    if(cache['DenemeSorulariStatsPage']!=null){
      List<dynamic> histogramList = cache['DenemeSorulariStatsPage']['histogramListSubTopics'][topic];
        for (int i=0;i<histogramList.length;i++){
          if(histogramList[i]['topic']==subtopic){
            histogramList[i]['nQuestions']++;
          }
        }
      cache['DenemeSorulariStatsPage']['histogramListSubTopics'][topic] = histogramList;
    }
    if(cache['SPAs']!=null){
      if(cache['SPAs'][subtopic]!=null){
        if(!cache['SPAs'][subtopic]['nullPage']){
          /* int minIndex = cache['SPAs'][subtopic]['qList'].keys.toList()[0];
          dynamic temp = {DateTime.now().add(Duration(milliseconds:timeOffset)):thisQuestion};
          temp.addAll(cache['SPAs'][subtopic]['qList']); */
          cache['SPAs'][subtopic]['qList'][
            DateTime.now().add(Duration(days:99999)).toUtc().toString()]=thisQuestion;
          // soruyu cache'e ekle
        } else {
          cache['SPAs'][subtopic] = {};
          cache['SPAs'][subtopic]['cacheTime'] = DateTime.now();
          cache['SPAs'][subtopic]['qList'] = SplayTreeMap<dynamic,dynamic>();
          cache['SPAs'][subtopic]['qList'][
            DateTime.now().add(Duration(days:99999)).toUtc().toString()]=thisQuestion;
          cache['SPAs'][subtopic]['nullPage'] = false;
          // sıfırdan cache yarat
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    final nav = Navigator.of(context);
    return WillPopScope(
      onWillPop: sending?(){return null;}:(){
        showDialog (
          context: context,
          builder: (BuildContext context) {
            return AlertDialog (
              title: Text("Uyarı",style: o.TextStyles.optikBody1Bold,),
              content:
              Wrap(children:[
                Text("Deneme Soruları seansını bitirmek istiyor musunuz? Şu anki sorunuz cevapsız olarak kaydedilecektir.",style: o.TextStyles.optikTitle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                    GestureDetector(
                      onTap: () async {
                        if(!sending&&mounted){
                          setState(() {
                            sending = true;
                          });
                          args.questions[args.pageArgs.qCount].userChoice = 'X';
                          bool res = await sendAnswer( // [POST FUNCTION]
                            userID:args.pageArgs.userID,
                            answer:args.questions[args.pageArgs.qCount].userChoice,
                            questionID:args.questions[args.pageArgs.qCount].questionID,
                            isExam: false);
                          if(res){
                            args.pageArgs.nEmpty++;
                            addQuestionToCache(
                            cache:args.args['cache'], 
                            thisQuestion:args.questions[args.pageArgs.qCount], 
                            subtopic:args.pageArgs.subTopicCode, 
                            questionNumber:args.pageArgs.qCount,
                            topic:args.pageArgs.topicMap[args.pageArgs.parentTopicChoice][args.pageArgs.topicChoice]);
                            Navigator.pop(context);
                            nav.pushReplacementNamed(
                              '/deneme_sorulari_session_end',
                              arguments:args
                            );
                          } 
                          setState(() {
                            sending = false;
                          });
                        }
                      },
                      child: Text('Bitir',style: o.TextStyles.optikBody1Bold)
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
        return null;
      },
      child:
      reloadState?Scaffold(body:Center(child:RaisedButton(
      color: o.Colors.optikBlue,
      child: Text('İnternet bağlantısı bulunamadı. Tekrar dene.',style: o.TextStyles.optikBody1White,),
      onPressed: !isTappable?(){}:() async {
        setState(() {
          isTappable = false;
        });
        print('trying again...');
        await onAfterBuild(context);
      },
      ))):loading?Loading(negative: true):
      noQuestionLeft?
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Seans Bitti"),
          automaticallyImplyLeading: false,
        ),
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
          Text("Bu konudaki bütün soruları çözdün, tebrikler!"),
          TopicButton(
            text: 'Bitir',
            color: args.pageArgs.colorMap[args.pageArgs.topicMap[args.pageArgs.parentTopicChoice][args.pageArgs.topicChoice]],
            onPressed: (){ 
              Navigator.pushReplacementNamed(
                context,
                '/deneme_sorulari_session_end',
                arguments: args);
              },
            width:MediaQuery.of(context).size.width/4)
        ]))
      ):
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children:[
              SizedBox(
                width:MediaQuery.of(context).size.width*2/3,
                child:AutoSizeText(
                  args.pageArgs.parentTopicChoice+' '+args.pageArgs.topicChoice,
                  style: o.TextStyles.optikWhiteTitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis
                )
              ),
              Text(args.pageArgs.subTopicChoice==null?
                "":
                args.pageArgs.subTopicChoice,style: o.TextStyles.optikBody1White,)
            ]
          ),
          leading: GestureDetector(
            onTap: sending?(){}:(){
              showDialog (
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog (
                    title: Text("Uyarı",style: o.TextStyles.optikBody1Bold,),
                    content:
                    Wrap(children:[
                      Text("Deneme Soruları seansını bitirmek istiyor musunuz? Şu anki sorunuz cevapsız olarak kaydedilecektir.",style: o.TextStyles.optikTitle),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:[
                          GestureDetector(
                            onTap: () async {
                              if(!sending&&mounted){
                                setState(() {
                                  sending = true;
                                });
                                args.questions[args.pageArgs.qCount].userChoice = 'X';
                                bool res = await sendAnswer( // [POST FUNCTION]
                                  userID:args.pageArgs.userID,
                                  answer:args.questions[args.pageArgs.qCount].userChoice,
                                  questionID:args.questions[args.pageArgs.qCount].questionID,
                                  isExam: false);
                                if(res){
                                  args.pageArgs.nEmpty++;
                                  addQuestionToCache(
                                  cache:args.args['cache'], 
                                  thisQuestion:args.questions[args.pageArgs.qCount], 
                                  subtopic:args.pageArgs.subTopicCode, 
                                  questionNumber:args.pageArgs.qCount,
                                  topic:args.pageArgs.topicMap[args.pageArgs.parentTopicChoice][args.pageArgs.topicChoice]);
                                  Navigator.pop(context);
                                  nav.pushReplacementNamed(
                                    '/deneme_sorulari_session_end',
                                    arguments:args
                                  );
                                }
                                setState(() {
                                  sending = false;
                                });
                              }
                            },
                            child: Text('Bitir',style: o.TextStyles.optikBody1Bold)
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
            },
            child:Center(child:Text('Bitir',style: o.TextStyles.optikBody1BoldWhite,))
          ),
          backgroundColor: args.pageArgs.colorMap[args.pageArgs.topicMap[args.pageArgs.parentTopicChoice][args.pageArgs.topicChoice]],
          actions: <Widget>[
            GestureDetector(
            onTap: sending?(){}:() async {
              setState(() {
                sending=true;
              });
              args.questions[args.pageArgs.qCount].userChoice = 'X';
              bool res = await sendAnswer( // [POST FUNCTION]
                userID:args.pageArgs.userID,
                answer:args.questions[args.pageArgs.qCount].userChoice,
                questionID:args.questions[args.pageArgs.qCount].questionID,
                isExam: false);
              if(res){
                args.pageArgs.nEmpty++;
                addQuestionToCache(
                cache:args.args['cache'], 
                thisQuestion:args.questions[args.pageArgs.qCount], 
                subtopic:args.pageArgs.subTopicCode, 
                questionNumber:args.pageArgs.qCount,
                topic:args.pageArgs.topicMap[args.pageArgs.parentTopicChoice][args.pageArgs.topicChoice]);
                Navigator.pushReplacementNamed(
                  context,
                  '/deneme_sorulari_answer',
                  arguments:args
                );
              }
              setState(() {
                sending = false;
              });
            }, 
            child:Padding(
                padding: EdgeInsets.only(right:12.0),
                child:Center(child:Text('Pas',style: o.TextStyles.optikBody1BoldWhite,))
              )
            )
          ],
        ),
        body: Stack(children:[
          ListView(children:[
            QuestionWidgetDenemeSorulari(
              q: args.questions[args.pageArgs.qCount],
              active: true),
            SizedBox(height: 500)
            ]
          ),
          sending?Loading(negative: true,transparent:true,opacity:0.5):SizedBox()
          ]
        ),
        bottomSheet: SignupSonrakiButton(
          onPressed:sending?(){}: () async {
            setState(() {
              sending = true;
            });
            if(args.questions[args.pageArgs.qCount].userChoice==null){
              args.questions[args.pageArgs.qCount].userChoice='X';
            }
            bool res = await sendAnswer( // [POST FUNCTION]
              userID:args.pageArgs.userID,
              answer:args.questions[args.pageArgs.qCount].userChoice,
              questionID:args.questions[args.pageArgs.qCount].questionID,
              isExam: false);
            if(res){
              args.questions[args.pageArgs.qCount].userChoice == 'X' ? 
              args.pageArgs.nEmpty++ :
                args.questions[args.pageArgs.qCount].userChoice == args.questions[args.pageArgs.qCount].correctChoice ? 
                    args.pageArgs.nCorrect++ : 
                      args.pageArgs.nIncorrect++;
              addQuestionToCache(
              cache:args.args['cache'], 
              thisQuestion:args.questions[args.pageArgs.qCount], 
              subtopic:args.pageArgs.subTopicCode, 
              questionNumber:args.pageArgs.qCount,
              topic:args.pageArgs.topicMap[args.pageArgs.parentTopicChoice][args.pageArgs.topicChoice]);
              Navigator.pushReplacementNamed(
                context,
                '/deneme_sorulari_answer',
                arguments: args
              );
            }
            setState(() {
              sending = false;
            });
          },
          color: o.Colors.optikBlue,
          title:'Gönder'),
      ));
  }
}