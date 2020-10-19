import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:Optik/widgets/signup_sonraki_button.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:overlay_support/overlay_support.dart';


class ChangePasswordPage extends StatefulWidget {
  final state = _ChangePasswordPageState();

  ChangePasswordPage({Key key}) : super(key: key);
  @override
  _ChangePasswordPageState createState() => state;
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final form = GlobalKey<FormState>();

  String newPassword;
  String oldPassword;
  bool sending;
  @override
  void initState() {
    super.initState();  
    oldPassword = '';
    newPassword = '';
    sending = false;
  }

  Future<bool> _changePassword(String email, String oldPassword, String password) async{
    //Create an instance of the current user. 
    bool success;
    String resText = '';
    try{
      AuthResult res = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: oldPassword);
      FirebaseUser user = res.user;
      //Pass in the password to updatePassword.
      await user.updatePassword(password).then((_){
        print("Succesfull changed password");
        resText = "Şifreniz başarıyla değiştirildi.";
        success = true;
        print('new pass: '+password);
        print("user: "+user.uid);
      }).catchError((error){
        print("Password can't be changed" + error.toString());
        /* switch (error.code) {
          default:
        } */
        resText = "Şifreniz değişirken hata oluştu"; 
        success = false;
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } catch(e){
      print(e);
      success = false;
      switch (e.code) {
        case 'ERROR_WRONG_PASSWORD':
          resText = 'Hata: Eski şifrenizi yanlış girdiniz. Lütfen tekrar deneyin.';break;
        default:
          resText = 'Bir hata oluştu. Lütfen tekrar deneyin.';break;
      }
    }
    showSimpleNotification(
      Text(resText,
      style: o.TextStyles.optikBody1White),
      background: o.Colors.optikBlue,
      autoDismiss: true,
    );
    setState(() {
      sending = false;
    });
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
        title:Text('Şifreni Değiştir',style: o.TextStyles.optikTitle),
        backgroundColor: o.Colors.optikWhite,)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal:12.0,vertical: 12.0),
          child:Form(
                key: form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    /* OLD PASSWORD FIELD */
                    TextFormField(
                      style: o.TextStyles.optikTitle,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mevcut Şifreniz',
                        labelStyle: o.TextStyles.optikTitle,
                        isDense: true,
                      ),
                      onChanged: (value){
                        oldPassword = value;                        
                      },
                    ),
                    /* NEW PASSWORD FIELD */
                    TextFormField(
                      style: o.TextStyles.optikTitle,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Yeni Şifreniz',
                        labelStyle: o.TextStyles.optikTitle,
                        isDense: true,
                      ),
                      onChanged: (value){
                        setState(() {
                          newPassword = value;
                        });
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
                    TextFormField(
                      style: o.TextStyles.optikTitle,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Yeni Şifreniz (Tekrar)',
                        labelStyle: o.TextStyles.optikTitle,
                        isDense: true,
                      ),
                      validator: (value) {
                        if (newPassword == null || newPassword.length<6 || newPassword.length>20){
                          return null;
                        }
                        else if (value!=newPassword) {
                          return 'Şifreler eşleşmiyor';
                        }
                        return null;
                      }
                    ),
                  ],
                ),
              ),
      ),
      bottomSheet:SignupSonrakiButton(
        title: 'Kaydet',
        color: o.Colors.optikBlue,
        onPressed:sending?(){}:() async {
          if (form.currentState.validate()) {
            setState(() {
              sending = true;
            });
            await Future.delayed(Duration(seconds: 1));
            /* String res= await sendChangePasswordInfo(username: user.username, oldPassword: oldPassword, newPassword: newPassword);
            String resText;
            switch(res){
              case "success": 
                resText = "Şifreniz başarıyla değiştirildi.";
                break;
              case "invalid":
                resText = "Eski şifrenizi yanlış girdiniz. Lütfen tekrar deneyin.";
                break;
              case "error": 
                resText = "Şifrenizi değiştirirken bir hata oluştu. Lütfen tekrar deneyin";
                break;
              } */
              
            bool res = await _changePassword(user.email, oldPassword, newPassword);
            
            if(res){
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