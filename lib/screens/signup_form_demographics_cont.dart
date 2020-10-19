import 'package:flutter/material.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/models/radio_button.dart';
import 'package:Optik/widgets/signup_appbar.dart';
import 'package:Optik/widgets/signup_sonraki_button.dart';
import 'package:Optik/models/theme.dart' as o;

class SignupFormDemographicsContd extends StatefulWidget {
  final User user;
  final state = _SignupFormDemographicsContdState();

  SignupFormDemographicsContd({Key key, this.user}) : super(key: key);
  @override
  _SignupFormDemographicsContdState createState() => state;
}

class _SignupFormDemographicsContdState extends State<SignupFormDemographicsContd> {
  final form = GlobalKey<FormState>();
  bool loading;
  User user;


  @override
  void initState(){
    super.initState();
    loading=false;
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    user = ModalRoute.of(context).settings.arguments;
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }

  Widget checkbox(String title, bool _value, double width) {
    double vertMargin = width/12;
    double buttonWidth = (width-24-2*vertMargin)/3;
    return Container(
      margin: EdgeInsets.symmetric(vertical:vertMargin/4),
      child:InkWell(
        onTap: () {
          setState(() {
            _value = !_value;
            majorsMap[title] = _value;
          });
        },
        child: _value
          ? Container(
          padding: EdgeInsets.all(2.0),
          width: buttonWidth,
          height: buttonWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0 )),
            color: o.Colors.optikBlue),
            child: Center(child:Text(title,
              style: o.TextStyles.optikBody1White,
              textAlign: TextAlign.center)
          ))
          : Container(
          padding: EdgeInsets.all(2.0),
          width: buttonWidth,
          height: buttonWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: o.Colors.optikContainerBg),
            child: Center(child:Text(title,
              style: o.TextStyles.optikBody1,
              textAlign: TextAlign.center,
            )
          ))
      ));
  }
  Map<String,bool> majorsMap = {
      'Diş Hekimliği':false,
      'Eczacılık':false,
      'Eğitim Fakültesi':false,
      'Fen Fakültesi':false,
      'Hemşirelik':false,
      'Hukuk':false,
      'İktisat':false,
      'İlahiyat Fakültesi':false,
      'İletişim':false,
      'İnsani Bilimler ve Edebiyat':false,
      'İşletme':false,
      'Mimarlık':false,
      'Mühendislik':false,
      'Siyasal Bilimler':false,
      'Tıp':false,
      'Diğer':false,
    };

  @override
  Widget build(BuildContext context) {
    
    print("username on demographics contd page:"+user.username);
    final width = MediaQuery.of(context).size.width;
    return Stack(children:[
      Scaffold(
        appBar: SignupAppBar(automaticallyImplyLeading: false),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal:12.0),
          child:ListView(
          children: <Widget>[
            SizedBox(height: 8.0),
            Text("YKS'ye hangi puan türünde gireceksiniz?",
              style: o.TextStyles.optikTitle,
              textAlign: TextAlign.center,),
            OptikRadioButton(
              choices: {
                'EA':'Eşit Ağırlık',
                'SAY':'Sayısal',
                'SÖZ':'Sözel',
                'TYT':'TYT'}
            ),
            Divider(color: Colors.black),
            Text("Üniversitede hangi bölümleri okumak istiyorsunuz?",
              style: o.TextStyles.optikTitle,
              textAlign: TextAlign.center,),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children:[for (var i in majorsMap.keys) checkbox(i,majorsMap[i],width)]
            ),
            /* Text(_success == null
                  ? ''
                  : (_success
                      ? 'Successfully registered ' + user.email
                      : 'Registration failed')), */
            SizedBox(height: 100.0,)
          ]
        )
      ),
      bottomSheet:SignupSonrakiButton(
        onPressed:loading?(){}:() async {
          user.desiredMajors = (Map.from(majorsMap)..removeWhere((k, v) => !v)).keys.toList();
          if (user.areaChoice==null){
            showDialog (
              context: context,
              builder: (BuildContext context) {
                return AlertDialog (
                  title: Text("Uyarı",style: o.TextStyles.optikBody1Bold,),
                  content: Text("Lütfen YKS puan türünüzü işaretleyin",style: o.TextStyles.optikTitle,)
                );
              }
            );
          } else{
            /* setState(() {
              loading = true;
            }); */
            /* await Future.delayed(Duration(seconds: 2)); // [DELETE LATER]
            await sendCreateUserInfo(user: user); // [POST FUNCTION] */
            
            Navigator.pushNamed(
              context, 
              '/signup_enterphone',
              arguments: user);

            /* Navigator.pushNamedAndRemoveUntil(
              context, 
              '/home',
              (Route<dynamic> route) => false,
              arguments: {'user':user,'cache':Map<dynamic,dynamic>()}); */
          }
        }
      )
    ),
    /* loading?Loading(negative: true,transparent: true,opacity: 0.5):SizedBox() */
    ]
    );
  }
}