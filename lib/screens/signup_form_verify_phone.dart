
import 'package:flutter/material.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/widgets/signup_appbar.dart';
import 'package:Optik/widgets/signup_sonraki_button.dart';
import 'package:pin_view/pin_view.dart';
import 'package:Optik/models/theme.dart' as o;

/* VERIFY PHONE NUMBER */

class VerifyPhoneNumber extends StatefulWidget {
  final state = _VerifyPhoneNumberState();
  VerifyPhoneNumber({Key key}) : super(key: key);
  @override
  _VerifyPhoneNumberState createState() => state;
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: SignupAppBar(),
      body: ListView(
        children: [Padding(
          padding: EdgeInsets.all(16),
          child: 
          Column(
            children: [
              Text("Lütfen telefonunuza gönderilen SMS'teki 4 haneli şifreyi girin.",
                style: o.TextStyles.optikSubTitle,
                textAlign: TextAlign.center),
              PinView (
                count: 4,
                autoFocusFirstField: false,
                submit: (String pin){
                  showDialog (
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog (
                        title: Text("Verifying..."),
                        content: Text("Entered pin is: $pin")
                      );
                    }
                  );
                } 
              ),
              Text("SMS gelmedi mi? 180 saniye içerisinde tekrar deneyebilirsiniz.",
                textAlign: TextAlign.center,
                style: o.TextStyles.optikSubTitle
              )
            ]
          )
        )
      ]
    ),
    bottomSheet: SignupSonrakiButton(
      onPressed: () {Navigator.pushNamed(context, '/signup_demographics',arguments:user);}
    )
  );
  }
}
