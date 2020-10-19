import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/question_widget_denemesorulari.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/widgets/signup_sonraki_button.dart';

import 'deneme_sorulari_select_parenttopic_page.dart';

class DenemeSorulariAnswerPage extends StatelessWidget {
  const DenemeSorulariAnswerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DenemeSorulariInherited args = ModalRoute.of(context).settings.arguments;
    final nav = Navigator.of(context);
    Center txt;
    if(args.questions[args.pageArgs.qCount].userChoice=='X'){
      txt = Center(child:Text('Boş bıraktın', style: o.TextStyles.optikBoldTitle.copyWith(color: o.Colors.optikHistogram4)));
    } else if(args.questions[args.pageArgs.qCount].userChoice==args.questions[args.pageArgs.qCount].correctChoice){
      txt = Center(child:Text('Doğru!', style: o.TextStyles.optikBoldTitle.copyWith(color: o.Colors.optikHistogram10)));
    } else {
      txt = Center(child:Text('Yanlış, ama moral bozmak yok!', style: o.TextStyles.optikBoldTitle.copyWith(color: o.Colors.optikHistogram1)));
    }
    return WillPopScope(
      onWillPop: (){
        showDialog (
          context: context,
          builder: (BuildContext context) {
            return AlertDialog (
              title: Text("Uyarı",style: o.TextStyles.optikBody1Bold,),
              content: Wrap(children:[
                Text("Deneme Soruları seansını bitirmek istiyor musunuz?",style: o.TextStyles.optikTitle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        nav.pushReplacementNamed(
                          '/deneme_sorulari_session_end',
                          arguments:args
                        );
                      },
                      child: Text('Bitir',style: o.TextStyles.optikBody1Bold)
                    ),
                    GestureDetector(
                    onTap: (){Navigator.pop(context);},
                    child: Container(
                      decoration: BoxDecoration(
                        color: o.Colors.optikBlue,
                        borderRadius: BorderRadius.circular(4.0)),
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.only(left:8.0),
                      child:Text('Devam Et',
                      style: o.TextStyles.optikBody1BoldWhite,))
                  )
                ])
              ])
            );
          }
        );
        return null;
      },
      child:Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children:[
            SizedBox(
              width:MediaQuery.of(context).size.width*2/3,
              child:AutoSizeText(
                args.pageArgs.parentTopicChoice+' '+args.pageArgs.topicChoice,
                style: o.TextStyles.optikWhiteTitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis
              )
            ),
            /* Center(child:Text(args.pageArgs.parentTopicChoice+' '+args.pageArgs.topicChoice,style: o.TextStyles.optikWhiteTitle,)), */
            Center(child:Text(args.pageArgs.subTopicChoice==null?
              "":
              args.pageArgs.subTopicChoice,style: o.TextStyles.optikBody1White,))
          ]
        ),
        leading: GestureDetector(
          onTap: (){
            Navigator.pushReplacementNamed(
              context,
              '/deneme_sorulari_session_end',
              arguments:args
            );
          },
          child:Center(child:Text('Bitir',style: o.TextStyles.optikBody1BoldWhite,)),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/deneme_sorulari_question',
                ModalRoute.withName('/home'),
                arguments: args);
              }
          )
        ],
        backgroundColor: args.pageArgs.colorMap[args.pageArgs.topicMap[args.pageArgs.parentTopicChoice][args.pageArgs.topicChoice]],
      ),
      body: ListView(children:[
        txt,
        Divider(),
        QuestionWidgetDenemeSorulari(
          q: args.questions[args.pageArgs.qCount],
          highlight: true
          ),
        SizedBox(height: 500)
        ]
      ),
      bottomSheet: SignupSonrakiButton(
        onPressed: (){
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/deneme_sorulari_question',
                ModalRoute.withName('/home'),
                arguments: args);
              },
        color: o.Colors.optikGray,
        title: 'Sıradaki Soru',
      ),
    ));
  }
}