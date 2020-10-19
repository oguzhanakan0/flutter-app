import 'dart:math';
import 'package:Optik/collections/globals.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Optik/collections/topic_map.dart' as map;
import 'package:flutter/material.dart';
import 'package:Optik/collections/user.dart';
import 'package:Optik/models/spb.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/widgets/loading.dart';

class DenemeSorulariStatsPage extends StatefulWidget {
  DenemeSorulariStatsPage({Key key}) : super(key: key);  
  @override
  State<DenemeSorulariStatsPage> createState() => _DenemeSorulariStatsPageState();
}

class _DenemeSorulariStatsPageState extends State<DenemeSorulariStatsPage> {
  bool loading;
  List<dynamic> histogramList;
  Map<String, dynamic> histogramListSubTopics;
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
    if(args['cache']['DenemeSorulariStatsPage']!=null){
      /* histogramList = args['cache']['DenemeSorulariStatsPage']['histogramList']; */
      histogramListSubTopics = args['cache']['DenemeSorulariStatsPage']['histogramListSubTopics'];
      histogramList = [];
      for(var i in histogramListSubTopics.keys){
        int total = 0;
        String parentTopic;
        for(var j in histogramListSubTopics[i]){
          total += j['nQuestions'];
          parentTopic = j['parentTopic'];
        }
        histogramList.add({'topic':i,'parentTopic':parentTopic,'nQuestions':total});
      }
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
          args['cache']['DenemeSorulariStatsPage']={};
          args['cache']['DenemeSorulariStatsPage']['cacheTime'] = DateTime.now();
          // herifin deneme sorularından kaç soru çözdüğü gelecek her topic için
          histogramListSubTopics = await fetchDenemeSorulariSubPanelStats(username: args['user'].username);
          /* histogramList = await fetchDenemeSorulariStats(username: args['user'].username); */
          histogramList = [];
          for(var i in histogramListSubTopics.keys){
            int total = 0;
            String parentTopic;
            for(var j in histogramListSubTopics[i]){
              total += j['nQuestions'];
              parentTopic = j['parentTopic'];
            }
            histogramList.add({'topic':i,'parentTopic':parentTopic,'nQuestions':total});
          }
          args['cache']['DenemeSorulariStatsPage']['histogramList'] = histogramList;
          args['cache']['DenemeSorulariStatsPage']['histogramListSubTopics'] = histogramListSubTopics;
          await Future.delayed(Duration(seconds: 1));
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
    /* final User user = ModalRoute.of(context).settings.arguments; */
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
        title: Text("Çözdüğüm Deneme Soruları",
          style:o.TextStyles.optikBoldTitle)
      ),
      body:Center(child:ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              /* border: Border.all(width: 1.0,color: o.Colors.optikBorder), */
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            /* margin: EdgeInsets.all(8.0), */
            padding: EdgeInsets.all(8.0),
            child:Column(
              children:[
                /* Container(
                  /* width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0,color: o.Colors.optikGray),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ), */
                  margin: EdgeInsets.symmetric(vertical:8.0),
                  padding: EdgeInsets.all(8.0),
                  child: Text('Aşağıdaki sütun grafiği hangi konudan kaç soru çözdüğünü gösteriyor. Konu başlıklarına basarak detayları görebilirsin!',
                    style: o.TextStyles.optikBody1,
                    textAlign: TextAlign.center,)
                ), */
                InfoBox(text:'Aşağıdaki sütun grafiği hangi konudan kaç soru çözdüğünü gösteriyor. Konu başlıklarına basarak detayları görebilirsin!'
                ),
                DenemeSorulariPanel(
                  histogramList: histogramList, 
                  histogramListSubTopics: histogramListSubTopics,
                  user:args['user'], 
                  cache: args['cache'],
                ),
              ]
            ),
          ),
        ]))
    );
  }
}

class DenemeSorulariPanel extends StatefulWidget {
  final List<dynamic> histogramList;
  final Map<String, dynamic> histogramListSubTopics;
  final User user;
  final Map<dynamic,dynamic> cache;
  DenemeSorulariPanel({this.histogramList, this.histogramListSubTopics, this.user, this.cache});
  /* DenemeSorulariPanel({Key key}) : super(key: key);   */
  @override
  State<DenemeSorulariPanel> createState() => _DenemeSorulariPanelState();
}

class _DenemeSorulariPanelState extends State<DenemeSorulariPanel> {
  List<dynamic> subPanelData;
  String title;
  String selectedTopic;

  @override
  void initState(){
    super.initState();
    subPanelData = widget.histogramListSubTopics[widget.histogramList[0]['topic']];
    title = map.topicMap[widget.histogramList[0]['parentTopic']][widget.histogramList[0]['topic']];
    selectedTopic = widget.histogramList[0]['topic'];
  }
  
