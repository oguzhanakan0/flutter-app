import 'package:Optik/collections/globals.dart';
import 'package:Optik/services/convert_functions.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:Optik/collections/parentExam.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/models/custom_radio.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/collections/topic_map.dart' as map;
import 'package:Optik/models/histogram.dart';
import 'package:intl/intl.dart';

class LeaderboardPageOptikExam extends StatefulWidget {
  LeaderboardPageOptikExam({Key key}) : super(key: key);  
  @override
  State<LeaderboardPageOptikExam> createState() => _LeaderboardPageOptikExamState();
}

class _LeaderboardPageOptikExamState extends State<LeaderboardPageOptikExam> {
  dynamic katilimciSayisi;
  dynamic examRankings2;
  dynamic schoolRankings;
  dynamic examHistogramData2;
  dynamic userBuckets;
  dynamic netler = {};
  Map<dynamic,dynamic> args;
  ParentExam parentExam;
  ShowData showData;
  bool loading;
  User user;
  bool noPreviousParentExamExists;
  bool reloadState;
  bool isTappable;

  @override
  void initState() {
    super.initState();
    loading = true;
    noPreviousParentExamExists = true;
    reloadState = false;
    isTappable = true;
    /* WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context)); */
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    user = args['user'];
    if(args['cache']['LeaderBoardPageOptikExam']!=null){
      if(args['cache']['LeaderBoardPageOptikExam']['noPreviousParentExamExists']!=null) {
        if(!args['cache']['LeaderBoardPageOptikExam']['noPreviousParentExamExists']){
          showData = args['cache']['LeaderBoardPageOptikExam']['showData'];
          noPreviousParentExamExists = false;
          loading = false;
        } else {
          noPreviousParentExamExists = true;
          loading = false;
        }
      } else{
        loading = true;
        WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
      }
    } else{
      loading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return reloadState?Center(child:RaisedButton(
      color: o.Colors.optikBlue,
      child: Text('İnternet bağlantısı bulunamadı. Tekrar dene.',style: o.TextStyles.optikBody1White,),
      onPressed: !isTappable?(){}:() async {
        setState(() {
          isTappable = false;
        });
        await onAfterBuild(context);
      },
    )):loading?
      Loading(negative: true,transparent:true,opacity:0.0):
        noPreviousParentExamExists?
          Center(child:Text("Bu serideki tüm sınavlar bittiğinde istatistikleri bu ekranda görebilirsin.")):
            ListView(
              children: <Widget>[
                ExamHeader(examName:showData.examName,examDate:showData.examDate),
                PuanTuruSecenekleri(showData),
              ]
            );
  }

  // ROUTE'TAN GELEN FORMATI DONUSTURMEK ICIN KULLANILIYOR
  dynamic convertBucketsFrom(dynamic nets){
    dynamic userBuckets = {};
    dynamic tytTopics = map.topicMap['TYT'].keys;
    double tytSum = 0;
    for (var i in tytTopics){
      tytSum += nets[i];
    }
    for (var i in map.aytLists.keys){
      userBuckets[i] = tytSum;
      if(i!="TYT"){
        for (var j in map.aytLists[i]){
          userBuckets[i] += nets[j];
        }
      }
      userBuckets[i] ={"Genel": (((userBuckets[i]/10).floor())*10).toString() };
    }
    return userBuckets;
  }

  dynamic combineRankings(dynamic personalRank, dynamic generalRank){
    for (var i in generalRank.keys){
      bool add = true;
      for (var j in generalRank[i]){
        if(j!=null){
          if(j[1]==personalRank[i][1]){
            add = false;
          }
        }
      }
      if(add){
        generalRank[i].add(personalRank[i]);
      }
    }
    return generalRank;
  }

  dynamic convertHistogramData({dynamic netDistribution, String defaultString = "Genel"}){
    dynamic res = {};
    for (var i in netDistribution.keys){
      res[i]={};
      res[i][defaultString] = netDistribution[i];
    }
    return res;
  }

  onAfterBuild(BuildContext context) async {
    if(loading&&mounted){
      if(!NO_INTERNET){
        try{
          args['cache']['LeaderBoardPageOptikExam']={};
          args['cache']['LeaderBoardPageOptikExam']['cacheTime'] = DateTime.now();
          dynamic responseGeneral = await fetchLeaderBoardOptikExamGeneralStats();
          if(responseGeneral!=null){
            dynamic responsePersonal = await fetchLeaderBoardOptikExamPersonalStats();
            parentExam = convertParentExam(responseGeneral['parentExam']);
            katilimciSayisi = responseGeneral['nParticipants'];
            examRankings2 = combineRankings(responsePersonal['examRank'], responseGeneral['examRank']);
            netler['user'] = responsePersonal['nets'];
            netler['Genel'] = responseGeneral['nets'];
            userBuckets = convertBucketsFrom(netler['user']);
            for (var i in netler.keys){
              for (var j in netler[i].keys){
                netler[i][j] = netler[i][j].toStringAsFixed(2);
              }
            }
            netler['user']["-"] = "-";
            netler['Genel']["-"] = "-";
            schoolRankings = combineRankings(responsePersonal['schoolRank'], responseGeneral['schoolRank']);
            dynamic fixedHistogramData = convertHistogramData(netDistribution:responseGeneral['netDistribution']);
            examHistogramData2 = {};
            for (var i in fixedHistogramData.keys){
              examHistogramData2[i] = {};
              for (var j in fixedHistogramData[i].keys){
                List<OrdinalBuckets> v = [];
                for (var k in fixedHistogramData[i][j].keys){
                  v.add(OrdinalBuckets(k,fixedHistogramData[i][j][k]));
                }
                examHistogramData2[i][j] = v;
              }
            }
            showData = ShowData(
              username: user.username,
              userSchoolName: user.schoolName,
              examName:parentExam.parentExamName, // examName
              radioValue:user.areaChoice, // initial Puan Turu Secenegi
              examRankings2:examRankings2, // Puan turu bazinda 1,2,3 ve n'inci (yani kullanici)
              schoolRankings:schoolRankings,
              examHistogramData:examHistogramData2, // Histograma verilecek data
              userBuckets:userBuckets, // userin histogramda bulundugu bucket
              netler:netler, // ortalama ve userin netleri
              aytList:map.aytLists[user.areaChoice], // initial AYTlist
              katilimciSayisi:katilimciSayisi, // katilimci sayisi
              examDate:DateFormat('d MMMM','tr').format(parentExam.examStartDate)+' - '+DateFormat('d MMMM','tr').format(parentExam.examEndDate)
            );
            args['cache']['LeaderBoardPageOptikExam']['showData'] = showData;
            args['cache']['LeaderBoardPageOptikExam']['noPreviousParentExamExists'] = false;
            noPreviousParentExamExists = false;
          } else {
            args['cache']['LeaderBoardPageOptikExam']['noPreviousParentExamExists'] = true;
            noPreviousParentExamExists = true;
          }
          if(mounted){
            setState(() {
              reloadState = false;
              loading=false;
            });
          }
        } 
        catch(e){
          print(e);
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
}


class ExamHeader extends StatelessWidget {
  const ExamHeader({Key key,this.examName, this.examDate,}) : super(key: key);
  final String examName;
  final String examDate;

  @override
  Widget build(BuildContext context){
    return Container(
        margin: EdgeInsets.symmetric(vertical:6.0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Container(
              margin: EdgeInsets.symmetric(vertical: 4.0),
              /* width: 140.0, */
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                Icon(Icons.date_range),
                Text(examDate,style: o.TextStyles.optikBody2Bold)
                ]
              )
            ),
            Container(
              width: 90.0,
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: o.Colors.optikBlack,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child:Center(child:Text(examName,style: o.TextStyles.optikBody2White))),
            ]
        )
      );
  }
}


class PuanTuruSecenekleri extends StatefulWidget {
  PuanTuruSecenekleri(this.showData);
  final ShowData showData;
  @override
  State<PuanTuruSecenekleri> createState() => _PuanTuruSecenekleriState();

}

class _PuanTuruSecenekleriState extends State<PuanTuruSecenekleri> with SingleTickerProviderStateMixin {

  RadioBuilder<String, double> simpleBuilder;

  _PuanTuruSecenekleriState() {
    simpleBuilder = (BuildContext context, List<double> animValues, Function updateState, String value) {
      final alpha = (animValues[0] * 255).toInt();
      return GestureDetector(
        onTap:  () {
          setState(() {
            widget.showData.radioValue = value;
            switch(value){
              case 'EA': widget.showData.aytList = ['T2','M2']; break;
              case 'SAY': widget.showData.aytList = ['M2','F2']; break;
              case 'SÖZ': widget.showData.aytList = ['T2','S2']; break;
              case 'TYT': widget.showData.aytList = ['-','-']; break;
            }
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width*3/13,
          padding: EdgeInsets.all(4.0),
          margin: EdgeInsets.symmetric(vertical: 0.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: o.Colors.optikDarkBlue.withAlpha(alpha),
            borderRadius: BorderRadius.all(Radius.circular(4.0 )),
            border: Border.all(
              color: o.Colors.optikDarkBlue.withAlpha(255 - alpha),
              width: 1.0,
            )
          ),
          child: Text(
            value,
            style: alpha==255? o.TextStyles.optikBody1BoldWhite:o.TextStyles.optikBody1,
          )
        )
      );
    };
  }
  
  CustomRadio<String,double> createSimpleChoice(String text) {
    return CustomRadio<String, double>(
      value: text,
      groupValue: widget.showData.radioValue,
      duration: Duration(milliseconds: 150),
      animsBuilder: (AnimationController controller) => [
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut
        ),
      ],
      builder: simpleBuilder
    );
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child:Column(
        children:[Container(
          margin: EdgeInsets.only(bottom: 6.0),
          decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              createSimpleChoice('EA'),
              createSimpleChoice('SAY'),
              createSimpleChoice('SÖZ'),
              createSimpleChoice('TYT'),
            ]
          )
        ),
        Divider(height: 0.0,thickness:1.0,color: o.Colors.optikBlack,),
        LeaderBoard(widget.showData)
      ]
      )
    );
  }
}


