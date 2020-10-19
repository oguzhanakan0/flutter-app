import 'package:flutter/material.dart';
import 'package:Optik/models/deneme_sorulari_topic_button.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/deneme_sorulari_select_parenttopic_page.dart';

class DenemeSorulariRunPage extends StatelessWidget {
  const DenemeSorulariRunPage();

  @override
  Widget build(BuildContext context) {
    final DenemeSorulariInherited args = ModalRoute.of(context).settings.arguments;
    var _buttonWidth = MediaQuery.of(context).size.width * 0.4;
    return Scaffold(
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
        title: Text("Deneme Soruları",
          style:o.TextStyles.optikBoldTitle)
      ),
      body:Center(child:SingleChildScrollView(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(height: 60, child:Image(image: AssetImage('assets/images/logo.png'))),
          Text('Deneme Soruları',
            style: o.TextStyles.optikTitle,textAlign: TextAlign.center),
          SizedBox(height: 40.0),
          Text(args.pageArgs.parentTopicChoice,style: o.TextStyles.optikTitle,textAlign: TextAlign.center),
          Text(args.pageArgs.topicChoice,style: o.TextStyles.optikHeader,textAlign: TextAlign.center),
          Text(args.pageArgs.subTopicChoice==null?'':args.pageArgs.subTopicChoice,style: o.TextStyles.optikSubHead,textAlign: TextAlign.center),
          TopicButton(
            text: 'Başla',
            color: args.pageArgs.colorMap[args.pageArgs.topicMap[args.pageArgs.parentTopicChoice][args.pageArgs.topicChoice]],
            onPressed: (){
              // FIND OUT SUBTOPIC CODE: IGRENC BIR KOD
              args.pageArgs.subTopicMap[args.pageArgs.topicChoice]==null?
                args.pageArgs.subTopicCode = args.pageArgs.topicMap[args.pageArgs.parentTopicChoice][args.pageArgs.topicChoice]:
                  args.pageArgs.subTopicCode = args.pageArgs.subTopicMap[args.pageArgs.topicChoice][args.pageArgs.subTopicChoice];
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/deneme_sorulari_question',
                ModalRoute.withName('/home'),
                arguments: args);
              },
            width:_buttonWidth)
        ]
      )))
    );
  }
}