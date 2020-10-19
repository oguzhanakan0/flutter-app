import 'package:Optik/collections/globals.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Optik/services/convert_functions.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/exam.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/collections/topic_map.dart' as map;
import 'package:intl/intl.dart';

class Schedule extends StatefulWidget {
  // a property on this class
  Schedule({Key key}) : super(key: key);
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  bool loading;
  List<Exam> exams;
  Map<dynamic,dynamic> args;
  bool reloadState;
  bool isTappable;

  @override
  void initState() {
    super.initState();  
    loading = true;
    reloadState = false;
    isTappable = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    if(args['cache']['SchedulePage']!=null){
      exams = args['cache']['SchedulePage']['exams'];
      loading = false;
    } else{
      loading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
    }
  }

  onAfterBuild(BuildContext context) async {
    if(loading&&mounted){
      if(!NO_INTERNET){
        try{
          args['cache']['SchedulePage']={};
          args['cache']['SchedulePage']['cacheTime'] = DateTime.now();
          exams = await fetchExam(forSchedule: true).then((response){
            List<Exam> res = [];
            if(response!=null){
              for(var i in response){
                res.add(convertExam(i));
              }
            }
            return res;
            }
          );
          args['cache']['SchedulePage']['exams'] = exams;
          setState(() {
            reloadState = false;
            loading=false;
          });
        } catch(e){
          setState(() {
            reloadState = true;
            isTappable = true;
          });
        }
      } else {
        setState(() {
          reloadState = true;
          isTappable = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context).copyWith(dividerColor: Colors.white.withAlpha(0));
    return reloadState?Center(child:RaisedButton(
      color: o.Colors.optikBlue,
      child: Text('İnternet bağlantısı bulunamadı. Tekrar dene.',style: o.TextStyles.optikBody1White,),
      onPressed: !isTappable?(){}:() async {
        setState(() {
          isTappable = false;
        });
        await onAfterBuild(context);
      },
    )):loading?Loading(negative: true):exams.length==0?
      Center(child:Text("Şu an takvimde bir sınav gözükmüyor. Planlanan sınavları bu ekranda görebilirsiniz.",style: o.TextStyles.optikBody1Bold,textAlign: TextAlign.center,)):
        ListView.builder(
          itemCount: exams.length,
          itemBuilder: (context, exam) {
            return ScheduleItem(exam: exams[exam],themedata: themedata);
          },
      );
  }
}

class ScheduleItem extends StatelessWidget {
  final Exam exam;
  final ThemeData themedata;
  ScheduleItem({this.exam, this.themedata});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    initializeDateFormatting();
    int nSubtopics = exam.subjectMap.keys.toList().length;
    String subjectList = '';
    if(exam.subjectMap!=null){
      if (nSubtopics == 1) {
        subjectList = exam.subjectMap[exam.topic].toString()
            .replaceAll('[','')
            .replaceAll(']','')+'\n';
      } else {
        for (var i in exam.subjectMap.keys) subjectList+= 
          map.subTopicMap2[exam.topic][i]+' : '
          +exam.subjectMap[i].toString()
            .replaceAll('[','')
            .replaceAll(']','')+'\n';
      }
    }
    /* String _suffix = exam.examDate.difference(DateTime.now()).inHours<=24 ?' *SIRADAKİ*':''; */
    return Theme(data: themedata, child:Container(
      decoration: BoxDecoration(
        color: o.Colors.optikWhite,
        border: Border.all(width: 1.0,color: o.Colors.optikBorder),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(left:8.0,right:8.0,top:4.0,bottom: 4.0),
      child:ExpansionTile(
        key: PageStorageKey('examScrollable'+exam.examID),
        title: Row(
          children:[
            Container(
              margin: EdgeInsets.only(right:16),
              width: width*6/25,
              height: width*6/25,
              decoration: BoxDecoration(
                color: map.colorMap[exam.topic],
                borderRadius: BorderRadius.all(Radius.circular(16.0 )),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(exam.parentExamName,style: o.TextStyles.optikBody2White,),
                  Center(child:AutoSizeText(exam.topic,style: o.TextStyles.optikHeaderWhite))]
              ),
            ),
            Container(
              width: width*3/8,
              child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(DateFormat('dd MMMM yyyy','tr').format(exam.examDate.toLocal())/* _suffix */,style: o.TextStyles.optikBody2),
                Text(DateFormat('EEEE','tr').format(exam.examDate.toLocal()),style: o.TextStyles.optikSubTitle),
                Text(DateFormat('HH:mm','tr').format(exam.examDate.toLocal()),style: o.TextStyles.optikSubTitle),
                AutoSizeText(map.topicMap[exam.parentTopic][exam.topic],style: o.TextStyles.optikBoldTitle,maxLines: 4,),
                /* Text(exam.description,style: o.TextStyles.optikSubTitle) */]))]),
        children: [
          SizedBox(height: 8.0),
          Text('Testte Çıkacak Konular',style: o.TextStyles.optikBody1Bold,),
          Text(subjectList,style: o.TextStyles.optikBody1,textAlign: TextAlign.center,),
          Text('Toplam Soru Sayısı',style: o.TextStyles.optikBody1Bold,),
          Text(exam.nQuestions.toString(),style: o.TextStyles.optikBoldTitle)
        ],
      )
    ));
  }
}