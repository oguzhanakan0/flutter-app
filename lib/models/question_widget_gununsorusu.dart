import 'package:flutter/material.dart';
import 'package:Optik/models/question_choices_gununsorusu.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/collections/question.dart';
import 'package:Optik/collections/globals.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_html/flutter_html.dart';

class QuestionWidgetGununSorusu extends StatefulWidget {
  final bool highlight;
  final bool active;
  final Question q;
  final String username;
  final String userID;
  QuestionWidgetGununSorusu({
    Key key,
    this.q,
    this.highlight=true,
    this.active=false,
    this.username,
    this.userID}) : super(key: key);
  @override
  State<QuestionWidgetGununSorusu> createState() => _QuestionWidgetGununSorusuState();
}

class _QuestionWidgetGununSorusuState extends State<QuestionWidgetGununSorusu> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    List<Widget> getChildren(){
      Map<String,Color> highlightMap = {
        'A':null,'B':null,'C':null,'D':null,'E':null,'X':null
      };
      if(widget.highlight){
        if(widget.q.userChoice == widget.q.correctChoice){
          highlightMap[widget.q.correctChoice]=o.Colors.optikGreen;
        }
        else{
          highlightMap[widget.q.correctChoice]=o.Colors.optikHistogram4;
          highlightMap[widget.q.userChoice]=o.Colors.optikHistogram1;
        }
      }
      List<Widget> _return = [];
      if(widget.q.header1!=null){
        /* _return.add(Text(widget.q.header1,style: o.TextStyles.optikBody1.copyWith(height: 1.5))); */
        _return.add(Html(
        data:widget.q.header1,
        customTextStyle: optikCustomTextStyle
        )
        );
      }
      if(widget.q.imageUrl!=null){
        _return.add(Center(
            child:Container(
            child:TransitionToImage(
              image: AdvancedNetworkImage(
                widget.q.imageUrl,
                retryLimit: 20,
                scale: 2,
                retryDurationFactor: 1,
                useDiskCache: true,
                cacheRule: CacheRule(maxAge: const Duration(days: 7)),
              ),
              fit: BoxFit.scaleDown,
            )
          )
        ));
      }
      if(widget.q.header2!=null){
        _return.add(Html(
          data:widget.q.header2,
          customTextStyle: optikCustomTextStyle
          )
        );
      }
      if(widget.q.body.indexOf('http')==-1){
        _return.add(Html(
          data:"<b><p>"+widget.q.body+"</p></b>",
          customTextStyle: optikCustomTextStyle
        ));
      } else {
        _return.add(Align(
        alignment: Alignment.centerLeft,
        child:Container(
        child:TransitionToImage(
          image: AdvancedNetworkImage(
            widget.q.body,
            retryLimit: 20,
            scale: 2,
            retryDurationFactor: 1,
            useDiskCache: true,
            cacheRule: CacheRule(maxAge: const Duration(days: 7)),
          ),
          fit: BoxFit.scaleDown,
        )))
        );
      }
      if(widget.q.footer!=null){
        _return.add(Html(
          data:widget.q.footer,
          customTextStyle: optikCustomTextStyle
          )
        );
      }
      _return.add(QuestionChoicesGununSorusu(
        q: widget.q,
        choices:widget.q.choices,
        isActive: widget.active,
        highlight: widget.highlight,
        highlightMap: highlightMap,
        username: widget.username,
        userID: widget.userID,));
      return _return;
    }

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