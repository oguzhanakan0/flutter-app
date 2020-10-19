import 'package:flutter/material.dart';
import 'package:Optik/models/deneme_sorulari_topic_button.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/deneme_sorulari_select_parenttopic_page.dart';

class DenemeSorulariSelectTopicPage extends StatelessWidget {
  const DenemeSorulariSelectTopicPage();

  @override
  Widget build(BuildContext context) {
    final DenemeSorulariInherited args = ModalRoute.of(context).settings.arguments;
    var _buttonWidth = MediaQuery.of(context).size.width * 0.4;
    return /* DenemeSorulariInherited(
      pageArgs: args.pageArgs,
      questions: null,
      child:  */
      Scaffold(
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
              style: o.TextStyles.optikTitle),
            SizedBox(height: 40.0),
            Wrap(
              children: [for (var i in args.pageArgs.topicMap[args.pageArgs.parentTopicChoice].keys) TopicButton(
                text: i,
                width: _buttonWidth,
                color: args.pageArgs.colorMap[args.pageArgs.topicMap[args.pageArgs.parentTopicChoice][i]],
                onPressed: (){
                  args.pageArgs.topicChoice = i;
                  if(args.pageArgs.subTopicMap[i]==null){
                    Navigator.pushNamed(
                      context,
                      '/deneme_sorulari_run',
                      arguments: args
                    );
                  } else{
                    Navigator.pushNamed(
                      context,
                      '/deneme_sorulari_select_subtopic',
                      arguments: args
                    );
                  }}
                )
              ]
            ),
          ]
        )))
      /* ) */
    );
  }
}