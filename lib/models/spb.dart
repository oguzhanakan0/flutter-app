
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Optik/collections/globals.dart';
import 'package:Optik/screens/myresults.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/parentExam.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/collections/topic_map.dart' as map;
import 'package:Optik/widgets/parentExamName_container.dart';
import 'package:intl/intl.dart';

class SPAArguments {
  final String parentTopic;
  final String topic;
  final DateTime examDate;
  final String parentExamName;
  final String examID;
  final String username;
  final String userID;
  final String title;
  final bool isExam;
  final Map<dynamic,dynamic> cache;
	SPAArguments({
    this.parentTopic,
    this.topic,
    this.examDate,
    this.examID,
    this.username,
    this.userID,
    this.parentExamName,
    this.cache,
    this.title = 'Test Sonucu',
    this.isExam = false
  });
}

class SPB extends StatefulWidget {
  // a property on this class
	final String username;
  final String userID;
  final ParentExam parentExam;
  
	// a constructor for this class
	SPB({this.username, this.userID, this.parentExam});
  @override
  _SPBState createState() => _SPBState();
}

class _SPBState extends State<SPB> {
  bool loading;
  Map<dynamic,dynamic> spbData;
  SPBArguments args;
  bool isVisibleTYT;
  bool isVisibleAYT;
  bool reloadState;
  bool isTappable;

  @override
  void initState() {
    super.initState();  
    loading = true;
    isVisibleTYT = true;
    isVisibleAYT = true;
    reloadState = false;
    isTappable = true;
    /* WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context)); */
  }

