import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/services/post_functions.dart';
import 'package:Optik/widgets/loading.dart';
import 'entrance_page.dart';
import 'package:Optik/collections/globals.dart';
import 'package:Optik/services/login_methods.dart' as loginMethods;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final FacebookLogin facebookLogin = FacebookLogin();

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool loading;
  User user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState(){
    super.initState();
    loading=false;
    user = User();
  }

  // Example code of how to sign in with google.
  /* Future<dynamic> _signInWithGoogle() async {
    dynamic credentials = {};
    try{
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;      
      if (user != null) {
        IdTokenResult token = await user.getIdToken();
        credentials['token'] = token.token;
        credentials['googleUserID'] = user.uid;
        credentials['email'] = user.email;
        return credentials;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  } */

  /* Future<dynamic> initiateFacebookLogin() async {
    // Asamalar: 
    // 1. Facebook login
    // 2. Firebase Signup
    // 3. Optik Signup
    try{
      var facebookLoginResult = await facebookLogin.logInWithReadPermissions(['email']);
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          print("Error");
          break;
        case FacebookLoginStatus.cancelledByUser:
          print("CancelledByUser");
          break;
        case FacebookLoginStatus.loggedIn:
          print("LoggedIn with Facebook");
          final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult.accessToken.token}');
          final profile = json.decode(graphResponse.body);
          user.email = profile['email'];
          user.firstName = profile['first_name'];
          user.lastName = profile['last_name'];
      }

      try {
        dynamic returnCredentials = {};
        AuthCredential credentials = FacebookAuthProvider.getCredential(accessToken: facebookLoginResult.accessToken.token);
        AuthResult firebaseAuthResult = await _auth.signInWithCredential(credentials);
        IdTokenResult firebaseToken = await firebaseAuthResult.user.getIdToken();
        
        returnCredentials['googleUserID'] = firebaseAuthResult.user.uid;
        returnCredentials['email'] = firebaseAuthResult.user.email;
        returnCredentials['token'] = firebaseToken.token;
        return returnCredentials;
      } catch(e){
        showSimpleNotification(
          Text(e.code == "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL"?
            'Bu email adresine ait bir hesap mevcut. Daha önceden başka bir yöntemle giriş yapmış olabilir misin?':
            'Bir hata oluştu. Lütfen tekrar deneyin.'),
        );
        return null;
      }
    } catch(e){
      return null;
    }
    
  } */

  // Example code of how to sign in with email and password.
  /* Future<dynamic> _signInWithEmailAndPassword() async {
    dynamic credentials = {};
    try{
    final AuthResult res = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ));
    IdTokenResult token=await res.user.getIdToken();
    credentials['googleUserID'] = res.user.uid;
    credentials['token'] = token.token;
    credentials['email']=res.user.email;
    return credentials;
    } catch(e){
      String msg ='';
      switch (e.code) {
        case 'ERROR_WRONG_PASSWORD':
          msg = 'Hata: Girdiğiniz şifre yanlış. Lütfen tekrar deneyin.';break;
        case 'ERROR_INVALID_EMAIL':
          msg = 'Hata: Email adresi geçersiz.';break;
        case 'ERROR_USER_NOT_FOUND':
          msg = 'Hata: Kullanıcı bulunamadı.';break;
        default:
          msg = 'Bir hata oluştu. Lütfen tekrar deneyin.';break;
      }
      showSimpleNotification(
        Text(msg),
      );
      return null;
    }
  } */

  @override
  Widget build(BuildContext context) {
    return UserInherited(
      user:user,
      child:
        /* Image.asset(
          'assets/images/welcome_bg_blurred.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ), */
        Stack(children:[
          Scaffold(
          backgroundColor: o.Colors.optikWhite,
          body: SingleChildScrollView(child:Padding(
            padding: EdgeInsets.symmetric(horizontal:32.0),
            child:Center(child:Column(
              children:[
              Container(
                margin: EdgeInsets.symmetric(vertical: 100),
                alignment: Alignment.center,
                height: 60, 
                child:Image(image: AssetImage('assets/images/logoWithText.png'))
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(16.0),
                ),
                color: o.Colors.optikBlue,
                minWidth: MediaQuery.of(context).size.width,
                elevation: 0.5,
                padding: EdgeInsets.symmetric(vertical:12.0),
                onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    // call authentication logic
                    dynamic credentials = await loginMethods.initiateFacebookLogin();
                    setState(() {
                      loading = false;
                    });
                    SIGNIN_METHOD = 'FACEBOOK';
                    doTheRest(context, credentials);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Icon(MdiIcons.facebook,color: o.Colors.optikWhite,),
                    Text('Facebook ile Devam Et',style: o.TextStyles.optikBody1BoldWhite,)
                  ])
              ),
              SizedBox(height: 8.0,),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(16.0),
                ),
                color: o.Colors.optikBlue,
                minWidth: MediaQuery.of(context).size.width,
                elevation: 0.0,
                padding: EdgeInsets.symmetric(vertical:12.0),
                onPressed: () async {
                  setState(() {
                      loading = true;
                    });
                  /* await Future.delayed(Duration(seconds: 1)); // [DELETE LATER] */
                  dynamic credentials = await loginMethods.signInWithGoogle();
                  setState(() {
                    loading = false;
                  });
                  SIGNIN_METHOD = 'GOOGLE';
                  doTheRest(context, credentials);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Icon(MdiIcons.google,color: o.Colors.optikWhite,),
                    Text('Google ile Devam Et',style: o.TextStyles.optikBody1BoldWhite,)
                  ])
              ),
              Row(children: <Widget>[Expanded(child:Divider(height:32.0,color:o.Colors.optikGray, thickness:1.0,endIndent: 8.0)),Text("ya da",style: o.TextStyles.optikBody2.copyWith(color:o.Colors.optikGray),),Expanded(child:Divider(indent: 8.0,color:o.Colors.optikGray, thickness:1.0))]),
            /* Padding(
              padding: EdgeInsets.symmetric(horizontal:24,vertical: 8.0),
              child: 
              Column(mainAxisSize: MainAxisSize.min,
                children: <Widget>[ */
                  /* DON'T HAVE AN ACCOUNT TEXT */
                  /* Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup',arguments: user);
                      },
                      child: Text("Kaydolmak için tıklayın",
                        style:o.TextStyles.optikSubTitle.copyWith(fontWeight: FontWeight.w600)
                      )     
                    )
                  ), */
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),border:Border.all(color: o.Colors.optikBlue,width: 2.0)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  padding: EdgeInsets.symmetric(horizontal:4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      /* USERNAME FIELD */
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal:16.0),
                        child:
                          TextFormField(
                            controller: _emailController,
                            onChanged: (value) {
                              user.username = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: o.TextStyles.optikBody1,
                              icon: Icon(Icons.person),
                              isDense: true,
                            ),
                      )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                      /* PASSWORD FIELD */
                        child:TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          onChanged: (value) {
                              user.password = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Şifre',
                            labelStyle: o.TextStyles.optikBody1,
                            icon: Icon(Icons.kitchen),
                            isDense: true,
                          ),
                        ),
                      ),
                      /* LOGIN BUTTON */
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          /* side: BorderSide(width: 2.0,color: o.Colors.optikBlue) */
                        ),
                        color: o.Colors.optikBlue,
                        minWidth: MediaQuery.of(context).size.width,
                        elevation: 0.0,
                        padding: EdgeInsets.symmetric(vertical:12.0),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          /* await Future.delayed(Duration(seconds: 1)); // [DELETE LATER] */
                          dynamic credentials = await loginMethods.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                          if(credentials!=null){
                            User user2 = await sendLoginInfo(userID:credentials['googleUserID'],token:credentials['token']); // [POST FUNCTION]
                            print('session id: '+SESSION_ID);
                            if(user2!=null){
                              user2.email = credentials['email'];
                              if(user2.phoneVerified){
                              Navigator.pushNamedAndRemoveUntil(
                                context, 
                                '/home',
                                (Route<dynamic> route) => false,
                                arguments: {'user':user2,'cache':Map<dynamic,dynamic>()});
                              }else{
                                SIGNIN_METHOD = 'EMAIL';
                                USER_PASSWORD = user.password;
                                print('signin method set to: '+SIGNIN_METHOD);
                                print('user password set to: '+USER_PASSWORD);
                                Navigator.pushNamedAndRemoveUntil(
                                context, 
                                '/signup_demographics',
                                (Route<dynamic> route) => false,
                                arguments: user2);
                              }
                            }
                          } else {
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        child: Text("Giriş Yap",
                            textAlign: TextAlign.center,
                          /*   style:o.TextStyles.optikBody1Bold.copyWith(color:o.Colors.optikBlue) */
                            style: o.TextStyles.optikBody1BoldWhite,
                          ),
                      )])),
                      Row(children: <Widget>[Expanded(child:Divider(height:32.0,color:o.Colors.optikGray, thickness:1.0,endIndent: 8.0)),Text("ya da",style: o.TextStyles.optikBody2.copyWith(color:o.Colors.optikGray),),Expanded(child:Divider(indent: 8.0,color:o.Colors.optikGray, thickness:1.0))]),
                      Row(children:[
                        Expanded(child:MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(16.0),
                          side: BorderSide(width: 1.0,color: o.Colors.optikGray)
                        ),
                        /* minWidth: MediaQuery.of(context).size.width, */
                        elevation: 0.0,
                        padding: EdgeInsets.symmetric(vertical:12.0),
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup',arguments: user);
                        },
                        child: Text('Kayıt Ol',style: o.TextStyles.optikBody1.copyWith(color:o.Colors.optikGray),)
                      )),
                      SizedBox(width: 8.0,),
                      Expanded(child:MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(16.0),
                          side: BorderSide(width: 1.0,color: o.Colors.optikGray)
                        ),
                        /* minWidth: MediaQuery.of(context).size.width, */
                        elevation: 0.0,
                        padding: EdgeInsets.symmetric(vertical:12.0),
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot_password',arguments: user);
                        },
                        child: Text('Şifremi Unuttum',style: o.TextStyles.optikBody1.copyWith(color:o.Colors.optikGray),)
                      )),])
                    
                /* ), */
                /* FORGOT PASSWORD TEXT */
                /* Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgot_password',arguments: user);
                      },
                      child: Text("Şifremi Unuttum",
                    style:o.TextStyles.optikBody1))
                ), */
          
          /* Container(
            padding: EdgeInsets.symmetric(horizontal:24.0,vertical: 8.0),
            child:FacebookSignInButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                // call authentication logic
                dynamic credentials = await loginMethods.initiateFacebookLogin();
                setState(() {
                  loading = false;
                });
                SIGNIN_METHOD = 'FACEBOOK';
                doTheRest(context, credentials);

            })
          ),
          _GoogleSignInSection(
            onPressed: () async {
              setState(() {
                  loading = true;
                });
              /* await Future.delayed(Duration(seconds: 1)); // [DELETE LATER] */
              dynamic credentials = await loginMethods.signInWithGoogle();
              setState(() {
                loading = false;
              });
              SIGNIN_METHOD = 'GOOGLE';
              doTheRest(context, credentials);
            },
          ) */
          ])))
        ),),
        loading?Loading(negative: true,transparent: true, opacity: 0.5,):SizedBox()
        ])
    );
  }
}

