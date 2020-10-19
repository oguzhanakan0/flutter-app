import 'package:flutter/material.dart';
import 'package:Optik/models/question_choices_denemesorulari.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/collections/question.dart';
import 'package:Optik/collections/globals.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_html/flutter_html.dart';

class QuestionWidgetDenemeSorulari extends StatelessWidget {
  final bool highlight;
  final bool active;
  final Question q;
  const QuestionWidgetDenemeSorulari({
    this.q,
    this.highlight=true,
    this.active=false});

  List<Widget> getChildren(){
    Map<String,Color> highlightMap = {
      'A':null,'B':null,'C':null,'D':null,'E':null
    };
    if(highlight){
      if(q.userChoice == q.correctChoice){
        highlightMap[q.correctChoice]=o.Colors.optikGreen;
      }
      else{
        if(q.userChoice == 'X'){
          highlightMap[q.correctChoice]=o.Colors.optikHistogram4;
        } else {
          highlightMap[q.correctChoice]=o.Colors.optikHistogram9;
          highlightMap[q.userChoice]=o.Colors.optikHistogram1;
        }
      }
    }
    List<Widget> _return = [];
    if(q.header1!=null){
      _return.add(Html(
        data:q.header1,
        customTextStyle: optikCustomTextStyle
      )
      );
    }
    if(q.imageUrl!=null){
      _return.add(Center(
        child:Container(
        child:TransitionToImage(
          image: AdvancedNetworkImage(
            q.imageUrl,
            useDiskCache: true,
            retryLimit: 20,
            scale: 2,
            retryDurationFactor: 1,
            cacheRule: CacheRule(maxAge: const Duration(days: 7)),
          ),
          fit: BoxFit.scaleDown,
        )))
      );
    }
    if(q.header2!=null){
      
      _return.add(Html(
        data:q.header2,
        customTextStyle: optikCustomTextStyle
        )
      );
    }
    if(q.body.indexOf('http')==-1){
      _return.add(Html(
        data:"<b><p>"+q.body+"</p></b>",
        customTextStyle: optikCustomTextStyle,
      ));
    } else {
      _return.add(Center(
        child:Container(
        constraints: BoxConstraints(maxHeight: 100.0),
        child:TransitionToImage(
          image: AdvancedNetworkImage(
            q.body,
            retryLimit: 20,
            scale: 2,
            retryDurationFactor: 1,
            useDiskCache: true,
            cacheRule: CacheRule(maxAge: const Duration(days: 7)),
          ),
          fit: BoxFit.scaleDown,
        )
      )));
    }
    if(q.footer!=null){
      _return.add(Html(
        data:q.footer,
        customTextStyle: optikCustomTextStyle
        )
      );
    }
    _return.add(QuestionChoicesDenemeSorulari(
      choices:q.choices,
      isActive: active,
      highlight: highlight,
      highlightMap: highlightMap));
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
        children:getChildren()
      ),
    );
  }

}