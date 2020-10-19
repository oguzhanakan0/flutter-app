import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;


class SettingsPage extends StatelessWidget {
  SettingsPage({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final Map<dynamic,dynamic> args = ModalRoute.of(context).settings.arguments;
    List<dynamic> settingsList = [
      ['Kullanıcı Adı',args['user'].username,false,],
      ['İsim',args['user'].firstName,false,],
      ['Soyisim',args['user'].lastName,false,],
      ['Sınıf',args['user'].grade,false,],
      ['Lise',args['user'].schoolName,false,],
      ['Telefon Numarası',args['user'].phoneNumber,false,],
      ['Email',args['user'].email,false,'/change_email'],
      ['Alan Tercihi',args['user'].areaChoice,true,'/change_area'],
      /* ['Şifre','*****',true,'/change_password'], */
    ];
    List<dynamic> aboutList = [
      ['Nasıl Kullanılır?',Icons.help,'/how'],
      ['Destek',Icons.email,'/help'],
      /* ['Uygulama Hakkında',Icons.info,'/about'] */
    ];
    return Scaffold(
      appBar: PreferredSize(preferredSize:Size.fromHeight(50.0),child:AppBar(
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
        title:Text('Ayarlar',style: o.TextStyles.optikTitle),
        backgroundColor: o.Colors.optikWhite,)),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 8.0,),
          Row(children: <Widget>[Expanded(child:Divider(indent: 8.0,endIndent: 8.0)),Text("Bilgilerim",style: o.TextStyles.optikBody1,),Expanded(child:Divider(indent: 8.0,endIndent: 8.0))]),
          Column(
            mainAxisSize: MainAxisSize.min,
            children:[for (var i in settingsList) i[2] ? GestureDetector(child:Container(
              margin: EdgeInsets.symmetric(horizontal:8.0,vertical: 4.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: o.Colors.optikBlue,
                border: Border.all(width: 1.0,color: o.Colors.optikBorder),
                borderRadius: BorderRadius.all(Radius.circular(4.0 )),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(i[0],style: o.TextStyles.optikBody1White,),
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*2/3),
                    child:AutoSizeText(i[1]==null?'-':i[1],style: o.TextStyles.optikBody1BoldWhite,))
              ])),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  i[3],
                  arguments: args['user']
                );
              },
            ):
            Container(
            margin: EdgeInsets.symmetric(horizontal:8.0,vertical: 4.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: o.Colors.optikLightGray,
              border: Border.all(width: 1.0,color: o.Colors.optikBorder),
              borderRadius: BorderRadius.all(Radius.circular(4.0 )),
            ),
            child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(i[0],style: o.TextStyles.optikBody1,),
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*2/3),
                  child:AutoSizeText(i[1]==null?'-':i[1],style: o.TextStyles.optikBody1Bold,textAlign: TextAlign.right,))
              ]
            )
          ),
          // CIKARILDI. V2DE EKLENEBILIR
          /* Row(children: <Widget>[Expanded(child:Divider(indent: 8.0,endIndent: 8.0)),Text("Uygulama Hakkında",style: o.TextStyles.optikBody1,),Expanded(child:Divider(indent: 8.0,endIndent: 8.0))]),
          Wrap(
            children:
              [for (var i in aboutList) GestureDetector(child:Container(
                width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.width/4,
                margin: EdgeInsets.symmetric(horizontal:8.0,vertical: 4.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: o.Colors.optikBlue,
                  border: Border.all(width: 1.0,color: o.Colors.optikBorder),
                  borderRadius: BorderRadius.all(Radius.circular(4.0 )),
                ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      AutoSizeText(i[0],maxLines:2,style: o.TextStyles.optikBody1BoldWhite,textAlign: TextAlign.center),
                      Icon(i[1],color: o.Colors.optikWhite,)
                  ])),
              onTap: (){
                Navigator.pushNamed(
                  context,
                  i[2],
                  arguments: args
                );},
              )
              ]
          ), */
          RaisedButton(
            color: o.Colors.optikBlue,
            textColor: o.Colors.optikWhite,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login_page',(Route<dynamic> route) => false);
            },
            child: Text('Hesabımdan Çık'),
          )
          ]
      ),
          ])
    );
  }
}