  void showTYT() {
    setState(() {
      isVisibleTYT = !isVisibleTYT;
    });
  }
  void showAYT() {
    setState(() {
      isVisibleAYT = !isVisibleAYT;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    if(args.cache['SPBs']!=null){
      if(args.cache['SPBs'][widget.parentExam.parentExamName]!=null){
        spbData = args.cache['SPBs'][widget.parentExam.parentExamName]['spbData'];
        loading = false;
      } else{
        loading = true;
        WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
      }} else{
        loading = true;
        args.cache['SPBs']={};
        WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
      }
  }

  dynamic fixSPBDataGeneralDetail(dynamic generalDetail){
    for (var i in generalDetail.keys){
      if(generalDetail[i].length != 4){
        generalDetail[i] = [0,0,0,0];
      }
    }
    return generalDetail;
  }

  dynamic fixSPBDataExamIDs(dynamic examIDs){
    dynamic res = {};
    for (var i in examIDs){
      res[i['topic']] = i['examID'];
    }
    return res;
  }

  onAfterBuild(BuildContext context) async {
    if(loading&&mounted){
      if(!NO_INTERNET){
        try{
          args.cache['SPBs'][widget.parentExam.parentExamName]={};
          args.cache['SPBs'][widget.parentExam.parentExamName]['cacheTime'] = DateTime.now();
          spbData = await fetchSPBData(parentExamName: widget.parentExam.parentExamName);
          spbData['generalDetail'] = fixSPBDataGeneralDetail(spbData['generalDetail']);
          spbData['examIDs'] = fixSPBDataExamIDs(spbData['examIDs']);
          args.cache['SPBs'][widget.parentExam.parentExamName]['spbData']=spbData;
          setState(() {
            loading=false;
            reloadState = false;
          });
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
	Widget build(context) {
  initializeDateFormatting();
  String dateText;
  if(widget.parentExam.examStartDate!=null){ 
    dateText = DateFormat('d MMMM','tr').format(widget.parentExam.examStartDate)+' - '+DateFormat('d MMMM yyyy','tr').format(widget.parentExam.examEndDate);
  } else {
    dateText = '';
  }
  return reloadState?Scaffold(body:Center(child:RaisedButton(
      color: o.Colors.optikBlue,
      child: Text('İnternet bağlantısı bulunamadı. Tekrar dene.',style: o.TextStyles.optikBody1White,),
      onPressed: !isTappable?(){}:() async {
        setState(() {
          isTappable = false;
        });
        await onAfterBuild(context);
      },
      ))):loading?Loading(negative: true):ListView(children:[Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0,color: o.Colors.optikGray),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      margin: EdgeInsets.all(8.0),
      width: double.infinity,
      child:
        Column(
          children:[
            Container(
              margin: EdgeInsets.only(top:4.0,bottom: 4.0),
              /* padding: EdgeInsets.all(8.0), */
              child:Container(
                padding: EdgeInsets.all(8.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Container(
                      /* width: 140.0, */
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                        Icon(Icons.date_range),
                        Text(
                          dateText,
                          style: o.TextStyles.optikBody2Bold)
                        ]
                      )
                    ),
                    ParentExamNameContainer(widget.parentExam.parentExamName)
                    ]
                )
              ),
            ),
            Divider(height: 0.0,thickness:1.0,color: o.Colors.optikGray,),
            Container(
              child:Column(
                children:[
                  Container(
                    decoration: BoxDecoration(
                      /* color:o.Colors.optikWhite, */
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    margin: EdgeInsets.all(4.0),
                    child:Column(
                      children: [
                        // GENEL SONUÇ
                        OverallResultsNumber(spbData: spbData,),
                        Divider(indent:20.0,endIndent:20.0,height: 0.0,thickness:1.0,color: o.Colors.optikBorder,),
                        SubjectOverallResult(spbData:spbData),
                        // TYT SONUÇ
                        SingleResultButton(
                          topic:'TYT',
                          onPressed:showTYT,
                          c:o.Colors.optikBlue,
                          margin:6),
                        Padding(
                          padding:EdgeInsets.symmetric(horizontal:6),
                          child:Visibility(
                            child:IndividualResultComplete(
                              username:widget.username,
                              parentExamName: widget.parentExam.parentExamName,
                              parentTopic:'TYT',
                              spbData:spbData,
                              cache:args.cache),
                            visible: isVisibleTYT,
                            maintainState: true,
                            maintainAnimation: true,
                        )),
                        // AYT SONUÇ
                        SingleResultButton(
                          topic:'AYT',
                          onPressed:showAYT,
                          c:o.Colors.optikBlue,
                          margin:6),
                        Padding(
                          padding:EdgeInsets.symmetric(horizontal:6),
                          child:Visibility(
                          child:IndividualResultComplete(
                            username:widget.username,
                            userID: widget.userID,
                            parentExamName: widget.parentExam.parentExamName,
                            parentTopic:'AYT',
                            spbData: spbData,
                            cache:args.cache),
                          visible: isVisibleAYT,
                          maintainState: true,
                        )),
                        SizedBox(height: 4.0)
                      ]
                    )
                  )
                ]
              )
            )
          ]
        ))]);
	}
}


class IndividualResultComplete extends StatelessWidget {
  const IndividualResultComplete({this.padding=2, this.cache,this.spbData, this.username, this.userID,this.parentTopic,this.parentExamName,this.examDate});
  final double padding;
  final String username;
  final String userID;
  final Map<dynamic,dynamic> spbData;
  final String parentTopic;
  final String parentExamName;
  final DateTime examDate;
  final Map<dynamic,dynamic> cache;

  TableRow getSubjectIndividualResult(
    String username,
    String userID, 
    String examID, 
    String topic,
    String parentTopic,
    String parentExamName,
    DateTime examDate,
    NavigatorState nav){
      List<dynamic> stats = spbData['specificDetail'][topic];
      NumberFormat percentageFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);
    return TableRow(
      children: [
        SingleResultButton(
          topic:topic,
          onPressed:(){
              print(examID);
              print(spbData['examIDs']);
              nav.pushNamed('/spa', arguments: SPAArguments(
                parentTopic: parentTopic,
                parentExamName: parentExamName,
                examID: examID,
                examDate: examDate,
                topic: topic,
                isExam: true,
                username: username,
                userID: userID,
                cache: cache,
              )
            );
          },
          c:map.colorMap[topic]),
        Center(heightFactor: 1.3,child:Text(stats.length==0?"-":stats[0].toString(),style: o.TextStyles.optikBody1)),
        Center(heightFactor: 1.3,child:Text(stats.length==0?"-":stats[1].toString(),style: o.TextStyles.optikBody1)),
        Center(heightFactor: 1.3,child:Text(stats.length==0?"-":stats[2].toString(),style: o.TextStyles.optikBody1)),
        Center(heightFactor: 1.3,child:Text(stats.length==0?"-":stats[3].toString(),style: o.TextStyles.optikBody1)),
        Center(heightFactor: 1.3,child:Text(stats.length==0?"-":stats[4].toString(),style: o.TextStyles.optikBody1)),
        Center(heightFactor: 1.3,child:Text(stats.length==0?"-":percentageFormat.format(stats[5]),style: o.TextStyles.optikBody1)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState nav = Navigator.of(context);
    List<String> topicList = parentTopic == 'TYT' ? ['T','M','S','F'] : ['T2','M2','S2','F2'];
    List<TableRow> _children = [TableRow(
          children: [
            Padding(padding:EdgeInsets.symmetric(vertical:padding),child:Center(child:Text(''))),
            Padding(padding:EdgeInsets.symmetric(vertical:padding),child:Center(child:Text('Doğru',style: o.TextStyles.optikBody2Bold))),
            Padding(padding:EdgeInsets.symmetric(vertical:padding),child:Center(child:Text('Yanlış',style: o.TextStyles.optikBody2Bold))),
            Padding(padding:EdgeInsets.symmetric(vertical:padding),child:Center(child:Text('Boş',style: o.TextStyles.optikBody2Bold))),
            Padding(padding:EdgeInsets.symmetric(vertical:padding),child:Center(child:Text('Sıralama',style: o.TextStyles.optikBody2Bold))),
            Padding(padding:EdgeInsets.symmetric(vertical:padding),child:Center(child:Text('Katılan',style: o.TextStyles.optikBody2Bold))),
            Padding(padding:EdgeInsets.symmetric(vertical:padding),child:Center(child:Text('Dilim',style: o.TextStyles.optikBody2Bold))),
        ])];
    _children.addAll([for (var i in topicList) getSubjectIndividualResult(
      username,
      userID,
      spbData['examIDs'][i],
      i,
      parentTopic,
      parentExamName,
      examDate,
      nav
    )]);
    return Table(children: _children);
  }
}

class SingleResultButton extends StatelessWidget{
  const SingleResultButton({this.topic,this.onPressed,this.c,this.margin=2,this.height=24});
  final String topic;
  final Function onPressed;
  final Color c;
  final double margin;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      width: double.infinity,
      height: height,
      child:FlatButton(
        color:c,
        disabledColor: o.Colors.optikButton1Disabled,
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onPressed: onPressed,
        child:AutoSizeText(topic,style: o.TextStyles.optikBody1White,textAlign: TextAlign.center,minFontSize: 6,maxLines: 1)
        )
    );
  }
}

class SubjectOverallResult extends StatelessWidget {
  const SubjectOverallResult({this.padding=2,this.examID,this.username,this.spbData});
  final double padding;
  final String username;
  final String examID;
  final Map<dynamic,dynamic> spbData;

  TableRow getSubjectOverallResult(String username, String examID, String area){
    final double _padding = 2.0;
    NumberFormat percentageFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);
    final List<Widget> children =[Text(area,style: o.TextStyles.optikBody1Bold)];
    children.add(Padding(padding: EdgeInsets.symmetric(vertical:_padding),child: Center(child: Text(spbData['generalDetail'][area][0].toStringAsFixed(2),style: o.TextStyles.optikBody1))));
    children.add(Padding(padding: EdgeInsets.symmetric(vertical:_padding),child: Center(child: Text(spbData['generalDetail'][area][1].toString(),style: o.TextStyles.optikBody1))));
    children.add(Padding(padding: EdgeInsets.symmetric(vertical:_padding),child: Center(child: Text(percentageFormat.format(spbData['generalDetail'][area][2]).toString(),style: o.TextStyles.optikBody1))));
    children.add(Padding(padding: EdgeInsets.symmetric(vertical:_padding),child: Center(child: Text(spbData['generalDetail'][area][3].toString(),style: o.TextStyles.optikBody1))));
    return TableRow(
      children: children);
  }

  @override
  Widget build(BuildContext context) {
    final List<TableRow> children = [TableRow(children: [for(var i in ['','Puan','Sıralama','Dilim','Katılan']) Padding(
      padding: EdgeInsets.symmetric(vertical:padding),
      child: Center(child: Text(i, style: o.TextStyles.optikBody2Bold)))])];
    children.addAll(
      [for (var i in spbData['generalDetail'].keys) getSubjectOverallResult(username, examID, i)]
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical:12.0,horizontal: 24.0),
      child:Table(children:children)
    );
  }
}


