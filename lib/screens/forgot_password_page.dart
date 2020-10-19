import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:Optik/widgets/signup_sonraki_button.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:overlay_support/overlay_support.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class ForgotPasswordPage extends StatefulWidget {
  final state = _ForgotPasswordPageState();

  ForgotPasswordPage({Key key}) : super(key: key);
  @override
  _ForgotPasswordPageState createState() => state;
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final form = GlobalKey<FormState>();
  String email;
  bool sending;
  @override
  void initState() {
    super.initState();
    email = null;
    sending = false;
  }

  Future<bool> resetPassword(String email) async {
    bool success = false;
    String resText = "";
    try{
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      resText = email+" adresine şifrenizi sıfırlamak için gerekli işlemler gönderildi.";
      success = true;
    } catch(e){
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          resText = "Lütfen girdiğiniz email adresini kontrol edin.";
          break;
        case "ERROR_USER_NOT_FOUND":
          resText = "Bu email adresine ait bir kullanıcı bulunamadı.";
          break;
        default:
          resText = "Bir hata oluştu.";
      }
    }
    showSimpleNotification(Text(resText));
    return success;
  }

  @override
  Widget build(BuildContext context) {
    /* User user = ModalRoute.of(context).settings.arguments; */
    return Stack(
      children:[Scaffold(
        appBar:PreferredSize(preferredSize:Size.fromHeight(50.0),child:AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios,color: o.Colors.optikBlack,),
              onPressed: () {Navigator.of(context).pop();},
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        centerTitle: true,
        title:Text('Şifremi Unuttum',style: o.TextStyles.optikTitle),
        backgroundColor: o.Colors.optikWhite,)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal:12.0,vertical: 12.0),
          child:ListView(
            children: <Widget>[
              Text('Yeni şifrenizin gönderilebilmesi için lütfen kayıt olduğunuz email adresinizi yazınız.',textAlign: TextAlign.center,style: o.TextStyles.optikBody1,),
              /* OLD PASSWORD FIELD */
              Form(
                key: form,
                child: Align(
                alignment: Alignment.center,
                child:Container(
                  width: MediaQuery.of(context).size.width*4/5,
                  child:/* EMAIL FIELD */
                    TextFormField(
                      style: o.TextStyles.optikTitle,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: o.TextStyles.optikTitle,
                        icon: Icon(Icons.email),
                        isDense: true,
                      ),
                      onChanged: (value){
                        email = value;
                      },
                      validator: (value) {
                        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                          return 'Geçerli bir email adresi girmelisiniz';
                        }
                        return null;
                      },
                    ),
                )
              )
              )
            ],
          ),
      ),
      bottomSheet:SignupSonrakiButton(
        title: 'Gönder',
        color: o.Colors.optikBlue,
        onPressed:sending? () {} : () async {
          if(email == null){
            showDialog (
              context: context,
              builder: (BuildContext context) {
                return AlertDialog (
                  title: Text("Uyarı",style: o.TextStyles.optikBody1Bold,),
                  content: Text("Lütfen email adresinizi girin",style: o.TextStyles.optikTitle,)
                );
              }
            );
          }
          else if (form.currentState.validate()) {
            setState(() {
              sending = true;
            });
            /* await Future.delayed(Duration(seconds: 1)); // [DELETE LATER] */
            /* bool res= await sendForgotPasswordInfo(email:email); // [POST FUNCTION] */
            bool res = await resetPassword(email);
            /* showSimpleNotification(
              Text(res?"Yeni şifren "+email+" adresine gönderildi. Lütfen email adresini kontrol et.":"Yeni şifre isteğini alırken bir hata oluştu. Lütfen email adresini kontrol ederek tekrar dene.",
              style: o.TextStyles.optikBody1White),
              background: o.Colors.optikBlue,
              autoDismiss: true,
            ); */
            if(res){
              Navigator.pop(context);
            } else {
              setState(() {
                sending = false;
              });
            }
          }
        }
        )
      ),
      sending?Loading(negative:true,transparent:true,opacity:0.5):SizedBox()
      ]
    );
  }
}