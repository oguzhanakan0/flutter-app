/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_multipage_form/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Convert Firebase user to custom user
  User _customUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // Sign in email - password
  Future signInEmail({ String email, String password }) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _customUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register email - password
  Future registerEmail({ String email, String password, String fullName }) {

  }

  // Register phone to email
  Future registerPhone({ String email, String phone }) async {
    try {
      String smsCode;
      String verificationId;

      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
        verificationId = verId;
      };

      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
        verificationId = verId;
        print('sent:' + verificationId);
      };

      final PhoneVerificationCompleted verifySucceeded = (AuthCredential cred) {
        print('verified');
      };

      final PhoneVerificationFailed verifyFailed = (AuthException e) {
        print(e.message);
      };

      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 5),
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        verificationCompleted: verifySucceeded,
        verificationFailed: verifyFailed
      );

      //FirebaseUser user = result.user;
      //return _customUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
} */