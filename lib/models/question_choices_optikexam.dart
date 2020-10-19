import 'package:Optik/models/custom_radio.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/exam_review_page.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';

class QuestionChoicesOptikExam extends StatefulWidget {
  /* final Map<String,String> choices; */
  /* final Map<String,Color> highlightMap; */
  final bool highlight;
  final bool isActive;
  final int index;
  /* final Question q; */
  QuestionChoicesOptikExam({
    Key key, 
    /* this.choices,  */
    this.isActive=true, 
    this.highlight=false,
    this.index
    /* this.q, */
    /* this.highlightMap */}) : super(key: key);
  @override
  State<QuestionChoicesOptikExam> createState() => _QuestionChoicesOptikExamState();
}

class _QuestionChoicesOptikExamState extends State<QuestionChoicesOptikExam> with SingleTickerProviderStateMixin {
  String choice;
  _QuestionChoicesOptikExamState() {
    simpleBuilder = (
      BuildContext context,
      List<double> animValues,
      Function updateState,
      String value) {
      final args = OptikExamReviewPage.of(context);
      /* print(args.exam.nQuestions); */
      choice = args.qList[widget.index].userChoice;
      final alpha = (animValues[0] * 255).toInt();
      final textColor = value==choice ? o.Colors.optikWhite:o.Colors.optikBlack;
      return GestureDetector(
        onTap:  () {
          setState(() {
            if(choice==value){
              choice=null;
              args.setState((){
                args.qList[widget.index].userChoice = 'X';
              });
            }
            else{
              choice = value;
              args.setState((){
                args.qList[widget.index].userChoice = value;
              });
              }
          });
        },
        child: Container(
          padding: EdgeInsets.all(4.0),
          margin: EdgeInsets.symmetric(vertical: 2.0),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor.withAlpha(alpha),
            borderRadius: BorderRadius.all(Radius.circular(8.0 )),
            border: Border.all(
              color: o.Colors.optikBorder.withAlpha(255 - alpha),
              width: 1.0,
            )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
              value == 'X' ? [Expanded(
                child:Text(args.qList[widget.index].choices[value],
                  style: o.TextStyles.optikBody1.copyWith(color:textColor,height: 1.5),
                  textAlign: TextAlign.center,
                  )
                )]
              :[
              Container(
                width: 25.0,
                child:Text(value+')',style: o.TextStyles.optikBody1Bold.copyWith(color:textColor,height: 1.5))),
              Expanded(
                child:args.qList[widget.index].choices[value].indexOf('http')==-1?
                Html(
                  data:args.qList[widget.index].choices[value],
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
                      args.qList[widget.index].choices[value],
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
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  CustomRadio<String,double> createActiveChoice(String thisChoice, int index) {
    final args = OptikExamReviewPage.of(context);
    return CustomRadio<String, double>(
      value: thisChoice,
      groupValue: args.qList[widget.index].userChoice,
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

  @override
  Widget build(BuildContext context) {
    final args = OptikExamReviewPage.of(context);
    dynamic lst = args.qList[widget.index].choices.keys.toList()..sort();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[for (var i in lst) createActiveChoice(i, widget.index)]
    );
  }

}