class _GoogleSignInSection extends StatefulWidget {
  final Function onPressed;
  _GoogleSignInSection({this.onPressed});
  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {
  @override
  Widget build(BuildContext context) {
    return 
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        alignment: Alignment.center,
        child: RaisedButton(
          onPressed: widget.onPressed,
          child: const Text('Sign in with Google'),
        )
    );
  }
}


void doTheRest(BuildContext context, dynamic credentials) async {
  print('doing the rest...');
  if(credentials!=null){
    User user2 = await sendLoginInfo(userID:credentials['googleUserID'],token:credentials['token']); // [POST FUNCTION]
    if(user2!=null){
      print('user returned NOT null');
      user2.email = credentials['email'];
      if(user2.phoneVerified){
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/home',
          (Route<dynamic> route) => false,
          arguments: {'user':user2,'cache':Map<dynamic,dynamic>()});
      }else{
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/signup_demographics',
          (Route<dynamic> route) => false,
          arguments: user2);
      }
    } else{
      print('user returned null');
      bool res = await optikCreateUser(userID: credentials['googleUserID'], token:credentials['token']);
      print('pushing to demographics page..');
      if(res){
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/signup_demographics',
          (Route<dynamic> route) => false,
          arguments: User(googleUserID: credentials['googleUserID'],email: credentials['email']));
      }
    }
  }
}