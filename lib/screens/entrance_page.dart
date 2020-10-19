import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Optik/collections/globals.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/services/post_functions.dart';
import 'package:Optik/models/theme.dart' as o;

Future getCurrentUser() async {
  dynamic credentials={};
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  if(firebaseUser!=null){
    print("User: ${firebaseUser.uid ?? "None"}");
    String provider;
    if(firebaseUser.providerData.length==1){
      provider = firebaseUser.providerData[0].providerId;
    } else if(firebaseUser.providerData.length==2){
      provider = firebaseUser.providerData[1].providerId;
    }
    print(provider);
    switch (provider) {
      case "password":
        SIGNIN_METHOD = "EMAIL";break;
      case "facebook.com":
        SIGNIN_METHOD = "FACEBOOK";break;
      case "google.com":
        SIGNIN_METHOD = "GOOGLE";break;
      default:
    }
    IdTokenResult token = await firebaseUser.getIdToken();
    credentials['token'] = token.token;
    credentials['googleUserID'] = firebaseUser.uid;
    credentials['email'] = firebaseUser.email;
  return credentials;
  } else {
    return null;
  }
}

class UserInherited extends InheritedWidget {
  final User user;
  UserInherited({
    Key key,
    @required this.user,
    @required Widget child,
  }) : super(key: key, child: child);

  static UserInherited of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(UserInherited)
            as UserInherited);
  }

  @override
  bool updateShouldNotify(UserInherited old) => true;
}
class EntrancePage extends StatefulWidget {
  
  const EntrancePage();
  @override
  _EntrancePageState createState() => _EntrancePageState();
}

class _EntrancePageState extends State<EntrancePage> {
  User user;
  bool loading;
  bool userCheck;
  bool reloadState;
  bool isTappable;

  @override
  void initState() {
    super.initState();  
    loading = true;
    userCheck = false;
    reloadState = false;
    isTappable = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
  }

  @override
  Widget build(BuildContext context) {
    return UserInherited(
      user: user,
      child: reloadState?Scaffold(body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Container(
            alignment: Alignment.center,
            height: 80, 
            child:Image(image: AssetImage('assets/images/logoWithText.png'))
          ),
          Center(child:RaisedButton(
            color: o.Colors.optikBlue,
            child: Text('İnternet bağlantısı bulunamadı. Tekrar dene.',style: o.TextStyles.optikBody1White,),
            onPressed: !isTappable?(){}:() async {
              setState(() {
                isTappable = false;
              });
              await onAfterBuild(context);
            },
            )
          )
        ])):Scaffold(
      body:Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Container(
            alignment: Alignment.center,
            height: 80, 
            child:Image(image: AssetImage('assets/images/logoWithText.png'))
          ),
        ])
      )
      )
    );
  }

  onAfterBuild(BuildContext context) async {
    if(!NO_INTERNET){
      try{
        /* await FirebaseAuth.instance.signOut(); */
        dynamic credentials = await getCurrentUser();
        dynamic res = await trySend(url:address+'/servertime',maxTrials: 3);
        DateTime serverTime = DateTime.parse(res['time']);
        timeOffset = serverTime.difference(DateTime.now()).inMilliseconds;
        print("time offset is: "+timeOffset.toString());
        doTheRest(context,credentials);
      } catch(e){
        if(mounted){
          setState(() {
            reloadState = true;
            isTappable = true;
          });
        }
      }
    } else {
      if(mounted){
        setState(() {
          reloadState = true;
          isTappable = true;
        });
      }
    }
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
        if(SIGNIN_METHOD=='EMAIL'){
          Navigator.pushNamedAndRemoveUntil(
          context, 
          '/get_user_password',
          (Route<dynamic> route) => false,
          arguments: user2);
        } else {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/signup_demographics',
          (Route<dynamic> route) => false,
          arguments: user2);
        }
      }
    } else{
      print('user returned null');
      bool res = await optikCreateUser(userID: credentials['googleUserID'], token:credentials['token']);
      if(res){
        if(SIGNIN_METHOD=='EMAIL'){
            Navigator.pushNamedAndRemoveUntil(
            context, 
            '/get_user_password',
            (Route<dynamic> route) => false,
            arguments: user2);
          } else {
            print('pushing to demographics page..');
            Navigator.pushNamedAndRemoveUntil(
              context, 
              '/signup_demographics',
              (Route<dynamic> route) => false,
              arguments: User(googleUserID: credentials['googleUserID'],email: credentials['email']));
          }
      } else {
        Navigator.pushReplacementNamed(context,'/login_page');
      }
    }
  } else {
    Navigator.pushReplacementNamed(context,'/login_page');
  }
}