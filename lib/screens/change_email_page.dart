import 'package:Optik/services/post_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:Optik/widgets/signup_sonraki_button.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:overlay_support/overlay_support.dart';

final FirebaseAuth auth = FirebaseAuth.instance;


class ChangeEmailPage extends StatefulWidget {
  final state = _ChangeEmailPageState();

  ChangeEmailPage({Key key}) : super(key: key);
  @override
  _ChangeEmailPageState createState() => state;
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final form = GlobalKey<FormState>();
  String newEmail;
  bool sending;
  String password;
  @override
  void initState() {
    super.initState();
    newEmail = '';
    sending = false;
    password = '';
  }

  Future<bool> updateEmail(String oldEmail, String newEmail, String password, String googleUserID) async {
    print('oldEmail: '+oldEmail);
    print('newEmail: '+newEmail);
    print('password: '+password);
    print('googleUserID: '+googleUserID);
    bool success = false;
    try{
      AuthResult res = await FirebaseAuth.instance.signInWithEmailAndPassword(email: oldEmail, password: password);
      FirebaseUser user = res.user;
      try{ 
        user.updateEmail(newEmail);
        bool res2 = await updateOptikDBEmail(userID:googleUserID,newEmail:newEmail);
        if(res2){
          success = true;
        } else {
          // Eger firebase'te degistirip optik db'de degistiremezsek firebase'i de geri almak icin bu asama mevcut.
          user.updateEmail(oldEmail);
          success = false;
        }
      } catch(e){
        success = false;
      }
    } catch(e) {
      String resText = '';
      try{
        switch (e.code) {
          case "ERROR_WRONG_PASSWORD":
            resText = 'Şifrenizi yanlış girdiniz. Lütfen tekrar deneyin.';
            break;
          default: 
            resText = 'Bir hata oluştu. Lütfen daha sonra tekrar deneyin.';
            break;
        }
      } catch (f){
        resText = 'Bir hata oluştu. Lütfen daha sonra tekrar deneyin.';
      }
      showSimpleNotification(Text(resText));
      setState(() {
        sending = false;
      });
    }
    return success;
  }

  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context).settings.arguments;
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
        title:Text('Email Adresini Değiştir',style: o.TextStyles.optikTitle),
        backgroundColor: o.Colors.optikWhite,)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal:12.0,vertical: 12.0),
          child:Form(
                key: form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    /* NEW EMAIL FIELD */
                    TextFormField(
                      style: o.TextStyles.optikTitle,
                      decoration: InputDecoration(
                        labelText: 'Yeni Email Adresiniz',
                        labelStyle: o.TextStyles.optikTitle,
                        isDense: true,
                      ),
                      onChanged: (value){
                        setState(() {
                          newEmail = value;
                        });
                      },
                      validator: (value) {
                        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                          return 'Geçerli bir email adresi girmelisiniz';
                        } else if (value == user.email){
                          return 'Yeni email adresiniz eskisinden farklı olmalı';
                        }
                        return null;
                      },
                    ),
                    /* OLD PASSWORD FIELD */
                    TextFormField(
                      style: o.TextStyles.optikTitle,
                      decoration: InputDecoration(
                        labelText: 'Mevcut Şifreniz',
                        labelStyle: o.TextStyles.optikTitle,
                        isDense: true,
                      ),
                      onChanged: (value){
                        setState(() {
                          password = value;
                        });
                      }
                    ),
                  ],
                ),
              ),
      ),
      bottomSheet:SignupSonrakiButton(
        title: 'Kaydet',
        color: o.Colors.optikBlue,
        onPressed:() async {
          if (form.currentState.validate()) {
            setState(() {
              sending = true;
            });
            bool res = await updateEmail(user.email, newEmail, password, user.googleUserID);
            String resText;
            showSimpleNotification(
              Text(resText,
              style: o.TextStyles.optikBody1White),
              background: o.Colors.optikBlue,
              autoDismiss: true,
            );
            if(res){
              user.email = newEmail;
              Navigator.pop(context);  
            }
          }
        }
        )
      ),
      sending?Loading(negative: true,transparent: true,opacity: 0.5):SizedBox()
      ]
    );
  }
}