  @override
  Widget build(BuildContext context) {
    List<int> nQuestionsList = [for (var i in widget.histogramList) i['nQuestions']];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      /* decoration: BoxDecoration(
        border: Border.all(width: 1.0,color: o.Colors.optikGray),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ), */
      width: double.infinity,
      child:
        Column(
          children:[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [for (var i in widget.histogramList) ResizableButton(
                username: widget.user.username,
                topic: i['topic'],
                nQuestions: i['nQuestions'],
                maxNQuestions:nQuestionsList.reduce(max),
                onPressed: (){
                  setState(() {
                    title = map.topicMap[i['parentTopic']][i['topic']];
                    selectedTopic = i['topic'];
                    subPanelData = widget.histogramListSubTopics[i['topic']];
                  });
                }
              )]
            ),
            /* Text('Aşağıda ise derslerin alt kırılımlarındaki çözdüğün soru sayısını görebilirsin. Ayrıca, sütunlara tıklayarak çözdüğün sorulara erişebilirsin.',
              style: o.TextStyles.optikBody1,
              textAlign: TextAlign.center,), */
            InfoBox(
              text: 'Aşağıda ise derslerin alt kırılımlarında çözdüğün soru sayısını görebilirsin. Ayrıca, sütunlara tıklayarak çözdüğün sorulara erişebilirsin.'
            ),
            Text(title,
              style: o.TextStyles.optikTitle,),
            DenemeSorulariSubPanel(
              histogramList: subPanelData,
              user:widget.user, 
              cache:widget.cache,
              actualTopic: selectedTopic,
            ),
          ]
        )
    );
  }
}

class DenemeSorulariSubPanel extends StatefulWidget {
  final List<dynamic> histogramList;
  final String actualTopic;
  final User user;
  final Map<dynamic,dynamic> cache;
  DenemeSorulariSubPanel({this.histogramList, this.actualTopic, this.user, this.cache});
  /* DenemeSorulariSubPanel({Key key}) : super(key: key);   */
  @override
  State<DenemeSorulariSubPanel> createState() => _DenemeSorulariSubPanelState();
}

class _DenemeSorulariSubPanelState extends State<DenemeSorulariSubPanel> {
  
  @override
  Widget build(BuildContext context) {
    List<int> nQuestionsList = [for (var i in widget.histogramList) i['nQuestions']];
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width/2
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      /* decoration: BoxDecoration(
        border: Border.all(width: 1.0,color: o.Colors.optikGray),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ), */
      width: double.infinity,
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [for (var i in widget.histogramList) ResizableButton(
          username: widget.user.username,
          actualTopic: widget.actualTopic,
          topic: i['topic'],
          subPanel: true,
          nQuestions: i['nQuestions'],
          maxNQuestions:nQuestionsList.reduce(max),
          onPressed: (){
            print(i['topic']);
            Navigator.pushNamed(context, '/spa', arguments: SPAArguments(
              username: widget.user.username,
              parentTopic: i['parentTopic'],
              topic: i['topic'],
              isExam:false,
              title: i['parentTopic']+' / '+map.subTopicMap3[widget.actualTopic][i['topic']],
              cache:widget.cache,
              userID: widget.user.id
            ));
          },
        ),
        ]
      ),
    );
  }
}

class ResizableButton extends StatelessWidget{
  final int nQuestions;
  final int maxNQuestions;
  final String topic;
  final String username;
  final double maxHeight;
  final int nItems;
  final Function onPressed;
  final bool subPanel;
  final String actualTopic;
  const ResizableButton({
    this.nQuestions = 0,
    @required this.maxNQuestions,
    @required this.topic,
    @required this.username,
    this.maxHeight = 200,
    this.nItems = 8,
    this.onPressed,
    this.subPanel = false,
    this.actualTopic
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        minHeight: 80.0,
        maxWidth: 80,
      ),
      width: MediaQuery.of(context).size.width/(nItems+2),
      height: nQuestions/maxNQuestions*maxHeight,
      child:FlatButton(
        disabledColor: o.Colors.optikLightGray,
        padding:EdgeInsets.all(0.0),
        /* color:map.colorMap[topic], */
        color: o.Colors.optikContainerBg,
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onPressed: onPressed,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AutoSizeText(
              nQuestions.toString(),
              style: o.TextStyles.optikBody1,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center
            ),
            Column(children: <Widget>[
              Container(height: 10,color: o.Colors.optikWhite,),
              Container(
                height: 40.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color:map.colorMap[subPanel?actualTopic:topic],
                ),
                padding: EdgeInsets.all(2.0),
                /* margin: EdgeInsets.all(4.0), */
                child:Center(child:AutoSizeText(
                  topic,
                  style: o.TextStyles.optikBody1BoldWhite,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center
                ))
              )
            ],)
          ]
        ),
      )
    );
  }
  
}

class InfoBox extends StatelessWidget{
  final String text;
  const InfoBox({this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        /* border: Border.all(width: 1.0,color: o.Colors.optikGray), */
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: o.Colors.optikBlue
      ),
      margin: EdgeInsets.symmetric(vertical:8.0),
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:[
        Icon(Icons.info,color: o.Colors.optikWhite,),
        SizedBox(
          width: MediaQuery.of(context).size.width*4/5,
          child:Text(text,
            style: o.TextStyles.optikBody1White)
          )
        ]
      )
    );
  }

}