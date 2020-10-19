import 'package:Optik/collections/question.dart';
import 'package:Optik/models/custom_radio.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';

class QuestionChoices extends StatefulWidget {
  final dynamic choices;
  final Map<String,Color> highlightMap;
  final bool highlight;
  final bool isActive;
  final Question q;
  QuestionChoices({
    Key key, 
    this.choices, 
    this.isActive=true, 
    this.highlight=false,
    this.q,
    this.highlightMap}) : super(key: key);
  @override
  State<QuestionChoices> createState() => _QuestionChoicesState();
}

class _QuestionChoicesState extends State<QuestionChoices> with SingleTickerProviderStateMixin {
  String choice;
  _QuestionChoicesState() {
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
          thisChoice == 'X' ? [Expanded(
                child:widget.choices[thisChoice].indexOf('http')==-1?
                Html(
                    data:widget.choices[thisChoice],
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
                )]
              :[
              Container(
                width: 25.0,
                child:Text(thisChoice+')',style: o.TextStyles.optikBody1Bold.copyWith(color:textColor,height: 1.5))),
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
                  },
                ):
                UnconstrainedBox(
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
    List<Widget> _children;
    dynamic lst = widget.choices.keys.toList()..sort();
    if(widget.isActive){ 
      _children = [for (var i in lst) createActiveChoice(i)];
    } else if(widget.highlight){
      _children = [for (var i in lst) createDisabledChoice(i)];
    }      
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:_children
    );
  }

}


