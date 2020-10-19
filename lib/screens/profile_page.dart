/* import 'package:image_picker_modern/image_picker_modern.dart'; */
/* import 'package:image_picker_modern/image_picker_modern.dart'; */
import 'package:Optik/collections/globals.dart';
import 'package:Optik/services/convert_functions.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:Optik/collections/exam.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/models/spb.dart';
import 'package:Optik/widgets/parentExamName_container.dart';
/* import 'package:image_picker/image_picker.dart'; */
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/collections/topic_map.dart' as map;
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);  
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /* File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  } */

  /* Future<File> imageFile;
 
 //Open gallery
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  } */

  /* Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(
            snapshot.data,
            width: 300,
            height: 300,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  } */

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    final Map<dynamic,dynamic> args = ModalRoute.of(context).settings.arguments;
    print(args['user']);
    return ListView(
      children: [Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ProfileWidget(
                ppUrl: 'df',
                username: args['user'].username,
                userHighSchool: args['user'].displaySchoolName,
                avatarIndex: args['user'].avatarIndex
              ),
              Divider(height:0.0,thickness: 1.0),
              BuHaftaWidget(user:args['user'],cache:args['cache']),
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                width: MediaQuery.of(context).size.width -16.0,
                height: 60.0,
                decoration: BoxDecoration(
                  /* color: o.Colors.optikBlue, */
                  border: Border.all(width: 4.0,color: o.Colors.optikBlue),
                  borderRadius: BorderRadius.all(Radius.circular(16.0 )),
                ),
                child:FlatButton(
                  child: Text('Geçmiş\nDeneme Sınavlarım',style: o.TextStyles.optikBody1Bold,textAlign: TextAlign.center,),
                  onPressed: (){  
                    Navigator.pushNamed(
                      context,
                      '/myresults',
                      arguments: {'user':args['user'],'cache':args['cache']}
                      );},
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width -16.0,
                height: 60.0,
                decoration: BoxDecoration(
                  border: Border.all(width: 4.0,color: o.Colors.optikBlue),
                  borderRadius: BorderRadius.all(Radius.circular(16.0 )),
                ),
                child:FlatButton(
                  child: Text('Çözdüğüm\nDeneme Soruları',style: o.TextStyles.optikBody1Bold,textAlign: TextAlign.center,),
                  onPressed: (){
                    Navigator.pushNamed(
                      context,
                      '/deneme_sorulari_stats',
                      arguments: {'user':args['user'],'cache':args['cache']}
                    );},
                )
              )
            ],
          ),
        ),
      ]
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String username;
  final String userHighSchool;
  final String ppUrl;
  final int avatarIndex;
  const ProfileWidget({
    @required this.username,
    this.ppUrl,
    this.userHighSchool,
    this.avatarIndex=0
  });
  
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(Image(image:AssetImage(o.avatarMap[avatarIndex].path),height: 90));
    children.add(Text(username,style: o.TextStyles.optikBoldTitle));
    if(userHighSchool!=null){
      children.add(Text(userHighSchool,style: o.TextStyles.optikSubTitle,textAlign: TextAlign.center,));
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.all(Radius.circular(4.0)),
      ),
      margin: EdgeInsets.only(left:8.0,right:8.0, top:8.0),
      padding: EdgeInsets.only(bottom: 8.0),
      child:Column(
        children:children
      )
    );
  }
}

class ThisExamButton extends StatelessWidget {
  final double leftMargin;
  final double rightMargin;
  final double topMargin;
  final double bottomMargin;
  final Function onPressed;
  final String topic;
  final DateTime examDate;
  final Color color;
  final String examID;
  final double width;
  const ThisExamButton({
    this.examID,
    this.color,
    this.examDate,
    this.topic,
    this.width,
    this.leftMargin = 2.0,
    this.rightMargin = 2.0,
    this.topMargin = 2.0,
    this.bottomMargin = 2.0,
    this.onPressed,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      width: width,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Text(DateFormat('d MMMM','tr').format(examDate.toLocal()),style: o.TextStyles.optikBody2),
          Text(DateFormat('EEEE','tr').format(examDate.toLocal()),style: o.TextStyles.optikBody2Bold),
          SizedBox(height: 4.0,),
          Container(
            height: width*2/3,
            child:FlatButton(
              disabledColor: o.Colors.optikContainerBg,
              padding:EdgeInsets.all(0.0),
              color:color,
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              onPressed: onPressed,
              child: onPressed==null ? Text(topic,style: o.TextStyles.optikTitle):Text(topic,style: o.TextStyles.optikWhiteTitle)
            )
          )
        ]
      )
    );
  }
}