class OverallResultsNumber extends StatelessWidget {
  const OverallResultsNumber({
    this.spbData});
  final Map<dynamic,dynamic> spbData;
  @override
  Widget build(BuildContext context) {
    /* final double net = spbData['Genel']['dogru']-spbData['Genel']['yanlis']*.25; */
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      /* color: o.Colors.optikWhite, */
      padding: EdgeInsets.only(top:8.0,bottom: 8.0),
      child:Table(
        children: [
          TableRow(
            children: [ 
              Center(child:Text('Toplam',style: o.TextStyles.optikBody2)),
              Center(child:Text('Doğru',style: o.TextStyles.optikBody2)),
              Center(child:Text('Yanlış',style: o.TextStyles.optikBody2)),
              Center(child:Text('Boş',style: o.TextStyles.optikBody2)),
          ]),
          TableRow(
            children: [
              Center(child:Text(spbData['general']['total'].toString(),style: o.TextStyles.optikBody1Bold)),
              Center(child:Text(spbData['general']['correct'].toString(),style: o.TextStyles.optikBody1Bold)),
              Center(child:Text(spbData['general']['wrong'].toString(),style: o.TextStyles.optikBody1Bold)),
              Center(child:Text(spbData['general']['empty'].toString(),style: o.TextStyles.optikBody1Bold)),
          ]),
        ],
      )
    );
  }
}