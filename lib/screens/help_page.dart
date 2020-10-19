
import 'package:Optik/services/post_functions.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/widgets/loading.dart';
import 'package:Optik/widgets/signup_sonraki_button.dart';
import 'package:overlay_support/overlay_support.dart';

class HelpPage extends StatefulWidget {
  final state = _HelpPageState();

  HelpPage({Key key}) : super(key: key);
  @override
  _HelpPageState createState() => state;
  /* bool isValid() => state.validate(); */
}

class _HelpPageState extends State<HelpPage> {
  String choice;
  String request;
  bool sending;
  @override
  void initState() {
    super.initState();
    sending = false;
  }

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context).settings.arguments;
    return Stack(children:[Scaffold(
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
        title:Text('Nasıl Kullanılır?',style: o.TextStyles.optikTitle),
        backgroundColor: o.Colors.optikWhite,)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal:12.0,vertical: 12.0),
          child: ListView(children:[
            Text("""Destek almak istediğiniz konuyu aşağıdaki alana yazabilirsiniz.""",style: o.TextStyles.optikBody1,textAlign: TextAlign.center),
            SizedBox(height: 8.0,),
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder(
              borderSide: BorderSide(),
              )),
              keyboardType: TextInputType.multiline,
              minLines: 10,
              maxLines: null,
              onChanged: (value){
                setState(() {
                  request = value;
                });
              },
            ),
            SizedBox(height: 8.0,),
            Text("Sizinle nasıl iletişime geçelim?",style: o.TextStyles.optikBody1,textAlign: TextAlign.center),
            Center(child:DropdownButton<String>(
              value: choice,
              icon:Icon(Icons.arrow_downward,color: o.Colors.optikBlack),
              elevation: 16,
              hint: Text('Seçiniz *',style: o.TextStyles.optikBody1,),
              underline: Text(''),
              onChanged: (String newValue) {
                setState(() {
                  choice = newValue;
                });
              },
              items: ['Telefon','Email'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style: o.TextStyles.optikBody1,),
                );
              }).toList(),
            )),
            SizedBox(height: 150)
            
          ]
        )
      ),
      bottomSheet:SignupSonrakiButton(
        title: 'Gönder',
        color: o.Colors.optikBlue,
        onPressed:() async {
          if(choice==null){
            showDialog (
              context: context,
              builder: (BuildContext context) {
                return AlertDialog (
                  title: Text("Uyarı",style: o.TextStyles.optikBody1Bold,),
                  content: Text("Bir iletişim kanalı seçmelisiniz",style: o.TextStyles.optikTitle,)
                );
              }
            );
          } else if (request==null){
            showDialog (
              context: context,
              builder: (BuildContext context) {
                return AlertDialog (
                  title: Text("Uyarı",style: o.TextStyles.optikBody1Bold,),
                  content: Text("Metin kısmı boş olmamalı",style: o.TextStyles.optikTitle,)
                );
              }
            );
          } else{
            setState(() {
              sending=true;
            });
            await Future.delayed(Duration(seconds: 1));
            bool res = await sendHelpMessage(username:args['user'].username, message:request, contactChoice:choice);
            showSimpleNotification(
              Text(res?"Destek isteğin alındı. Optik App ekibi en kısa zamanda seninle iletişime geçecek.":"Destek isteğini alırken bir hata oluştu. Lütfen daha sonra tekrar",
              style: o.TextStyles.optikBody1White),
              background: o.Colors.optikBlue,
              autoDismiss: true,
            );
            if(res){
              Navigator.pop(context);
            } else{
              setState(() {
                sending = false;
              });
            }
            
          }

        }
        )
      ),
      sending?Loading(negative:true,transparent:true,opacity:0.5):SizedBox()
      ]  
    );
  }
}