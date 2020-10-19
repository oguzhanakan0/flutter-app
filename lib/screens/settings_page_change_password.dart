import 'package:flutter/material.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/widgets/signup_appbar.dart';
import 'package:Optik/models/theme.dart' as o;


class SettingsPageChangePassword extends StatefulWidget {
  final state = _SettingsPageChangePasswordState();

  SettingsPageChangePassword({Key key}) : super(key: key);
  @override
  _SettingsPageChangePasswordState createState() => state;
  /* bool isValid() => state.validate(); */
}

class _SettingsPageChangePasswordState extends State<SettingsPageChangePassword> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: SignupAppBar(),
        body: ListView(
          children: <Widget>[Padding(
            padding: EdgeInsets.all(16),
            child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    /* USERNAME FIELD */
                    TextFormField(
                      style: o.TextStyles.optikTitle,
                      initialValue: user.username,
                      decoration: InputDecoration(
                        labelText: 'Kullanıcı Adı',
                        labelStyle: o.TextStyles.optikTitle,
                        icon: Icon(Icons.person),
                        isDense: true,
                      ),
                      enabled: false,
                    ),
                    /* EMAIL FIELD */
                    TextFormField(
                      style: o.TextStyles.optikTitle,
                      decoration: InputDecoration(
                        labelText: 'Email (isteğe bağlı)',
                        labelStyle: o.TextStyles.optikTitle,
                        icon: Icon(Icons.email),
                        isDense: true,
                      ),
                      onChanged: (value){
                        user.email = value;
                      },
                    )
                  ],
                ),
              ),
          SizedBox(height: 100.0)
        ]
      ),
    );
  }
}