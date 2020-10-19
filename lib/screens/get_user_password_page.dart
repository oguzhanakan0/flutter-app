import 'package:Optik/services/login_methods.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Optik/collections/globals.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/models/theme.dart' as o;

class GetUserPasswordPage extends StatefulWidget {
  
  const GetUserPasswordPage();
  @override
  _GetUserPasswordPageState createState() => _GetUserPasswordPageState();
}

class _GetUserPasswordPageState extends State<GetUserPasswordPage> {
  User user;
  bool loading;
  bool userCheck;
  String enteredPassword;

  @override
  void initState() {
    super.initState();  
    loading = false;
    enteredPassword='';
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    user = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Scaffold(
          body:Padding(
            padding: EdgeInsets.symmetric(horizontal:32.0),
            child:Center(child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Container(
                  alignment: Alignment.center,
                  height: 40, 
                  child:Image(image: AssetImage('assets/images/logoWithText.png'))
                ),
                SizedBox(height: 40),
                Text('Lütfen '+user.email+' kullanıcınız için belirlediğiniz şifrenizi girin:',
                  textAlign: TextAlign.center),
                TextFormField(
                  obscureText: true,
                  onChanged: (value){
                    setState(() {
                      enteredPassword = value;
                    });
                  },),
                RaisedButton(
                  onPressed: loading?(){}:() async {
                    setState(() {
                      loading = true;
                    });
                    dynamic credentials = await signInWithEmailAndPassword(user.email,enteredPassword);
                    if(credentials!=null){
                      USER_PASSWORD = enteredPassword;
                      Navigator.pushNamedAndRemoveUntil(
                          context, 
                          '/signup_demographics',
                          (Route<dynamic> route) => false,
                          arguments: User(googleUserID: credentials['googleUserID'],email: credentials['email']));
                    }
                    setState(() {
                      loading = false;
                    });
                  },
                  color: o.Colors.optikBlue,
                  textColor: o.Colors.optikWhite,
                  child: Text('Gönder'),
                ),
                RaisedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, '/login_page',(Route<dynamic> route) => false);
                  },
                  child: Text('Başka bir hesapla giriş yap'),
                )
              ])
            )
          )
        ),
        loading?Loading(negative: true,transparent: true,opacity: 0.5,):SizedBox()
      ]
    );
  }
}