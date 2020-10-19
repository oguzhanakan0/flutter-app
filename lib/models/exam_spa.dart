import 'package:Optik/collections/globals.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/collections/question.dart';
import 'package:Optik/collections/topic_map.dart' as map;
import 'package:Optik/models/question_widget.dart';
import 'package:intl/intl.dart';

class ExamSPA extends StatefulWidget {
  final String parentExamName;
  final String parentTopic;
  final String topic;
  final DateTime examDate;
  final dynamic qList;
  final bool isExam;
  /* final DateTime parentExamEndDate; */
  ExamSPA({
    Key key,
    @required this.parentExamName,
    @required this.parentTopic,
    @required this.examDate,
    @required this.topic,
    this.isExam = true,
    /* @required this.parentExamEndDate, */
    @required this.qList}) : super(key: key);
  @override
  _ExamSPAState createState() => _ExamSPAState();
}
class _ExamSPAState extends State<ExamSPA> {
  List<dynamic> questions;
  List<bool> visibilityList;
  List<bool> correctnessList;
  List<String> stats;
  @override
  void initState() {
    super.initState();
    print(widget.qList.keys.toList());
    if(widget.isExam){
      questions = widget.qList.values.toList();
    } else {
      print('questions reversed!');
      print(List.from(widget.qList.keys.toList().reversed));
      questions = List.from(widget.qList.values.toList().reversed);
    }
    visibilityList = List<bool>.generate(questions.length, (int index) => true);
    correctnessList = isQuestionCorrectList(questions);
    stats = calculateResults(questions);
  }
  bool isSwitched = false;
  
  List<String> calculateResults(List<dynamic> questions){
    int toplam = questions.length;
    int dogru = 0;
    int yanlis = 0;
    int bos = 0;
    double net = 0;
    for (Question question in questions) {
      question.userChoice = question.userChoice??"X";
      if(question.userChoice == 'X'){
        bos++;
      } else if (question.userChoice == question.correctChoice){
        dogru++; 
        net++;
      } else{
        yanlis++;
        net -= 0.25;
      }
    }
    return [toplam.toString(),dogru.toString(),yanlis.toString(),bos.toString(),net.toString()];
  }

  List<bool> isQuestionCorrectList(List<dynamic> questions){
    List<bool> res = [];
    for (int i=0;i<questions.length;i++) {
      if(questions[i].userChoice == 'X'){
        res.add(false);
      } else if (questions[i].userChoice == questions[i].correctChoice){
        res.add(true);
      } else{
        res.add(false);
      }
    }
    return res;
  }

  Container getOverallResultNumbers(List<String> stats) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: o.Colors.optikWhite,
      padding: EdgeInsets.only(top:8.0,bottom: 8.0),
      child:Table(
        children: [
          TableRow(
            children: [ 
              Center(child:Text('Toplam',style: o.TextStyles.optikBody2)),
              Center(child:Text('Doğru',style: o.TextStyles.optikBody2)),
              Center(child:Text('Yanlış',style: o.TextStyles.optikBody2)),
              Center(child:Text('Boş',style: o.TextStyles.optikBody2)),
              Center(child:Text('Net',style: o.TextStyles.optikBody2)),
          ]),
          TableRow(
            children: [
              Center(child:Text(stats[0],style: o.TextStyles.optikBody1Bold)),
              Center(child:Text(stats[1],style: o.TextStyles.optikBody1Bold)),
              Center(child:Text(stats[2],style: o.TextStyles.optikBody1Bold)),
              Center(child:Text(stats[3],style: o.TextStyles.optikBody1Bold)),
              Center(child:Text(stats[4],style: o.TextStyles.optikBody1Bold)),
          ]),
        ],
      )
    );
  }

  ListView _buildList(context, List<dynamic> questions, List<bool> visibilityList) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.white.withAlpha(0));
    return ListView.builder(
      itemCount: questions.length+1,
      itemBuilder: (context, questionIndex) {
        if(questionIndex==questions.length){
          return SizedBox(height: 300,);}
        else{
          return QuestionExpandable(
            index:questionIndex+1,
            question:questions[questionIndex],
            theme:theme,
            isVisible:visibilityList[questionIndex],
            isExam: widget.isExam);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    List<Widget> headerChildren = [];
    Widget bottomChild = SizedBox();
    if(widget.isExam){
      headerChildren = [
        Text(widget.parentTopic+' '+map.topicMap[widget.parentTopic][widget.topic],style: o.TextStyles.optikTitle,textAlign: TextAlign.center),
        Text(DateFormat('d MMMM yyyy EEEE','tr').format(widget.examDate.toLocal()),style: o.TextStyles.optikBody2Bold),
      ];}
    else{
      bottomChild = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Wrap(crossAxisAlignment: WrapCrossAlignment.center,
            children:[
            Text('Doğrularımı Gizle',style: o.TextStyles.optikBody1,),
            Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
                if(isSwitched){
                  for(int i = 0; i<visibilityList.length;i++){
                    if(correctnessList[i]){
                      visibilityList[i]=false;
                    }
                  }
                } else{
                  visibilityList = List<bool>.generate(questions.length, (int index) => true);
                }
              });
            },
            activeTrackColor: o.Colors.optikBlue, 
            activeColor: o.Colors.optikDarkBlue,
          ),
          ]
        )
      ]
      );
    }
    return Column(
      children:[
        Container(
          margin: EdgeInsets.only(top:8.0,left:8.0,right: 8.0),
          child:Column(
            children:headerChildren
          ),
        ),
        getOverallResultNumbers(stats),
        Divider(thickness: 1.0,height: 0.0,),
        Expanded(
          child:_buildList(context,questions,visibilityList)
        ),
        bottomChild,
        /* Text('Sıralamanız telafi sınavı katılımcıları ile birlikte değişebilir. Final sonuçlar '+
                DateFormat('dd MMMM yyyy','tr').format(widget.examDate)+
                ' günü açıklanacaktır.',
                style: o.TextStyles.optikBody2Bold.copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center) */
      ]
    );
  }
}