class LeaderBoard extends StatefulWidget {
  LeaderBoard(this.showData);
  final ShowData showData;
  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  Container getTextBox(String text,[double _width, TextStyle _textStyle]){
    return Container(
      decoration: BoxDecoration(
      ),
      width: _width == null ? 40.0 : _width,
      margin: EdgeInsets.all(4.0),
      child: AutoSizeText(
        text,
        style: _textStyle== null ? o.TextStyles.optikBody2 : _textStyle,
        maxLines: 1,
        textAlign: TextAlign.center
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 4.0),
        Text(widget.showData.radioValue+'\nKatılımcı Sayısı\n'+widget.showData.katilimciSayisi[widget.showData.radioValue].toString(),style:o.TextStyles.optikBody2Bold,textAlign: TextAlign.center,),

        Container(
          margin: EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            color: o.Colors.optikWhite,
            border: Border.all(width: 1.0,color: o.Colors.optikGray),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:4.0,bottom: 2.0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Icon(Icons.person),
                  Icon(Icons.trending_up),
                  Text(widget.showData.radioValue+' Bireysel Sıralama',style: o.TextStyles.optikBody2Bold)
                ]
              )
            ),
            Divider(height: 4.0,thickness:1.0,color: o.Colors.optikGray,),
            Wrap(children:[for (var i in widget.showData.examRankings2[widget.showData.radioValue]) RankingBox(
              rank:i[0].toString(),
              userName:i[1],
              schoolName:i[2],
              score:i[3].toStringAsFixed(2),
              thisUserName: widget.showData.username,
              thisUserSchoolName:widget.showData.userSchoolName,
              )])
            ]
          )        
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            color: o.Colors.optikWhite,
            border: Border.all(width: 1.0,color: o.Colors.optikGray),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Column(children: <Widget>[
            Container(
              /* color:o.Colors.optikDarkBlue, */
              margin: EdgeInsets.only(top:4.0,bottom: 2.0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Icon(Icons.home),
                  Icon(Icons.trending_up),
                  Text(widget.showData.radioValue+' Lise Sıralaması',style: o.TextStyles.optikBody2Bold)
              ]
              )
            ),
            Divider(height: 4.0,thickness:1.0,color: o.Colors.optikGray,),
            Wrap(children:[for (var i in widget.showData.schoolRankings[widget.showData.radioValue]) RankingBox(
              rank:i==null?"-":i[0].toString(),
              schoolName:i==null?"-":i[1],
              score:i==null?"-":i[2].toStringAsFixed(2),
              thisUserSchoolName:widget.showData.userSchoolName,
              )
            ]),
            ]
          )        
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical:4.0),
          /* height:150.0, */
          decoration: BoxDecoration(
            color: o.Colors.optikWhite,
            border: Border.all(width: 1.0,color: o.Colors.optikGray),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child:Column(
            children:[
              Container(
                margin: EdgeInsets.only(top:4.0,bottom: 4.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Icon(Icons.done_all),
                    Text('Net Ortalamaları',style: o.TextStyles.optikBody2Bold)
                  ]
                )
              ),
              Divider(height: 0.0,thickness:1.0,color: o.Colors.optikGray,),
                Container(
                  margin: EdgeInsets.all(4.0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      Column(
                        children: [
                          getTextBox(''),
                          getTextBox(''),
                          getTextBox(widget.showData.username,60.0,o.TextStyles.optikBody2Bold),
                          getTextBox('Ortalama',60.0,o.TextStyles.optikBody2Bold) 
                        ] 
                      ),
                      Column(
                        children: [
                          getTextBox('TYT',null, o.TextStyles.optikBody2Bold),
                          Container(
                            decoration: BoxDecoration(
                              /* color: o.Colors.optikFen, */
                              border: Border(
                                top: BorderSide(width: 1.0, color: o.Colors.optikBorder),
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    getTextBox('T',w/12),getTextBox('M',w/12),getTextBox('S',w/12),getTextBox('F',w/12),
                                  ]
                                ),
                                Row(
                                  children: <Widget>[
                                    getTextBox(widget.showData.netler['user']['T'],w/12),
                                    getTextBox(widget.showData.netler['user']['M'],w/12),
                                    getTextBox(widget.showData.netler['user']['S'],w/12),
                                    getTextBox(widget.showData.netler['user']['F'],w/12),
                                    ]
                                ),
                                Row(
                                  children: <Widget>[
                                    getTextBox(widget.showData.netler['Genel']['T'],w/12),
                                    getTextBox(widget.showData.netler['Genel']['M'],w/12),
                                    getTextBox(widget.showData.netler['Genel']['S'],w/12),
                                    getTextBox(widget.showData.netler['Genel']['F'],w/12),
                                    ]
                                ),
                              ]
                            )
                          )
                        ] 
                      ),
                      Column(
                        children:[
                          getTextBox('AYT',null, o.TextStyles.optikBody2Bold),
                          Container(
                            decoration: BoxDecoration(
                              /* color: o.Colors.optikFen, */
                              border: Border(
                                top: BorderSide(width: 1.0, color: o.Colors.optikBorder),
                              ),
                            ),
                            child:Column(children:[
                              Row(
                                children: <Widget>[
                                  getTextBox(widget.showData.aytList[0],w/12),getTextBox(widget.showData.aytList[1],w/12)
                                  ]
                              ),
                              Row(
                                children: <Widget>[
                                  getTextBox(widget.showData.netler['user'][widget.showData.aytList[0]],w/12),
                                  getTextBox(widget.showData.netler['user'][widget.showData.aytList[1]],w/12),
                                  ]
                              ),
                              Row(
                                children: <Widget>[
                                  getTextBox(widget.showData.netler['Genel'][widget.showData.aytList[0]],w/12),
                                  getTextBox(widget.showData.netler['Genel'][widget.showData.aytList[1]],w/12),
                                  ]
                                ),
                              ]
                            )
                          )
                        ]
                      )
                    ]
                  )
                )
              ,
              Divider(height: 4.0,thickness:1.0,color: o.Colors.optikGray,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Icon(Icons.insert_chart),
                  Text('Net Dağılım Grafiği',style: o.TextStyles.optikBody2Bold)
              ]
              ),
              Divider(height: 4.0,thickness:1.0,color: o.Colors.optikGray,),
              Histogram(widget.showData,'Genel')
            ]
          )
        ),            
      ],        
    );
  }
}




