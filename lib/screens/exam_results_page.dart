import 'package:Optik/collections/globals.dart';
import 'package:Optik/collections/parentExam.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/exam_spa.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/exam_lobby_page.dart';
import 'package:Optik/widgets/animated_container.dart';
import 'package:Optik/widgets/loading.dart';

import 'myresults.dart';

class OptikExamResultsPage extends StatefulWidget {
	final String username;
  final String examID;
  final String examParentID;
  final String examParentName;
  final String title;
	OptikExamResultsPage({
    this.username, 
    this.examID,
    this.title,
    this.examParentID,
    this.examParentName});
  @override
  _OptikExamResultsPageState createState() => _OptikExamResultsPageState();
}

class _OptikExamResultsPageState extends State<OptikExamResultsPage> {
  bool _isSiralamaVisible = true;
  double _siralamaContainerHeight;
  bool loading;
  bool loading2;
  bool loading3;
  bool reloadState;
  bool isTappable;
  int siralama;
  String katilimci;
  OptikExamInherited args;
  @override
  void initState() {
    super.initState();
    loading = true;
    loading2 = false;
    loading3 = true;
    reloadState = false;
    isTappable = true;
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    args.exam.lastExam?_siralamaContainerHeight = 190:_siralamaContainerHeight = 90;
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
    if(args.exam.implementMaximumTime){
      pushToHome();
    }
    fetchAnswers();
  }

  void pushToHome() async{
    await Future.delayed(Duration(seconds: MAXIMUM_TIME));
    if(mounted){
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'user':args.user,'cache':Map<String,dynamic>()}
      );
    }
  }

  void fetchAnswers() async {
    setState(() {
      loading2 = true;
    });
    var answList = await fetchFinalAnswers(examID: args.exam.examID);
    print(answList);
    if(answList!=null){
      for(var i in args.qList.values){
        for(var j in answList){
          if(i.questionID==j['_id']){
            i.userChoice = j['userChoice']??"X";
            break;
          }
        }
      }
      if(mounted){
        setState(() {
          reloadState = false;
          loading2 = false;
        });
      }
    } else {
      if(mounted){
        setState(() {
          reloadState = true;
          loading2 = false;
        });
      }
    }
  }
  
  onAfterBuild(BuildContext context) async {
    dynamic response = await fetchTekilSiralama(examID: args.exam.examID);
    siralama = response["rank"];
    katilimci = args.cache['attendeeCount'];
    if(mounted){setState(() {
        loading=false;
      });
    }
  }

  @override
	Widget build(context) { 
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios,color: o.Colors.optikBlack,),
                onPressed: () {
                  /* Navigator.of(context).pop(); */
                  Navigator.pushReplacementNamed(
                    context,
                    '/home',
                    arguments: {'user':args.user,'cache':Map<String,dynamic>()});
                  },
                /* tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip, */
              );
            },
          ),
          backgroundColor: o.Colors.optikWhite,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text('Test Sonucu',
                style:o.TextStyles.optikBoldTitle),
              Container(
              width: 90.0,
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: o.Colors.optikBlack,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child:Center(child:Text(args.parentExam.parentExamName,style: o.TextStyles.optikBody2White))
            )
            ]
          ),
        ),
      bottomSheet:
        Container(
          width: double.infinity,
          height: _siralamaContainerHeight,
          child:
          Column(children:[
            args.exam.lastExam?
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/spb', arguments: SPBArguments(
                  parentExam: ParentExam(parentExamName:args.exam.parentExamName),
                  username: args.user.username,
                  userID: args.user.id,
                  cache: args.cache
                ));
              },
              child:ColorChanger(
                color1: o.Colors.optikBlue,
                color2: o.Colors.optikMatematikGradient,
                text: Text(
                  'Tüm sınav sona erdi!\nGenel sonuçlarını görmek için tıkla.',
                  style: o.TextStyles.optikBody1White,
                  textAlign: TextAlign.center,),
                radius: 16.0,
                margin: 16.0)):SizedBox(),
            GestureDetector(
              child: Text(
                _isSiralamaVisible?'Sıralamamı Gizle':'Sıralamamı Göster',
                style: o.TextStyles.optikBody1Bold,
                textAlign: TextAlign.center,),
              onTap: (){
                setState(() {
                  _isSiralamaVisible = !_isSiralamaVisible;
                  _isSiralamaVisible ? 
                    args.exam.lastExam ? 
                      _siralamaContainerHeight= 190: 
                      _siralamaContainerHeight = 90: 
                    args.exam.lastExam ?
                      _siralamaContainerHeight = 120:
                      _siralamaContainerHeight = 20;
                });
              },
            ),
            Visibility(
              visible: _isSiralamaVisible,
              child:Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0,color: o.Colors.optikGray),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                padding: EdgeInsets.symmetric(vertical: 8.0),
                margin: EdgeInsets.all(8.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Sıralaman', style: o.TextStyles.optikBody1),
                    Container(
                      margin: EdgeInsets.only(left: 4.0,right: 2.0),
                      padding: EdgeInsets.all(4.0),                 
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: o.Colors.optikBlue,
                      ),
                      child:loading?Loading(negative:false,transparent: false,size: 24.0):Text(siralama.toString(), style: o.TextStyles.optikBoldTitle.copyWith(color:o.Colors.optikWhite))
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 2.0,right: 4.0),
                      padding: EdgeInsets.all(4.0),                 
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: o.Colors.optikGray,
                      ),
                      child:loading?Loading(negative:false,transparent: true,size: 24.0):Text(katilimci, style: o.TextStyles.optikBoldTitle.copyWith(color:o.Colors.optikWhite))
                    ),
                    Text('Katılımcı Sayısı', style: o.TextStyles.optikBody1),
                  ]
                )
              )
            ),
          ]
        )
      ),
      body:loading2?Loading(negative: true):
        reloadState?Center(child:RaisedButton(
          color: o.Colors.optikBlue,
          child: Text('İnternet bağlantısı bulunamadı. Tekrar dene.',style: o.TextStyles.optikBody1White,),
          onPressed: !isTappable?(){}:() async {
            setState(() {
              isTappable = false;
            });
            fetchAnswers();
          },
        )
      ):
      ExamSPA(
        qList: args.qList,
        parentTopic: args.exam.parentTopic,
        parentExamName: args.parentExam.parentExamName,
        examDate: args.exam.examDate,
        topic: args.exam.topic,
        isExam: true,
      )
    );
  }
}