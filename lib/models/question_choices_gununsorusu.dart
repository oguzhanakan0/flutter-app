import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:Optik/collections/question.dart';
import 'package:Optik/models/custom_radio.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/services/post_functions.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';

class QuestionChoicesGununSorusu extends StatefulWidget {
  final dynamic choices; // Map<String,String> orijinal formatı
  final Map<String,Color> highlightMap;
  final bool highlight;
  final bool isActive;
  final Question q;
  final String username;
  final String userID;
  QuestionChoicesGununSorusu({
    Key key, 
    this.choices, 
    this.isActive=true,
    this.highlight=false,
    this.q,
    this.highlightMap,
    this.username,
    this.userID}) : super(key: key);
  @override
  State<QuestionChoicesGununSorusu> createState() => _QuestionChoicesGununSorusuState();
}

class _QuestionChoicesGununSorusuState extends State<QuestionChoicesGununSorusu> with SingleTickerProviderStateMixin {
  String choice;
  IconData _lockIcon;
  bool _isTappable;

  _QuestionChoicesGununSorusuState() {
    simpleBuilder = (
      BuildContext context,
      List<double> animValues,
      Function updateState,
      String value) {
      choice = widget.q.userChoice;
      final alpha = (animValues[0] * 255).toInt();
      final textColor = value==choice ? o.Colors.optikWhite:o.Colors.optikBlack;
      return GestureDetector(
        onTap:  () {
          if(_isTappable){
            setState(() {
              if(choice==value){
                choice=null;
                widget.q.userChoice = 'X';
              }
              else{
                choice = value;
                widget.q.userChoice = value;
                }
            });
          }
        },
        child: Container(
          padding: EdgeInsets.all(4.0),
          margin: EdgeInsets.symmetric(vertical: 2.0),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: !_isTappable?o.Colors.optikGray.withAlpha(alpha):o.Colors.optikBlue.withAlpha(alpha),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: o.Colors.optikBorder.withAlpha(255 - alpha),
              width: 1.0,
            )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
              value == 'X' ? [Expanded(
                child:Text(widget.choices[value],
                  style: o.TextStyles.optikBody1.copyWith(color:textColor,height: 1.5),
                  textAlign: TextAlign.center,
                  )
                )]
              :[
              Container(
                width: 25.0,
                child:Text(value+')',style: o.TextStyles.optikBody1Bold.copyWith(color:textColor,height: 1.5))),
              Expanded(
                child:widget.choices[value].indexOf('http')==-1?
                Html(
                  data:widget.choices[value],
                  customTextStyle: (dom.Node node, TextStyle baseStyle){ 
                      if (node is dom.Element) {
                        switch (node.localName) {
                          case "sub":
                            return baseStyle.merge(TextStyle(fontSize: 9,height: 1.5));
                        }
                      }
                      return baseStyle.merge(TextStyle(fontSize: 14,height: 1.5,color: textColor));
                    }
                ):
                UnconstrainedBox(
                  child:TransitionToImage(
                    image: AdvancedNetworkImage(
                      widget.choices[value],
                      useDiskCache: true,
                      scale: 2,
                      retryLimit: 20,
                      retryDurationFactor: 1,
                      cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                    ),
                    fit: BoxFit.none,
                  )
                )
                )
              ]
            )
          )
        )
      ;
    };
  }

  RadioBuilder<String, double> simpleBuilder;
  AnimationController _controller;
  bool loading;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this
    );
    _controller.addListener(() {
      setState(() {});
    });
    _lockIcon = widget.q.isTappable?Icons.lock_open:Icons.lock_outline;
    _isTappable = widget.q.isTappable;
    loading = false;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  CustomRadio<String,double> createActiveChoice(String thisChoice) {
    return CustomRadio<String, double>(
      value: thisChoice,
      groupValue: widget.q.userChoice,
      duration: Duration(milliseconds: 300),
      animsBuilder: (AnimationController controller) => [
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut
        ),
      ],
      builder: simpleBuilder
    );
  }

  Container createDisabledChoice(String thisChoice){
    Color c = widget.highlightMap[thisChoice]==null?
      o.Colors.optikWhite:
        widget.highlightMap[thisChoice];
    dynamic border = c==o.Colors.optikWhite?
      Border.all(color: o.Colors.optikBorder,width: 1.0):
        null;
    dynamic textColor = c==o.Colors.optikWhite?
      o.Colors.optikBlack:
        o.Colors.optikWhite;
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 2.0),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: c,
        borderRadius: BorderRadius.all(Radius.circular(16.0 )),
        border: border
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Container(
            width: 20.0,
            child:Text(
              thisChoice+')',style: o.TextStyles.optikBody1.copyWith(color: textColor,height: 1.5))),
          Expanded(
            child:widget.choices[thisChoice].indexOf('http')==-1?
            Html(
              data:widget.choices[thisChoice],
              /* customTextStyle: optikCustomTextStyle */
              customTextStyle: (dom.Node node, TextStyle baseStyle){ 
                if (node is dom.Element) {
                  switch (node.localName) {
                    case "sub":
                      return baseStyle.merge(TextStyle(fontSize: 9,height: 1.5));
                  }
                }
                return baseStyle.merge(TextStyle(fontSize: 14,height: 1.5,color: textColor));
              }
            ):UnconstrainedBox(
              child:TransitionToImage(
                image: AdvancedNetworkImage(
                  widget.choices[thisChoice],
                  useDiskCache: true,
                  scale: 2,
                  retryLimit: 20,
                  retryDurationFactor: 1,
                  cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                ),
                fit: BoxFit.none,
              )
            )
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    dynamic lst = widget.choices.keys.toList()..sort();
    return 
      Wrap(children:[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.isActive ? 
            [for (var i in lst) createActiveChoice(i)]:
              [for (var i in lst) createDisabledChoice(i)]),
        widget.isActive ? 
        Center(child:
          Column(children:[
            IconButton(
              icon: Icon(loading?Icons.compare_arrows:_lockIcon,color: o.Colors.optikBlack,),
              onPressed: !_isTappable? (){}: () async {
                setState(() {
                  loading = true;
                  _isTappable = false;
                  widget.q.isTappable = false;
                });
                await Future.delayed(Duration(seconds: 1)); // [DELETE LATER]
                bool res = await sendAnswer( // [POST FUNCTION]
                  userID:widget.userID,
                  answer:widget.q.userChoice,
                  questionID:widget.q.questionID,
                  isExam: false);
                res?
                setState(() {
                  _lockIcon = Icons.lock_outline;
                  loading = false;
                }):
                setState(() {
                  _isTappable = true;
                  widget.q.isTappable = true;
                  loading = false;
                })
                ;
                showSimpleNotification(
                Text(
                  res?
                  """Günün sorusunu kilitledin! Doğru cevabı bugün saat """+DateFormat('H:mm','tr').format(widget.q.deadline)+"""'de görebilirsin. Ayrıca, Instagram sayfamızdaki (@optikapp) günün sorusu gönderimize cevabını açıklayan bir yorum yazarak hediye çekilişine katılabilirsin!""":
                  """Bir hata oluştu. Lütfen cevabınızı tekrar göndermeyi deneyin."""
                ),
                background: o.Colors.optikBlue,
                autoDismiss:false,
                trailing: Builder(builder: (context) {
                  return FlatButton(
                      textColor: Colors.yellow,
                      onPressed: () {
                        OverlaySupportEntry.of(context).dismiss();
                      },
                      child: Text('Tamam'));
                  }));
                }
              ),
              !_isTappable?Text("Günün sorusunu cevapladın. Doğru cevabı bugün saat "+DateFormat('H:mm','tr').format(widget.q.deadline)+"'de görebilirsin!",textAlign: TextAlign.center,):SizedBox()
            ]
          )
        ):
        Center(child: Text(
          widget.q.userChoice=='X'?
            "Bugünün sorusunu boş bıraktın. Yarın yine bekleriz!":
              widget.q.userChoice==widget.q.correctChoice?
                "Tebrikler! Bugünün sorusunu doğru yanıtladın. Yarın yine bekleriz!":
                  "Maalesef bugünün sorusunu yanlış yanıtladın. Yarın yine bekleriz!",
          textAlign: TextAlign.center,
          )
        )
      ]
    );
  }

}