class RankingBox extends StatelessWidget{
  final String rank;
  final String userName;
  final String schoolName;
  final String score;
  final String thisUserName;
  final String thisUserSchoolName;
  RankingBox({
    @required this.rank,
    @required this.schoolName,
    @required this.score,
    this.userName,
    this.thisUserName,
    this.thisUserSchoolName
  });

  
  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle;
    if(userName == thisUserName && schoolName == thisUserSchoolName){
      _textStyle = o.TextStyles.optikBody2.copyWith(color: o.Colors.optikWhite);
    } else{
      _textStyle = o.TextStyles.optikBody2;
    }
    final width = MediaQuery.of(context).size.width;
    List<Widget> _children = userName != null ? <Widget>[
      SizedBox(width: width*4/32,child:Text(rank.toString(),style:_textStyle,textAlign: TextAlign.center,)),
      SizedBox(width: width*9/32,child:AutoSizeText(userName,maxLines:1,textAlign: TextAlign.center,softWrap: true,style:_textStyle.copyWith(fontWeight: FontWeight.w600))),
      SizedBox(width: width*10/32,child:Text(schoolName,textAlign: TextAlign.center,softWrap: true,style:_textStyle)),
      SizedBox(width: width*4/32,child:Text(score,textAlign: TextAlign.center,softWrap: true,style:_textStyle)),
    ]:<Widget>[
      SizedBox(width: width/8,child:Text(rank.toString(),style:_textStyle)),
      SizedBox(width: width*7/12,child:Text(schoolName,textAlign: TextAlign.center,softWrap: true,style:_textStyle)),
      SizedBox(width: width/8,child:AutoSizeText(score,textAlign: TextAlign.center,softWrap: true,style:_textStyle)),
    ];
    return Container(
      margin: EdgeInsets.symmetric(vertical:4.0,horizontal: 4.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: (userName == thisUserName && schoolName == thisUserSchoolName) ? o.Colors.optikBlue:o.Colors.optikWhite,
        border: Border.all(width: 1.0,color: o.Colors.optikBorder),
        borderRadius: BorderRadius.all(Radius.circular(4.0 )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _children
      )
    );
  }
}