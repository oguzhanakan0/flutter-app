import 'package:flutter/material.dart';
import 'package:Optik/models/deneme_sorulari_topic_button.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/deneme_sorulari_select_parenttopic_page.dart';

class DenemeSorulariSessionEndPage extends StatelessWidget {
  const DenemeSorulariSessionEndPage();

  Color getContainerColorAccordingToNCorrect(int nCorrect, int qCount){
    int _trunc = qCount == 0 ? 0 : (nCorrect/qCount*10).truncate();
    switch(_trunc){
      case 0: return o.Colors.optikHistogram1;
      case 1: return o.Colors.optikHistogram1;
      case 2: return o.Colors.optikHistogram2;
      case 3: return o.Colors.optikHistogram3;
      case 4: return o.Colors.optikHistogram4;
      case 5: return o.Colors.optikHistogram5;
      case 6: return o.Colors.optikHistogram6;
      case 7: return o.Colors.optikHistogram7;
      case 8: return o.Colors.optikHistogram8;
      case 9: return o.Colors.optikHistogram9;
      case 10: return o.Colors.optikHistogram10;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DenemeSorulariInherited args = ModalRoute.of(context).settings.arguments;
    print('deneme_sorulari_session_end_page.dart running...');
    print(args.pageArgs.parentTopicChoice);
    print(args.pageArgs.topicMap[args.pageArgs.parentTopicChoice][args.pageArgs.topicChoice]);
    print(args.pageArgs.subTopicChoice);
    double _width = MediaQuery.of(context).size.width;
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
        title: Text("Seans Bitti",
          style:o.TextStyles.optikBoldTitle)
      ),
      body:Center(
        child:ListView(
          children:[Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 60, child:Image(image: AssetImage('assets/images/logo.png'))),
              Container(
                margin: EdgeInsets.all(32.0),
                child:Column(
                  children:[
                    Text(args.pageArgs.parentTopicChoice,style: o.TextStyles.optikTitle,textAlign: TextAlign.center),
                    Text(args.pageArgs.subTopicChoice==null?args.pageArgs.topicChoice:args.pageArgs.subTopicChoice,style: o.TextStyles.optikSubHead,textAlign: TextAlign.center),
                    Divider(),
                    Text('Özet',style: o.TextStyles.optikBoldTitle,),
                    Container(
                      decoration: BoxDecoration(
                        color: getContainerColorAccordingToNCorrect(args.pageArgs.nCorrect,args.pageArgs.qCount),
                        border: Border.all(width: 1.0,color: o.Colors.optikBorder),
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(vertical:8.0),
                      width:_width*2/3,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Doğru',style: o.TextStyles.optikTitle.copyWith(color: o.Colors.optikWhite)),
                              Text(args.pageArgs.nCorrect.toString(),style: o.TextStyles.optikBoldTitle.copyWith(color: o.Colors.optikWhite)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Yanlış',style: o.TextStyles.optikTitle.copyWith(color: o.Colors.optikWhite)),
                              Text(args.pageArgs.nIncorrect.toString(),style: o.TextStyles.optikBoldTitle.copyWith(color: o.Colors.optikWhite)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Boş',style: o.TextStyles.optikTitle.copyWith(color: o.Colors.optikWhite)),
                              Text(args.pageArgs.nEmpty.toString(),style: o.TextStyles.optikBoldTitle.copyWith(color: o.Colors.optikWhite)),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Toplam',style: o.TextStyles.optikTitle.copyWith(color: o.Colors.optikWhite)),
                              Text(args.pageArgs.qCount.toString(),style: o.TextStyles.optikBoldTitle.copyWith(color:o.Colors.optikWhite)),
                            ],
                          )
                        ]
                      )
                    ),
                    Text('Unutma! Çözdüğün tüm deneme sorularını profil sayfanda tekrar inceleyebilirsin.',
                      style: o.TextStyles.optikBody1,
                      textAlign: TextAlign.center,),
                    TopicButton(
                      text: 'Anasayfa',
                      color: o.Colors.optikBlue,
                      width: _width/3,
                      onPressed: (){
                        Navigator.pop(context);
                      }
                    )
                  ]
                )
              ),
            ]
          )
        ]
      )
    )
    );
  }
}
