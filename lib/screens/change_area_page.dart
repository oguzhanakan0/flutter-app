import 'package:Optik/services/post_functions.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/models/custom_radio.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:Optik/widgets/signup_sonraki_button.dart';
import 'package:Optik/models/theme.dart' as o;


class ChangeAreaPage extends StatefulWidget {

  final state = _ChangeAreaPageState();
  final Map<String,String> choices = {
    'EA':'Eşit Ağırlık',
    'SAY':'Sayısal',
    'SÖZ':'Sözel',
    'TYT':'TYT'};

  ChangeAreaPage({Key key}) : super(key: key);
  @override
  _ChangeAreaPageState createState() => state;
}

class _ChangeAreaPageState extends State<ChangeAreaPage> with SingleTickerProviderStateMixin {
  String choice;
  bool sending;
  _ChangeAreaPageState() {
    simpleBuilder = (
      BuildContext context,
      List<double> animValues,
      Function updateState,
      String value) {
      final alpha = (animValues[0] * 255).toInt();
      final textColor = value==choice ? o.Colors.optikWhite:o.Colors.optikBlack;
      /* final User user = ModalRoute.of(context).settings.arguments; */
      return GestureDetector(
        onTap:  () {
          setState(() {
            if(choice==value){
              choice=null;
            }
            else{
              choice = value;
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
    _controller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this
    );
    _controller.addListener(() {
      setState(() {});
    });
    sending = false;
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
    User user = ModalRoute.of(context).settings.arguments;
    return Stack(children:[Scaffold(
        appBar:PreferredSize(preferredSize:Size.fromHeight(50.0),child:AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios,color: o.Colors.optikBlack,),
              onPressed: () {Navigator.of(context).pop();},
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title:Text('Alan Tercihini Değiştir',style: o.TextStyles.optikTitle),
        backgroundColor: o.Colors.optikWhite,)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal:12.0,vertical: 12.0),
          child:ListView(
          children:
            <Widget>[
              Text("YKS'ye hangi puan türünde gireceksin?",
                style: o.TextStyles.optikTitle,
                textAlign: TextAlign.center,),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children:[for (var i in widget.choices.keys) createActiveChoice(i)]
            )
          ]
        )
      ),
      bottomSheet:SignupSonrakiButton(
        title: 'Kaydet',
        color: o.Colors.optikBlue,
        onPressed: sending?(){}:() async {
          if(choice != null&&mounted) {
            setState(() {
              sending = true;
            });
            bool res= await sendChangeAreaInfo(userID: user.googleUserID, areaChoice: choice); // [POST FUNCTION]
            if(mounted){
                setState(() {
                sending = false;
              });
            }
            if(res){
              user.areaChoice = choice;
              Navigator.pop(context);  
            }
          }
          else {
            showDialog (
              context: context,
              builder: (BuildContext context) {
                return AlertDialog (
                  title: Text("Uyarı",style: o.TextStyles.optikBody1Bold,),
                  content: Text("Bir puan türü seçmelisiniz",style: o.TextStyles.optikTitle,)
                );
              }
            );
          }
        }
        )
    ),
    sending?Loading(negative: true,transparent: true,opacity: 0.5):SizedBox()
    ]
    );
  }
}