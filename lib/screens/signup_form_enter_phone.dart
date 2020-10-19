import 'package:Optik/collections/globals.dart';
import 'package:Optik/services/post_functions.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/widgets/signup_appbar.dart';
import 'package:Optik/widgets/signup_sonraki_button.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pin_view/pin_view.dart';
import 'package:Optik/services/login_methods.dart' as loginMethods;

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignupFormPhoneNumber extends StatefulWidget {
  final state = _SignupFormPhoneNumberState();

  SignupFormPhoneNumber({Key key}) : super(key: key);
  @override
  _SignupFormPhoneNumberState createState() => state;

  /* bool isValid() => state.validate(); */
}

class _SignupFormPhoneNumberState extends State<SignupFormPhoneNumber> {
  final form = GlobalKey<FormState>();
  /* final form = GlobalKey<FormState>(); */
  /* final AuthService _auth = AuthService(); */
  TextEditingController _phoneNumberController = TextEditingController();
  bool smsSent;
  String verificationId;
  bool loading;
  
  @override
  void initState(){
    super.initState();
    smsSent = false;
    loading = false;
  }

  
/// Sends the code to the specified phone number.
  Future<void> _sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) {
      setState(() {
          print('Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded');
      });
    };

    final PhoneVerificationFailed verificationFailed = (AuthException authException) {
      setState(() {
        print('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');}
        );
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print("code sent to " + _phoneNumberController.text);
      setState(() {
        smsSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("auto retrieval time out");
    };

     await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
  
  /// Sign in using an sms code as input.
  Future<dynamic> _signInWithPhoneNumber(String smsCode) async {
    /* dynamic postArguments = {}; */
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      String _token = await currentUser.getIdToken().then((token)=>token.token);
      print('signInWithPhoneNumber succeeded: $currentUser');
      return _token;
    } catch(e){
      print('error caught: $e');
      String msg ='';
      switch (e.code) {
        case 'ERROR_INVALID_CREDENTIAL':
          msg = 'Hata: Yanlış kod girdiniz. Lütfen tekrar deneyin.';break;
        case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
          msg = 'Hata: Bu telefon numarası daha önceden kullanılmış. Lütfen başka bir numara giriniz.';break;
        default:
          msg = 'Bir hata oluştu.'; break;
      }
      showSimpleNotification(
        Text(msg),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    print('Landed in signup_form_enter_phone');
    print(user.googleUserID);
    print("username on enterphone page:"+user.username);
    print(user.username);
    print(SESSION_ID);
    return
      WillPopScope(
        onWillPop: (){},
        child:Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: SignupAppBar(automaticallyImplyLeading:false),
          body: smsSent?Stack(children:[
            ListView(
              children: [Padding(
                padding: EdgeInsets.all(16),
                child: 
                Column(
                  children: [
                    Text("Lütfen telefonunuza gönderilen SMS'teki 6 haneli şifreyi girin.",
                      style: o.TextStyles.optikSubTitle,
                      textAlign: TextAlign.center),
                    PinView (
                      count: 6,
                      autoFocusFirstField: false,
                      submit: (String pin) async {
                        setState(() {
                          loading=true;
                        });
                        try{
                        bool res2 = await isUsernameAvailable(username:user.username);
                        if(res2){
                          dynamic res = await _signInWithPhoneNumber(pin);
                          print('signin with phone number ok');
                          if(res!=null){
                            bool res2= await postUserDemographics(user:user,token:res);
                            print('verify user ok');
                            if(res2){
                              // 3. LOGIN TO FIREBASE WITH EMAIL USER
                              print('Signin method is: '+SIGNIN_METHOD);
                              dynamic credentials;
                              switch (SIGNIN_METHOD) {
                                case "FACEBOOK":
                                  credentials = await loginMethods.initiateFacebookLogin();break;
                                case "GOOGLE":
                                  credentials = await loginMethods.signInWithGoogle();break;
                                case "EMAIL":
                                  print(user.email+':'+USER_PASSWORD);
                                  credentials = await loginMethods.signInWithEmailAndPassword(user.email,USER_PASSWORD);break;

                              }
                              print(credentials);
                              if(credentials!=null){
                                print('3rd time logins successful');
                                Navigator.pushNamedAndRemoveUntil(
                                  context, 
                                  '/home',
                                  (Route<dynamic> route) => false,
                                  arguments: {'user':user,'cache':Map<dynamic,dynamic>()});
                              } else {
                                showSimpleNotification(Text('Bir hata oluştu.'));
                                Navigator.pushNamedAndRemoveUntil(context,'/login_page',(Route<dynamic> route) => false,);
                              }
                            } else {
                              showSimpleNotification(Text('Bir hata oluştu.'));
                              Navigator.pushNamedAndRemoveUntil(context,'/login_page',(Route<dynamic> route) => false,);
                            }
                            /* Navigator.pushNamedAndRemoveUntil(
                              context, 
                              '/signup_demographics',
                              ModalRoute.withName('/login_page'),
                              arguments: user);  */ 
                          } else {
                            showSimpleNotification(Text('Lütfen girdiğiniz kodu kontrol edin.'));
                          }
                        } 
                        setState(() {
                            loading=false;
                        });
                      } catch(e){
                        showSimpleNotification(Text('Lütfen internet bağlantınızı kontrol edin.'));
                        setState(() {
                          loading=false;
                        });
                      }
                      } 
                    ),
                    /* Text("SMS gelmedi mi? 180 saniye içerisinde tekrar deneyebilirsiniz.",
                      textAlign: TextAlign.center,
                      style: o.TextStyles.optikSubTitle
                    ) */
                  ]
                )
              )
            ]),
            loading?Loading(negative: true,transparent: true,opacity: 0.5):SizedBox(),
            ]):
            Container(
            padding: EdgeInsets.all(16.0),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Wrap(crossAxisAlignment: WrapCrossAlignment.center,
                  children : <Widget>[
                    Text("Lütfen telefon numaranızı girin",style:o.TextStyles.optikSubTitle),
                    Icon(Icons.info)
                  ]
                ),
                Form(
                  key: form,
                  child:Container(
                  width: MediaQuery.of(context).size.width*4/5,
                  child:Align(
                    alignment: Alignment.center,
                    child:InternationalPhoneNumberInput(
                      initialCountry2LetterCode: 'TR',
                      inputDecoration: InputDecoration(
                        hintText: '(598) 765-4321',
                        hintStyle: o.TextStyles.optikSubTitle,
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none
                        )
                      ),
                      onInputChanged: (value){
                        user.phoneNumber = value.phoneNumber;
                        _phoneNumberController.text = value.phoneNumber;
                      },
                      autoValidate: true,
                      errorMessage: 'Numara eksik veya hatalı',
                      countries: ['TR'],
                    )
                  )
                )
              ),
              Text("Telefonunuza bir SMS gönderilecek ve içindeki dört haneli şifreyi bir sonraki adımda girmeniz istenecek",
                textAlign: TextAlign.center,
                style:o.TextStyles.optikSubTitle
              )
            ]
          )
        ),
        bottomSheet: smsSent?SizedBox():SignupSonrakiButton(
          title: 'SMS Gönder',
          onPressed:() {
            if (user.phoneNumber==null){
                showDialog (
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog (
                      title: Text("Uyarı",style: o.TextStyles.optikBody1Bold,),
                      content: Text("Lütfen telefon numaranızı girin",style: o.TextStyles.optikTitle,)
                    );
                  }
                );
              } else if (form.currentState.validate()) {
                _sendCodeToPhoneNumber();
              /* Navigator.pushNamed(context, '/signup_verifyphone',arguments: user); */
            }
          }
        )
      )
    );
  }
}