import 'package:Optik/models/question_widget_optikexam.dart';
import 'package:Optik/screens/exam_review_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/collections/topic_map.dart' as map;
import 'package:intl/intl.dart';

class ReviewWidget extends StatelessWidget{

  ListView _buildList(context) {
    final args = OptikExamReviewPage.of(context);
    final theme = Theme.of(context).copyWith(dividerColor: Colors.white.withAlpha(0));
    return ListView.builder(
      itemCount: args.qList.length,
      itemBuilder: (context, index) {
        return QuestionExpandable(index+1,theme);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = OptikExamReviewPage.of(context);
    initializeDateFormatting();
    return Column(
      children:[
        Container(
          margin: EdgeInsets.only(top:8.0),
          child:Column(
            children:[
              Text(args.exam.parentTopic+' '+map.topicMap[args.exam.parentTopic][args.exam.topic],style: o.TextStyles.optikTitle,textAlign: TextAlign.center,),
              Text(DateFormat('dd MMMM yyyy','tr').format(args.exam.examDate),style: o.TextStyles.optikBody2Bold)
            ]
          )
        ),
        Divider(thickness: 1.0,height: 8.0,),
        Expanded(
          child:_buildList(context)
        ),
        
      ]
    );
  }
}

class QuestionExpandable extends StatelessWidget {
  final int index;
  final ThemeData theme;
  const QuestionExpandable(this.index, this.theme);

  @override
  Widget build(BuildContext context) {
    final args = OptikExamReviewPage.of(context);
    if(args.qList[index].userChoice == null){args.qList[index].userChoice = 'X';}
    final _width = MediaQuery.of(context).size.width;
    return Theme(data: theme, child:Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0,color: o.Colors.optikBorder),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(left:8.0,right:8.0,top:4.0,bottom: 4.0),
      child:ExpansionTile(
        key: PageStorageKey('examScrollable'+args.qList[index].questionID),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            SizedBox(width:_width/18, child:Text(args.qList[index].order.toString(),style: o.TextStyles.optikBody1)),
            SizedBox(width:_width*2/5, child:Text(args.qList[index].subject,style: o.TextStyles.optikBody1)),
            Container(
              width: _width/18,
              height: _width/18,
              decoration: BoxDecoration(
                border: args.qList[index].userChoice == 'X' ? 
                  Border.all(width: 2.0,color: o.Colors.optikBlue):null,
                color: args.qList[index].userChoice == 'X' ?null:o.Colors.optikBlue ,
                shape: BoxShape.circle),
              child: Center(
                child:Text(
                  args.qList[index].userChoice == 'X' ? '': args.qList[index].userChoice,
                  style: o.TextStyles.optikBody1BoldWhite)),
            )
          ]),
        children: [
            QuestionWidgetOptikExam(
              index: index,
              active: true,
          )
        ],
      )
    ));
  }

}