class BuHaftaWidget extends StatefulWidget {
  final User user;
  final Map<dynamic,dynamic> cache;
  const BuHaftaWidget({this.user,this.cache});
  @override
  _BuHaftaWidgetState createState() => _BuHaftaWidgetState();
}

class _BuHaftaWidgetState extends State<BuHaftaWidget> {
  bool loading;
  User user;
  String parentExamName;
  List<Exam> examList;
  Map<dynamic,dynamic> args;
  bool reloadState;
  bool isTappable;

  @override
  void initState() {
    super.initState();  
    loading = true;
    reloadState = false;
    isTappable = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    parentExamName = args['cache']['todaysExam'].parentExamName;
    if(args['cache']['ProfilePage']!=null){
      examList = args['cache']['ProfilePage']['examList'];
      loading = false;
    } else{
      loading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
    }
  }

  onAfterBuild(BuildContext context) async {
  if(loading&&mounted){
    if(!NO_INTERNET){
      try{
        args['cache']['ProfilePage']={};
        args['cache']['ProfilePage']['cacheTime'] = DateTime.now();
        examList = await fetchExam(forCurrentParentExam: true, parentExamName: args['cache']['todaysExam'].parentExamName).then((response){
        List<Exam> res = [];
          for(var i in response){
            res.add(convertExam(i));
          }
          return res;
        });
        args['cache']['ProfilePage']['examList'] = examList;
        if(mounted){
          setState(() {
            loading=false;
            reloadState = false;
          });
        }
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

  @override
  Widget build(BuildContext context) {
    return reloadState?Center(child:RaisedButton(
      color: o.Colors.optikBlue,
      child: Text('İnternet bağlantısı bulunamadı. Tekrar dene.',style: o.TextStyles.optikBody1White,),
      onPressed: !isTappable?(){}:() async {
        setState(() {
          isTappable = false;
        });
        await onAfterBuild(context);
      },
      )):loading?Loading(negative: true):Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0,color: o.Colors.optikGray),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      width: double.infinity,
      child:
        Column(
          children:[
            Container(
              margin: EdgeInsets.only(top:4.0,bottom: 4.0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(width: 4.0,), 
                      Icon(Icons.timelapse),
                      Text('Şu Anki Sınav',style: o.TextStyles.optikBody2Bold)
                    ]),
                  ParentExamNameContainer(parentExamName),
                ]
              )
            ),
            Divider(height: 0.0,thickness:1.0,color: o.Colors.optikGray,),
            Wrap(
              /* mainAxisAlignment: MainAxisAlignment.spaceEvenly, */
              children: [for (Exam i in examList) ThisExamButton(
                examID: i.id,
                examDate: i.examDate,
                topic: i.topic,
                onPressed: DateTime.now().add(Duration(milliseconds: timeOffset))
                  .difference(i.examDate).inMinutes <= 30 ? null: (){
                  Navigator.pushNamed(
                    context,
                    '/spa', 
                    arguments: SPAArguments(
                      parentTopic: i.parentTopic,
                      parentExamName: parentExamName,
                      examDate: i.examDate,
                      examID: i.examID,
                      topic: i.topic,
                      isExam: true,
                      cache: widget.cache,
                      userID: widget.user.id,
                    )
                  );
                },
                color: map.colorMap[i.topic],
                width: MediaQuery.of(context).size.width/(examList.length/2+.75),
              )]
            ),
            ]
        )
    );
  }
}