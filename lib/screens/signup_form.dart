import 'package:Optik/services/post_functions.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/widgets/signup_appbar.dart';
import 'package:Optik/widgets/signup_sonraki_button.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:Optik/collections/globals.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


class SignupForm extends StatefulWidget {
  final User user;
  final state = _SignupFormState();

  SignupForm({Key key, this.user}) : super(key: key);
  @override
  _SignupFormState createState() => state;
  /* bool isValid() => state.validate(); */
}

class _SignupFormState extends State<SignupForm> {
  final form = GlobalKey<FormState>();
  bool loading;
  @override
  void initState() {
    super.initState();
    loading = false;
  }
  
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    user.marketingCheck = true;
    return Scaffold(
        appBar: SignupAppBar(),
        body: Stack(children:[ListView(
          children: <Widget>[Padding(
            padding: EdgeInsets.all(16),
            child:
              Form(
                key: form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    /* USERNAME FIELD */
                    TextFormField(
                      style: o.TextStyles.optikTitle,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: o.TextStyles.optikTitle,
                        icon: Icon(Icons.email),
                        isDense: true,
                      ),
                      onChanged: (value){
                        user.email = value;
                      }
                    ),
                    /* PASSWORD FIELD */
                    TextFormField(
                      style: o.TextStyles.optikTitle,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        labelStyle: o.TextStyles.optikTitle,
                        icon: Icon(Icons.remove_red_eye),
                        isDense: true,
                      ),
                      onChanged: (value){
                        user.password = value;
                      },
                      validator: (value) {
                        if (value.length<6) {
                          return 'Şifreniz en az 6 karakter içermelidir';
                        } else if (value.length>20){
                          return 'Şifreniz en fazla 20 karakter içerebilir';
                        }
                        return null;
                      },
                    ),
                    /* CONFIRM PASSWORD FIELD */
                    TextFormField(
                      style: o.TextStyles.optikTitle,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Şifre (tekrar)',
                        labelStyle: o.TextStyles.optikTitle,
                        icon: Icon(Icons.remove_red_eye),
                        isDense: true,
                      ),
                      validator: (value) {
                        if (user.password == null || user.password.length<4 || user.password.length>20){
                          return null;
                        }
                        else if (value!=user.password) {
                          return 'Şifreler eşleşmiyor';
                        }
                        return null;
                      }
                    ),
                    /* KVKK APPROVAL CHECKBOX */
                    /* CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title:Text('Üniversitelerin tarafıma tanıtım amacıyla ulaşmasına izin veriyorum.',
                          style: o.TextStyles.optikBody1,),
                        key:null,value:_isChecked1,
                        onChanged: (value){
                          setState(() {
                            _isChecked1 = !_isChecked1;  
                          });
                          user.marketingCheck = value;
                      },)
                    ,
                    /* TERMS AND CONDITIONS CHECKBOX */
                    CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title:Text('OptikApp uygulama kullanım yönergelerini ve veri koruma protokolünü okudum ve kabul ediyorum.',
                          style: o.TextStyles.optikBody1),
                        key:null,value:_isChecked2,
                        onChanged: (value){
                          setState(() {
                            _isChecked2=!_isChecked2;
                          });
                    }), */
                    SizedBox(height:40.0),
                    Text('Bu uygulamaya kaydolarak OptikApp uygulama kullanım yönergelerini ve veri koruma protokolünü kabul etmiş sayılırsınız.',
                      style: o.TextStyles.optikBody2,
                      textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),
          SizedBox(height: 100.0)
        ]
      ),
      loading?Loading(negative:true,transparent:true,opacity:0.5):SizedBox()
      ]
      ),
      bottomSheet:SignupSonrakiButton(
        onPressed:() async {
          if (form.currentState.validate()) {
            /* if (!_isChecked2){
              showDialog (
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog (
                    title: Text("Uyarı",style: o.TextStyles.optikBody1Bold,),
                    content: Text("Kullanım koşullarını kabul etmelisiniz",style: o.TextStyles.optikTitle,)
                  );
                }
              );
            } else{ */
              /* String res = await fetchIfUserExists(username:user.username, email:user.email); */
              setState(() {
                loading = true;
              });
              try{
                final FirebaseUser user2 = (await _auth.createUserWithEmailAndPassword(
                  email: user.email,
                  password: user.password,
                )).user;
                if (user2 != null) {
                  user.googleUserID = user2.uid;
                  IdTokenResult token = await user2.getIdToken();
                  bool res = await optikCreateUser(userID: user.googleUserID, token:token.token);
                  if(res){
                    SIGNIN_METHOD = 'EMAIL';
                    USER_PASSWORD = user.password;
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      '/signup_demographics',
                      ModalRoute.withName('/login_page'),
                      arguments: user);
                  } 
                  setState(() {
                    loading = false;
                  });
                }
              } catch(e){
                print(e);
                String msg ='Bir hata oluştu.';
                try{
                  switch (e.code) {
                    case 'ERROR_EMAIL_ALREADY_IN_USE':
                      msg = 'Hata: Bu email adresiyle kayıtlı bir kullanıcı mevcut.';break;
                    case 'ERROR_INVALID_EMAIL':
                      msg = 'Hata: Email adresi geçersiz.';break;
                    case 'ERROR_WEAK_PASSWORD':
                      msg = 'Hata: Şifre çok güçsüz. Lütfen şifrenin en az 6 karakter olmasına dikkat edin.';break;
                    case 'ERROR_NETWORK_REQUEST_FAILED':
                      msg = 'Hata: Lütfen bağlantınızı kontrol edin.';break;
                  }
                } catch(f){
                  msg ='Bilinmeyen bir hata oluştu.';
                }
                showSimpleNotification(
                  Text(msg),
                );
                setState(() {
                  loading = false;
                });
                print('user registration fail');
              }
            }
          }
        /* } */
      )
    );
  }
}