import 'package:Optik/collections/globals.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Optik/services/convert_functions.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/exam.dart';
/* import 'package:Optik/models/actual_timer.dart'; */
import 'package:Optik/models/countdown_timer.dart';
import 'package:Optik/collections/question.dart';
import 'package:Optik/models/question_widget_gununsorusu.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/models/gunun_sorusu.dart';
import 'package:Optik/collections/topic_map.dart' as map;
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Exam todaysExam;
  Question gununSorusu;
  bool loading;
  Map<dynamic,dynamic> args;
  bool reloadState;
  bool isTappable;
  /* User user; */
  @override
  void initState() {
    super.initState();
    loading = true;
    reloadState = false;
    isTappable = true;
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    todaysExam = args['cache']['todaysExam'];
    if(args['cache']['HomePage']!=null){
      gununSorusu = args['cache']['HomePage']['gununSorusu'];
      loading = false;
    } else{
      loading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Session ID:' +SESSION_ID);
    initializeDateFormatting();
    /* args = ModalRoute.of(context).settings.arguments; */
    /* final User user = args['user']; */
    final size = MediaQuery.of(context).size;
    return reloadState?Scaffold(body:Center(child:RaisedButton(
      color: o.Colors.optikBlue,
      child: Text('İnternet bağlantısı bulunamadı. Tekrar dene.',style: o.TextStyles.optikBody1White,),
      onPressed: !isTappable?(){}:() async {
        setState(() {
          isTappable = false;
        });
        await onAfterBuild(context);
      },
      ))):loading?Loading(negative: true):ListView(
      children: <Widget>[
        Container(
          width:double.infinity,
          height: size.height*.65,
          constraints: BoxConstraints(minHeight: 400),
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(bottom: 8.0),
          decoration:BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: map.gradientMap[todaysExam.topic])),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            /* ActualTimer(), */
            Container(height: 60, child:Image(image: AssetImage('assets/images/logo_negative.png'))),
            Text(DateFormat('dd MMMM yyyy','tr').format(todaysExam.examDate.toLocal()),
              style: o.TextStyles.optikBody2White),
            Text(DateFormat('HH:mm','tr').format(todaysExam.examDate.toLocal()),
              style: o.TextStyles.optikBody2Bold.copyWith(color:o.Colors.optikWhite)),
            Divider(endIndent: 100.0,indent: 100.0,color: o.Colors.optikWhite,),
            Text(todaysExam.parentTopic,
              style: o.TextStyles.optikBody2White),
            AutoSizeText(
              map.topicMap[todaysExam.parentTopic][todaysExam.topic],
              style: o.TextStyles.optikHeaderWhite,
              minFontSize: 18,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Divider(endIndent: 100.0,indent: 100.0,color: o.Colors.optikWhite),
            CountdownTimer(
              width:120.0,
              height:120.0, 
              referenceDate: args['cache']['referenceDate'],
              examDate: args['cache']['todaysExam'].examDate,
              textStyle:o.TextStyles.optikWhiteTitle.copyWith(fontSize: 28.0)
            ),
            Text('Sayaç bittiğinde test otomatik olarak başlayacak',
              style: o.TextStyles.optikBody2White),
            ]
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width -16.0,
              height: 75.0,
              decoration: BoxDecoration(
                border: Border.all(width: 4.0,color: map.colorMap[todaysExam.topic]),
                borderRadius: BorderRadius.all(Radius.circular(16.0 )),
              ),
              child:FlatButton(
                child: Text('Deneme\nSoruları',style: o.TextStyles.optikBody1Bold,textAlign: TextAlign.center,),
                onPressed: (){
                  Navigator.pushNamed(
                    context,
                    '/deneme_sorulari_select_parenttopic',
                    arguments: args
                    );},
              )
            )
          ]
        ),
        Visibility(
          visible: SHOW_TODAYS_QUESTION,
          child:GununSorusu(title:'Günün Sorusu',
            child: SHOW_TODAYS_QUESTION ? QuestionWidgetGununSorusu(
              q: gununSorusu,
              active: gununSorusu.deadline.isAfter(DateTime.now().add(Duration(milliseconds: timeOffset)))?true:false,
              username: args['user'].username,
              userID: args['user'].googleUserID,
            ): SizedBox()
          )
        ),
        /* SizedBox(height: 80,),
        FlatButton(
              child: Text('başlat'),
              onPressed: (){
                Navigator.pushNamed(
                    context,
                    '/lobby',
                    arguments: args
                );
              },
            ),
        FlatButton(
          child: Text('print cache'),
          onPressed: (){
            for (var i in args['cache'].keys){
              print(i);
              print(args['cache'][i]);
              print('-----');
            }
          },
        ),
        RaisedButton(
          onPressed: (){
            Navigator.pushNamed(context, '/live_users');
          },
          child: Text('Show live users'),
        ), */
      ]
    );
  }

  onAfterBuild(BuildContext context) async {
    if(loading&&mounted){
      if(!NO_INTERNET){
        try{
          args['cache']['HomePage']={};
          args['cache']['HomePage']['cacheTime'] = DateTime.now();
          if(SHOW_TODAYS_QUESTION){
            gununSorusu = await fetchQuestion(isGununSorusu: true,userID: args['user'].googleUserID).then((response)=>convertQuestion(response));
            print("today's question fetched:");
            print(gununSorusu.userChoice);
            print(gununSorusu.correctChoice);
            gununSorusu.isTappable = gununSorusu.userChoice==null?true:false;
            print("isTappable set to:");
            print(gununSorusu.isTappable);
            args['cache']['HomePage']['gununSorusu']  = gununSorusu;
          }
          if(mounted){
            setState(() {
              loading=false;
              reloadState = false;
            });
          }
        } catch(e){
          if(mounted){
            setState(() {
              reloadState = true;
              isTappable = true;
            });
          }
        }
      } else {
        if(mounted){
          setState(() {
            reloadState = true;
            isTappable = true;
          });
        }
      }
    }
  }
}