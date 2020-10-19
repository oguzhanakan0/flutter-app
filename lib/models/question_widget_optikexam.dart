import 'package:flutter/material.dart';
import 'package:Optik/models/question_choices_optikexam.dart';
import 'package:Optik/screens/exam_review_page.dart';
import 'package:Optik/collections/globals.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_html/flutter_html.dart';

class QuestionWidgetOptikExam extends StatelessWidget {
  final bool highlight;
  final bool active;
  final int index;
  QuestionWidgetOptikExam({
    Key key,
    this.index,
    this.highlight=true,
    this.active=false}) : super(key: key);

  List<Widget> getChildren(BuildContext context, int index){
    final args = OptikExamReviewPage.of(context);
    List<Widget> _return = [];
    if(args.qList[index].header1!=null){
      _return.add(Html(
        data:args.qList[index].header1,
        customTextStyle: optikCustomTextStyle
      )
      );
    }
    if(args.qList[index].imageUrl!=null){
      _return.add(
        Center(
          child:Container(
            child:TransitionToImage(
              image: AdvancedNetworkImage(
                args.qList[index].imageUrl,
                retryLimit: 20,
                retryDurationFactor: 1,
                scale: 2,
                useDiskCache: true,
                cacheRule: CacheRule(maxAge: const Duration(days: 7)),
              ),
              fit: BoxFit.scaleDown,
            )
          )
        )
      );
    }
    if(args.qList[index].header2!=null){
      _return.add(Html(
        data:args.qList[index].header2,
        customTextStyle: optikCustomTextStyle
        )
      );
    }
    if(args.qList[index].body.indexOf('http')==-1){
      _return.add(Html(
        data:"<b><p>"+args.qList[index].body+"</p></b>",
        customTextStyle: optikCustomTextStyle
      ));
    } else {
      _return.add(Align(
        alignment: Alignment.centerLeft,
        child:Container(
        child:TransitionToImage(
        image: AdvancedNetworkImage(
          args.qList[index].body,
          retryLimit: 20,
          scale: 2,
          retryDurationFactor: 1,
          useDiskCache: true,
          cacheRule: CacheRule(maxAge: const Duration(days: 7)),
        ),
        fit: BoxFit.scaleDown,
        ))
      )
      );
    }
    if(args.qList[index].footer!=null){
      _return.add(Html(
        data:args.qList[index].footer,
        customTextStyle: optikCustomTextStyle
        )
      );
    }
    _return.add(QuestionChoicesOptikExam(
      index: index,
      isActive: active,
      highlight: highlight));
    return _return;
  }

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:getChildren(context,index)
      ),
    );
  }

}