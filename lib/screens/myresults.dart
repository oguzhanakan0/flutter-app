import 'package:auto_size_text/auto_size_text.dart';
import 'package:Optik/collections/globals.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/services/convert_functions.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/parentExam.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:intl/intl.dart';


class SPBArguments {
  final ParentExam parentExam;
  final String username;
  final String userID;
  final Map<dynamic,dynamic> cache;
  SPBArguments({this.parentExam,this.username, this.userID, this.cache});
}

class MyResultsPage extends StatefulWidget {
  MyResultsPage({Key key}) : super(key: key);
  @override
  _MyResultsPageState createState() => _MyResultsPageState();
}

class _MyResultsPageState extends State<MyResultsPage> {
  bool loading;
  User user;
  List<dynamic> exams;
  List<List<bool>> boolList;
  Map<dynamic,dynamic> args;
  bool noExam;
  bool reloadState;
  bool isTappable;

  @override
  void initState() {
    super.initState();  
    loading = true;
    reloadState = false;
    isTappable = true;
    /* WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context)); */
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    user = args['user'];
    if(args['cache']['MyResultsPage']!=null){
      if(args['cache']['MyResultsPage']['exams']==null){
        noExam = true;
        loading = false;
      }
      else{
        exams = args['cache']['MyResultsPage']['exams'];
        boolList = args['cache']['MyResultsPage']['boolList'];
        noExam = false;
        loading = false;
      }
    } else{
      noExam = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
    }
  }

  onAfterBuild(BuildContext context) async {
    if(loading&&mounted){
      if(!NO_INTERNET){
        try{
          args['cache']['MyResultsPage']={};
          args['cache']['MyResultsPage']['cacheTime'] = DateTime.now(); 
          exams = await fetchMyResults().then((response){
            print(response);
            if(response!=null){
              List<dynamic> res = [];
              for(var i in response){
                res.add({
                  'siralama':i['rank'],
                  'dilim':i['percentage'],
                  'puan':i['score'],
                  'parentExam':convertParentExam(i['parentExam'])
                });
              }
              return res;
            } else {
              return null;
            }
            } 
          );
          args['cache']['MyResultsPage']['exams'] = exams;
          if(exams !=null){
            boolList = getBoolList(exams);
            noExam = false;
            args['cache']['MyResultsPage']['boolList'] = boolList;
          }
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
    initializeDateFormatting();
    return reloadState?Scaffold(body:Center(child:RaisedButton(
      color: o.Colors.optikBlue,
      child: Text('İnternet bağlantısı bulunamadı. Tekrar dene.',style: o.TextStyles.optikBody1White,),
      onPressed: !isTappable?(){}:() async {
        setState(() {
          isTappable = false;
        });
        await onAfterBuild(context);
      },
      ))):loading?Loading(negative: true):Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios,color: o.Colors.optikBlack,),
                onPressed: () {Navigator.of(context).pop();},
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          backgroundColor: o.Colors.optikWhite,
          title: Text("Geçmiş Sınavlarım",
            style:o.TextStyles.optikBoldTitle)
        ),
      body:noExam?
        Center(child:Text('Şu ana kadar bir tam sınava girmediniz. Sınav bitirdikçe bu ekranda sonuçlarınızı görebilirsiniz.',
          style: o.TextStyles.optikBody1Bold,
          textAlign: TextAlign.center,)):
        ListView.builder(
          itemCount: exams.length,
          itemBuilder: (context, exam) {
            return ParentExamItem(
                username: user.username,
                dilim: exams[exam]['dilim'],
                siralama: exams[exam]['siralama'],
                puan: exams[exam]['puan'],
                preferredArea: user.areaChoice,
                parentExam: exams[exam]['parentExam'],
                boolList: boolList[exam]
              );
            },
          )
    );
  }
}

class MyResults extends StatelessWidget {
  const MyResults({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyResultsPage(key: key);
  }
}

class ExpandButton extends StatefulWidget {
  final ParentExam parentExam;
  ExpandButton(this.parentExam);
  @override
  _ExpandButtonState createState() => _ExpandButtonState();
}

class _ExpandButtonState extends State<ExpandButton> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: o.Colors.optikBlue,
        /* border: Border.all(), */
        borderRadius: BorderRadius.circular(4.0)
      ),
      height: 100.0,
      width: 60.0,
      margin: EdgeInsets.all(4.0),
      child:Center(child:Text('Detay\nGöster',style: o.TextStyles.optikBody1BoldWhite)) 
    );
  }
}

