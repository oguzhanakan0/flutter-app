import 'dart:math';

import 'package:Optik/collections/globals.dart';
import 'package:Optik/collections/topic_map.dart' as map;
import 'package:flutter/material.dart';
import 'package:Optik/models/deneme_sorulari_topic_button.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/exam_lobby_page.dart';
import 'package:overlay_support/overlay_support.dart';

class OptikExamBeforeResultsPage extends StatelessWidget {
  const OptikExamBeforeResultsPage();

  @override
  Widget build(BuildContext context) {
    final OptikExamInherited args = ModalRoute.of(context).settings.arguments;
    var _buttonWidth = MediaQuery.of(context).size.width * 0.4;
    return WillPopScope(
      onWillPop: (){
        showSimpleNotification(
          Text("Sınavdan şu an çıkış yapamazsınız."),
          background: map.colorMap[args.exam.topic],
          autoDismiss: true,
          trailing: Builder(builder: (context) {
            return FlatButton(
                textColor: Colors.yellow,
                onPressed: () {
                  OverlaySupportEntry.of(context).dismiss();
                },
                child: Text('Tamam'));
          }));
          return null;
      },
      child:Scaffold(
        backgroundColor: map.colorMap[args.exam.topic],
        body:Center(child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height: 60, child:Image(image: AssetImage('assets/images/logo_negative.png'))),
            SizedBox(height: 40.0),
            Text(args.parentExam.parentExamName,style: o.TextStyles.optikBody1White,textAlign: TextAlign.center),
            Text(args.exam.parentTopic,style: o.TextStyles.optikWhiteTitle,textAlign: TextAlign.center),
            Text(map.topicMap[args.exam.parentTopic][args.exam.topic],style: o.TextStyles.optikWhiteTitle,textAlign: TextAlign.center),
            SizedBox(height: 40.0),
            Text('Tebrikler, sınav sona erdi.\nSonuçları görmek için aşağıdaki butona tıkla!',
              style: o.TextStyles.optikWhiteTitle,textAlign: TextAlign.center),
            SizedBox(height: 40.0),
            TopicButton(
              text: 'Sonuçları Gör',
              color: o.Colors.optikDarkBlue,
              onPressed: (){
                if(DateTime.now().add(Duration(milliseconds: timeOffset)).
                    isAfter(args.examSchedule[args.qList.keys.reduce(max)+1]['eventEndTime'].add(Duration(seconds: RESULT_BUFFER)))){
                  Navigator.pushReplacementNamed(
                    context,
                    '/exam_results_page',
                    arguments: args);
                  } else {
                    showSimpleNotification(Text('Sınav herkes için henüz bitmedi. Sonuçları '+
                      (args.examSchedule[args.qList.keys.reduce(max)+1]['eventEndTime'].add(Duration(seconds: RESULT_BUFFER)))
                        .difference(DateTime.now().add(Duration(milliseconds: timeOffset))).inSeconds.toString()+
                      ' saniye sonra görebilirsin!'
                    ));
                  }
                },
              width:_buttonWidth)
            ]
          )
        )
      )
    );
  }
}