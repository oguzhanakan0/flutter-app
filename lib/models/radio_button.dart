/* import 'package:custom_radio/custom_radio.dart'; */
import 'package:Optik/collections/user.dart';
import 'package:Optik/models/custom_radio.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;

class OptikRadioButton extends StatefulWidget {
  final Map<String,String> choices;
  final String initialChoice;
  OptikRadioButton({
    Key key, 
    this.choices,
    this.initialChoice}) : super(key: key);
  @override
  State<OptikRadioButton> createState() => _OptikRadioButtonState();
}

class _OptikRadioButtonState extends State<OptikRadioButton> with SingleTickerProviderStateMixin {
  String choice;
  _OptikRadioButtonState() {
    simpleBuilder = (
      BuildContext context,
      List<double> animValues,
      Function updateState,
      String value) {
      final alpha = (animValues[0] * 255).toInt();
      final textColor = value==choice ? o.Colors.optikWhite:o.Colors.optikBlack;
      final User user = ModalRoute.of(context).settings.arguments;
      return GestureDetector(
        onTap:  () {
          setState(() {
            if(choice==value){
              choice=null;
              user.areaChoice = null;
            }
            else{
              choice = value;
              user.areaChoice = value;
            }
          });
        },
        child: Container(
          padding: EdgeInsets.all(4.0),
          margin: EdgeInsets.all(4.0),
          width: 80.0,
          height: 80.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: o.Colors.optikDarkBlue.withAlpha(alpha),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: o.Colors.optikDarkBlue.withAlpha(255 - alpha),
              width: 2.0,
            )
          ),
          child: 
              Container(
                child:Text(
                  widget.choices[value],
                  textAlign: TextAlign.center,
                  style: o.TextStyles.optikTitle.copyWith(color:textColor,height: 1.5))),              
            
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
    choice = widget.initialChoice == null ? null : widget.initialChoice;
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
      groupValue: choice,
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
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children:[for (var i in widget.choices.keys) createActiveChoice(i)]
    );
  }

}