class QuestionExpandable extends StatelessWidget {
  final Question question;
  final bool isVisible;
  final ThemeData theme;
  final int index;
  final bool isExam;
  const QuestionExpandable({this.index,this.question, this.theme,this.isExam=true,this.isVisible=true});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    if(question.userChoice==null){
      question.userChoice = 'X';
    }
    String showThisAsTimePast ='';
    if(!isExam){
      DateTime actualNow = DateTime.now().add(Duration(milliseconds: timeOffset));
      int timePast = actualNow.difference(question.answerTime).inMinutes;
      if(timePast<=60){
        showThisAsTimePast = timePast.toString()+'dk';
      } else if(timePast<=1440){
        showThisAsTimePast = (timePast/60).round().toString()+'sa';
      } else if(timePast<=43200){
        showThisAsTimePast = (timePast/1440).round().toString()+'gün';
      } else {
        showThisAsTimePast = (timePast/43200).round().toString()+'ay';
      }
    }
    final _width = MediaQuery.of(context).size.width;
    final _userChoiceChild = Container(
      width: _width/18,
      height: _width/18,
      decoration: new BoxDecoration(
        color: question.userChoice =='X'?
          o.Colors.optikHistogram4: // if empty
            question.userChoice == question.correctChoice ? 
              o.Colors.optikHistogram9: // if correct
                o.Colors.optikHistogram1, // if incorrect
        shape: BoxShape.circle),
      child: Center(
        child:Text(
          question.userChoice=='X'?'':question.userChoice,
          style: o.TextStyles.optikBody1BoldWhite)),
    );
    final _correctChoiceChild = Container(
      width: _width/18,
      height: _width/18,
      decoration: new BoxDecoration(
        color: o.Colors.optikHistogram9,
        shape: BoxShape.circle),
      child: Center(
        child:Text(
          question.correctChoice,
          style: o.TextStyles.optikBody1BoldWhite)),
    );
    return Visibility(
      visible: isVisible,
      child:Theme(data: theme, child:Container(
      decoration: BoxDecoration(
        color: o.Colors.optikWhite,
        border: Border.all(width: 1.0,color: o.Colors.optikBorder),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(left:8.0,right:8.0,top:4.0,bottom: 4.0),
      child:ExpansionTile(
        key: PageStorageKey('examScrollable'+question.questionID),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            SizedBox(width:_width/18, child:Text(index.toString(),style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center)),
            SizedBox(width:_width*3/10, child:Text(question.subject??'Konu bulunamadı.',style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center)),
            _userChoiceChild,
            _correctChoiceChild,
            SizedBox(
              width:_width/18, 
              child:question.userChoice == 'X' ? 
                Icon(Icons.remove,color: o.Colors.optikHistogram4,): // if empty
                  question.userChoice == question.correctChoice ? 
                    Icon(Icons.check,color: o.Colors.optikHistogram10,): // if correct
                      Icon(Icons.close,color: o.Colors.optikHistogram1) // if false
            ),
            !isExam?SizedBox(
              width:_width/18, 
              child:AutoSizeText(showThisAsTimePast,maxLines: 1, minFontSize:6, style: TextStyle(fontSize: 10.0),textAlign: TextAlign.center)
            ):SizedBox(),
          ]
        ),
        children: [
            QuestionWidget(
              q: question,
              highlight: true,
            )
        ],
      )
    )));
  }
}