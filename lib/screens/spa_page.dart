import 'package:Optik/collections/globals.dart';
import 'package:Optik/services/convert_functions.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/exam.dart';
import 'package:Optik/models/exam_spa.dart';
import 'package:Optik/models/spb.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/widgets/loading.dart';
import 'package:Optik/widgets/parentExamName_container.dart';
import 'package:overlay_support/overlay_support.dart';

class SPAPage extends StatefulWidget {
	const SPAPage();
  @override
  _SPAPageState createState() => _SPAPageState();
}

class _SPAPageState extends State<SPAPage> {
  bool loading;
  dynamic qList;
  Exam exam;
  SPAArguments args;
  String mostRecentQuestionID;
  bool nullPage;
  
  @override
  void initState() {
    super.initState();  
    loading = true;
    nullPage = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    
      if(args.isExam){
        if(args.cache['SPAs']!=null){
          if(args.cache['SPAs'][args.examID]!=null){
            if(args.cache['SPAs'][args.examID]['nullPage']!=null){
              if(!args.cache['SPAs'][args.examID]['nullPage']){
                exam = args.cache['SPAs'][args.examID]['exam'];
                qList = args.cache['SPAs'][args.examID]['qList'];
                nullPage = false;
                loading = false;
              } else {
                nullPage = true;
                loading = false;
              }
            }
            else {
              loading = true;
              WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context)); 
            }
          } else{
            loading = true;
            WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
          }} else{
          loading = true;
          args.cache['SPAs']={};
          WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
        }
      } else {
        if(args.cache['SPAs']!=null){
          if(args.cache['SPAs'][args.topic]!=null){
            if(!args.cache['SPAs'][args.topic]['nullPage']){
              // mostRecentQuestionID = args.cache['SPAs'][args.topic]['mostRecentQuestionID'];
              qList = args.cache['SPAs'][args.topic]['qList'];
              nullPage = false;
              loading = false;
            } else{
              nullPage = true;
              loading = false;
            }
          } else{
            loading = true;
            WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
          }} else{
          loading = true;
          args.cache['SPAs']={};
          WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
        }
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
                onPressed: () {Navigator.of(context).pop();},
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          backgroundColor: o.Colors.optikWhite,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[            
              SizedBox(width: MediaQuery.of(context).size.width*3/8,
                child:AutoSizeText(
                  args.title,
                  maxLines: 2,
                  minFontSize: 9,
                  overflow: TextOverflow.ellipsis,
                  style:o.TextStyles.optikBoldTitle)
              ),
              ParentExamNameContainer(args.isExam?args.parentExamName:'Deneme Soruları')
            ]
          ),
        ),
      body:loading?
        Loading(negative: true):
          nullPage?
            Center(child:Text(
              args.isExam?"Bu sınava katılmadınız veya sonuçlar henüz açıklanmadı.":"Bu konuda hiç soru çözmediniz. Anasayfadan Deneme Soruları butonuna basarak çözmeye başlayın!",style:o.TextStyles.optikBody1Bold,textAlign:TextAlign.center)):
              ExamSPA(
                qList: qList,
                parentTopic: args.parentTopic,
                topic: args.topic,
                examDate: args.isExam?exam.examDate:null,
                parentExamName: args.parentExamName,
                isExam: args.isExam
              )
    );
  }

  onAfterBuild(BuildContext context) async {
    if(loading) {
      if(!NO_INTERNET){
        if(args.isExam){
          try{
            args.cache['SPAs'][args.examID]={};
            args.cache['SPAs'][args.examID]['cacheTime'] = DateTime.now();
            exam = await fetchExam(forAnyExam: true,examID: args.examID).then((exam)=>convertExam(exam));
            print("exam fetched");
            qList = await fetchQList(userID: args.userID, examID: args.examID, forResult: true, questionIDs:exam.questionIDs);
            print("qList fetched");
            print(qList);
            if(qList!=null){
              args.cache['SPAs'][args.examID]['exam']=exam;
              args.cache['SPAs'][args.examID]['qList']=qList;
              args.cache['SPAs'][args.examID]['nullPage']=false;
              if(mounted){
                setState(() {
                  nullPage=false;
                });
              }
            } else {
              if(mounted){
                setState(() {
                  args.cache['SPAs'][args.examID]['nullPage']=true;
                  nullPage=true;
                });
              }
            }
          } catch(e){
            if(mounted){
              setState(() {
                nullPage=true;
              });
            }
          }
        } else {
          args.cache['SPAs'][args.topic]={};
          args.cache['SPAs'][args.topic]['cacheTime'] = DateTime.now();
          print(args.userID);
          qList = await fetchQList(userID: args.userID,subTopic:args.topic,isExam: args.isExam, forResult: true);
          if(qList != null){
            args.cache['SPAs'][args.topic]['nullPage']=false;
            args.cache['SPAs'][args.topic]['qList']=qList;
            // args.cache['SPAs'][args.topic]['mostRecentQuestionID'] = qList[1].questionID;
            if(mounted){
              setState(() {
                args.cache['SPAs'][args.topic]['nullPage']=false;
                nullPage=false;
              });
            }
          } else {
            if(mounted){
              setState(() {
                args.cache['SPAs'][args.topic]['nullPage']=true;
                nullPage=true;
              });
            }
          }
        }
        // Burada deneme soruları ve deneme sınavları aynı kodu çalıştıracak. Birkaç nüans farkı var.
        // Bu nüans farklarını isExam bool operatörüyle handle ediyoruz.
        // aşağıdaki exam, isExam true ise args.examID kullanılarak dolması lazım.
        // bir altındaki qList iki şekilde dolabilir:
        // isExam true ise: args.examID + args.username kullanılarak (deneme sınavları için)
        // isExam false ise: args.topic + args.username kullanılarak (deneme soruları için)
        // [TODO END]
        if(mounted){
          setState(() {
            loading=false;
          });
        }
      } else {
        showSimpleNotification(Text('Lütfen internet bağlantınızı kontrol edin.'));
        Navigator.of(context).pop();
      }
    } 
  }
}