class ParentExamItem extends StatelessWidget {
  final ParentExam parentExam;
  final String username;
  final String preferredArea;
  final double puan;
  final int siralama;
  final double dilim;
  final List<bool> boolList;
  const ParentExamItem({
    @required this.username,
    @required this.preferredArea,
    @required this.parentExam,
    @required this.siralama,
    @required this.puan,
    @required this.dilim,
    @required this.boolList
  });

  @override
  Widget build(BuildContext context) {
    Map<dynamic,dynamic> args = ModalRoute.of(context).settings.arguments;
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: o.Colors.optikWhite,
        border: Border.all(width: 1.0,color: o.Colors.optikBorder),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(left:8.0,right:8.0,top:4.0,bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
          [Expanded(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(DateFormat('d MMMM yyyy','tr').format(parentExam.examStartDate.toLocal())+ ' - '+
                     DateFormat('d MMMM yyyy','tr').format(parentExam.examEndDate.toLocal()),
                    style: o.TextStyles.optikSubTitle),
                Text(parentExam.parentExamName,style: o.TextStyles.optikBody1Bold),
                Divider(height: 4.0, thickness: .25,color: o.Colors.optikBorder, endIndent: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    StatBox(
                      header:preferredArea,
                      val:puan.toStringAsFixed(2),
                      isBetter:boolList[0],
                      width:width/6),
                    StatBox(
                      header:'Derece',
                      val:siralama.toString(), 
                      isBetter:boolList[1],
                      width:width/6),
                    StatBox(
                      header:'Dilim',
                      val:'%'+dilim.toStringAsFixed(2),                   
                      isBetter:boolList[2],
                      width:width/6)
                  ]
                )
              ]
            )
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/spb', arguments: SPBArguments(
                parentExam: parentExam,
                username: username,
                userID: args['user'].id,
                cache:args['cache'],
              ));
            },
            child:Align(alignment: Alignment.topRight,child:ExpandButton(parentExam)))
        ]
      )
    );
  } 
}

class StatBox extends StatelessWidget {
  final String header;
  final String val;
  final bool isBetter; 
  final double width;
  const StatBox({
    this.header,
    this.val,
    this.isBetter,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    var _icon = isBetter==null ? 
      Icon(Icons.arrow_forward,color:o.Colors.optikHistogram4,size: 16,) :
        isBetter?
          Icon(Icons.arrow_upward,color: o.Colors.optikGreen,size: 16) : 
            Icon(Icons.arrow_downward, color: o.Colors.optikHistogram1,size: 16);
    return Container(
      constraints: BoxConstraints(minHeight: 52.0,maxWidth: width),
      margin:EdgeInsets.only(top:4,left:8,right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          AutoSizeText(header,maxLines:1,style: o.TextStyles.optikSubTitle),
          Row(children:[
            Container(
              constraints: BoxConstraints(maxWidth: width*3/5),
              child:AutoSizeText(val,maxLines:1,style: o.TextStyles.optikBoldTitle,minFontSize: 10,)),
            _icon
            ]
          )
        ]
      )
    );
  }
  
}

List<List<bool>> getBoolList(var exams) {
  List<List<bool>> boolList = [];
  for (int i=0;i<exams.length-1;i++) {
    List<bool> thisBoolList = [];
    if(double.parse(exams[i]['puan'].toStringAsFixed(2))>
        double.parse(exams[i+1]['puan'].toStringAsFixed(2))){
      thisBoolList.add(true);
    } else if (double.parse(exams[i]['puan'].toStringAsFixed(2))==
        double.parse(exams[i+1]['puan'].toStringAsFixed(2))) {
      thisBoolList.add(null);
    } else {
      thisBoolList.add(false);
    }
    if(exams[i]['siralama']<exams[i+1]['siralama']){
      thisBoolList.add(true);
    } else if (exams[i]['siralama']==exams[i+1]['siralama']) {
      thisBoolList.add(null);
    } else {
      thisBoolList.add(false);
    }
    if(double.parse(exams[i]['dilim'].toStringAsFixed(2))<
        double.parse(exams[i+1]['dilim'].toStringAsFixed(2))){
      thisBoolList.add(true);
    } else if (double.parse(exams[i]['dilim'].toStringAsFixed(2))==
        double.parse(exams[i+1]['dilim'].toStringAsFixed(2))) {
      thisBoolList.add(null);
    } else {
      thisBoolList.add(false);
    }
    boolList.add(thisBoolList);
  }
  boolList.add([null,null,null]);
  return boolList;
}
