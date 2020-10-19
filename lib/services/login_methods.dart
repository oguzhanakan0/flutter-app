import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FacebookLogin facebookLogin = FacebookLogin();

Future<dynamic> initiateFacebookLogin() async {
  dynamic returnCredentials = {};
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
        returnCredentials['email'] = profile['email'];
        returnCredentials['firstName'] = profile['first_name'];
        returnCredentials['lastName'] = profile['last_name'];
    }

    try {
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
    
}


Future<dynamic> signInWithGoogle() async {
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
    print(e);
    return null;
  }
}


Future<dynamic> signInWithEmailAndPassword(String email, String password) async {
  dynamic credentials = {};
  try{
  final AuthResult res = (await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
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
}

Future<dynamic> signInWithCustomToken(String _token) async {
  dynamic credentials = {};
  try{
    final AuthResult res = (await _auth.signInWithCustomToken(token: _token));
    IdTokenResult token=await res.user.getIdToken();
    credentials['googleUserID'] = res.user.uid;
    credentials['token'] = token.token;
    credentials['email']=res.user.email;
    return credentials;
  } catch(e){
    String msg = 'Bir hata oluştu. Lütfen tekrar deneyin.';
    showSimpleNotification(
      Text(msg),
    );
    return null;
  }
}