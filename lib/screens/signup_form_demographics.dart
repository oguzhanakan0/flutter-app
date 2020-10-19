import 'package:Optik/widgets/unsearchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:Optik/widgets/signup_appbar.dart';
import 'package:Optik/widgets/signup_sonraki_button.dart';
import 'package:Optik/models/theme.dart' as o;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:Optik/services/post_functions.dart';


Future<List<dynamic>> parseJsonFromAssets(String assetsPath) async {
  print('--- Parse json from: $assetsPath');
  return rootBundle.loadString(assetsPath)
      .then((jsonStr) => jsonDecode(jsonStr));
}

class SignupFormDemographics extends StatefulWidget {
  SignupFormDemographics({Key key}) : super(key: key);
  @override
  _SignupFormDemographicsState createState() => _SignupFormDemographicsState();
}

class _SignupFormDemographicsState extends State<SignupFormDemographics> {
  bool _isOtherSchoolVisible;
  List<String> allItems;
  String dropdownValueGrade;
  String dropdownValueCity;
  bool loading = false;
  bool _visible;
  bool _disappear;
  User user;
  String userNameToBe;
  bool fixUsername;
  int selectedAvatarIndex;

  
  @override
  void initState() {
    super.initState();
    _visible = true;
    _disappear = false;
    fixUsername = true;
    selectedAvatarIndex = 0;
    fadeOut();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    user = ModalRoute.of(context).settings.arguments;
    if(fixUsername){
      String suggestedUsername = user.email.substring(0,user.email.indexOf('@'));
      if(suggestedUsername.length>15){
        suggestedUsername = suggestedUsername.substring(0,14);
      } else if (suggestedUsername.length < 4) {
        for(int i=0;i<(5-suggestedUsername.length);i++){
          suggestedUsername += '9';
        }
      }
      userNameToBe = suggestedUsername; 
    }
    setState(() {
      fixUsername = false;
    });
  }
  void fadeOut() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _visible = false;
    });
    await Future.delayed(Duration(milliseconds: 250));
    setState(() {
      _disappear = true;
    });
    print('visible set to false now');
  }

  final form = GlobalKey<FormState>();
  List<String> grades = ['Mezun','12. Sınıf','11. Sınıf','10. Sınıf', '9. Sınıf'];
  @override
  Widget build(BuildContext context) {
    user.schoolName=='Diğer'?_isOtherSchoolVisible=true:_isOtherSchoolVisible=false;
    return Stack(children:[Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: SignupAppBar(automaticallyImplyLeading: false),
        body: ListView(children:[Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child:Form(key:form,autovalidate:true,child:Column(
          children: <Widget>[
            Row(children:[
              GestureDetector(
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  selectedAvatarIndex = 
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => UnsearchableDropdown(allItems:o.avatarMap))) ?? 0;
                  user.avatarIndex = selectedAvatarIndex;
                  setState(() {
                    loading = false;
                  });
                },
                child: Container(margin:EdgeInsets.only(top:8.0,right:8.0),
                  child:Image(image:AssetImage(o.avatarMap[selectedAvatarIndex].path),height: 60))
              ),
              Expanded(child:TextFormField(
                style: o.TextStyles.optikTitle,
                onChanged: (String value){
                  setState(() {
                    userNameToBe = value;
                  });
                },
                initialValue: userNameToBe,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı *',
                  labelStyle: o.TextStyles.optikTitle,
                  isDense: true,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Kullanıcı adı alanı boş olmamalı';
                  } else if (value.length<4 || value.length>15){
                    return 'Kullanıcı adı en az 4, en fazla 15 karakter içerebilir';
                  }
                  return null;
                },
              ))
            ]),
            TextFormField(
              style: o.TextStyles.optikTitle,
              decoration: InputDecoration(
                labelText: 'Adınız',
                labelStyle: o.TextStyles.optikTitle,
                alignLabelWithHint: true,
              ),
              onChanged: (value){
                user.firstName = value;
              },
            ),
            TextFormField(
              style: o.TextStyles.optikTitle,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Soyadınız',
                labelStyle: o.TextStyles.optikTitle,
              ),
              onChanged: (value){
                user.lastName = value;
              },
            ),
            SizedBox(height: 12.0,),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownValueGrade,
              icon:Icon(Icons.arrow_downward,color: o.Colors.optikBlack),
              elevation: 16,
              hint: Text('Sınıfınız',style: o.TextStyles.optikTitle,),
              underline: Text(''),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValueGrade = newValue;
                  user.grade = newValue;
                });
              },
              items: ['Mezun','12. Sınıf','11. Sınıf', '10. Sınıf','9. Sınıf'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style: o.TextStyles.optikTitle,),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownValueCity,
              icon:Icon(Icons.arrow_downward,color: o.Colors.optikBlack),
              elevation: 16,
              hint: Text('Liseyi okuduğunuz şehir',style: o.TextStyles.optikTitle,),
              underline: Text(''),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValueCity = newValue;
                  user.city = newValue;
                });
              },
              items: ['Adana','Adıyaman','Afyonkarahisar','Ağrı','Aksaray','Amasya','Ankara','Antalya','Ardahan','Artvin','Aydın','Balıkesir','Bartın','Batman','Bayburt','Bilecik','Bingöl','Bitlis','Bolu','Burdur','Bursa','Çanakkale','Çankırı','Çorum','Denizli','Diyarbakır','Düzce','Edirne','Elazığ','Erzincan','Erzurum','Eskişehir','Gaziantep','Giresun','Gümüşhane','Hakkari','Hatay','Iğdır','Isparta','İstanbul','İzmir','Kahramanmaraş','Karabük','Karaman','Kars','Kastamonu','Kayseri','Kilis','Kırıkkale','Kırklareli','Kırşehir','Kocaeli','Konya','Kütahya','Malatya','Manisa','Mardin','Mersin','Muğla','Muş','Nevşehir','Niğde','Ordu','Osmaniye','Rize','Sakarya','Samsun','Şanlıurfa','Siirt','Sinop','Şırnak','Sivas','Tekirdağ','Tokat','Trabzon','Tunceli','Uşak','Van','Yalova','Yozgat','Zonguldak'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style: o.TextStyles.optikTitle,),
                );
              }).toList(),
            ),
            GestureDetector(
              onTap: () async{
                setState(() {
                  loading = true;
                });
                allItems = ['Diğer'];
                dynamic dmap = await parseJsonFromAssets('assets/cfg/schoolList_beautified.json');
                for(var i in dmap){
                  if(i['city']==user.city){
                    allItems.add(i['name']);
                  }
                }
                await Navigator.pushNamed(context, 
                  '/signup_demographics_dropdown',
                  arguments: {'allItems':allItems,'user':user});
                
                setState(() {
                  loading = false;
                });
                
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(width:MediaQuery.of(context).size.width*2/3,
                    child:Text(user.schoolName==null?'Liseniz':user.schoolName
                      ,style: o.TextStyles.optikTitle)),
                    Icon(Icons.arrow_downward)
                  ]
                ),
              )
            ),
            Visibility(
              visible: _isOtherSchoolVisible,
              child: TextFormField(
                style: o.TextStyles.optikTitle,
                decoration: InputDecoration(
                  labelText: 'Liseniz (Diğer)',
                  labelStyle: o.TextStyles.optikTitle,
                ),
                onChanged: (value){
                  user.schoolName = 'Diğer';
                  user.displaySchoolName = value;
                },
              ),),
            SizedBox(height:40),
            Text('*Lisenizi kayıt olduktan sonra değiştiremeyeceksiniz, lütfen lisenizi doğru bir şekilde bularak seçin. Lisenizi bulamazsanız "Diğer" tuşuna basarak elle girebilirsiniz.', 
              style: o.TextStyles.optikBody1.copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,),
        ]))),
      ]
      ),
      bottomSheet:SignupSonrakiButton(
        onPressed:() async {
          
          if (form.currentState.validate()) {
            setState(() {
              loading = true;
            });
            if(user.displaySchoolName==null){
              user.displaySchoolName = 'Diğer';
            }
            bool res = await isUsernameAvailable(username:userNameToBe);
            if(res){
              user.username = userNameToBe;
              print("username on demographics page:"+user.username);
              Navigator.pushNamed(context, '/signup_demographics2',arguments: user);
            }
            setState(() {
              loading = false;
            });
            
          }
        }
      )
    ),
    loading?Loading(negative: true,transparent: true,opacity: 0.5):SizedBox(),
    _disappear?
      SizedBox():
        Scaffold(body:AnimatedOpacity(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          opacity: _visible?1:0,
          duration: Duration(milliseconds: 250),
          // The green box must be a child of the AnimatedOpacity widget.
          child: Container(
            color: o.Colors.optikBlue,
            child:Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Container(height: 60, child:Image(image: AssetImage('assets/images/logo_negative.png'))),
                  SizedBox(height: 20,),
                  Text(
                    "Optik App'e hoş geldin!\nSenden birkaç bilgi isteyeceğiz",
                    style: o.TextStyles.optikWhiteTitle,
                    textAlign: TextAlign.center,)
                ]
              )
            ),
          )
        ),
      )
    ]);
  }
}