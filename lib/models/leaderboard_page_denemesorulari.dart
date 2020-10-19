import 'package:Optik/collections/globals.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/widgets/loading.dart';

class RankingDS {
  String userName;
  int userRank;
  String userSchool;
  double userScore;
  RankingDS(this.userName,this.userRank,this.userSchool,this.userScore);
}

class ShowDataDS {
  RankingDS userRanking;
  List<RankingDS> rankingList;
  ShowDataDS({this.userRanking,this.rankingList});
}

class LeaderboardPageDenemeSorulari extends StatefulWidget {
  LeaderboardPageDenemeSorulari({Key key}) : super(key: key);
  @override
  State<LeaderboardPageDenemeSorulari> createState() => _LeaderboardPageDenemeSorulariState();
}

class _LeaderboardPageDenemeSorulariState extends State<LeaderboardPageDenemeSorulari> with SingleTickerProviderStateMixin {
  bool loading;
  int itemCount = 0;
  List<RankingDS> _rankingList; 
  List<int> itemList;
  RankingDS currentUserRanking;
  Map<dynamic,dynamic> args;
  bool reloadState;
  bool isTappable;

  void _loadMore (){
    setState(() {
      if(itemList.length < _rankingList.length){
        if(10 < _rankingList.length-itemList.length){
          itemList.addAll(List.generate(10, (v) => v));
        } else {
          itemList.addAll(List.generate(_rankingList.length-itemList.length, (v) => v));
        }
      }
    });
  }

  Widget buildItem(BuildContext ctxt, int index) {
      TextStyle _textStyle = o.TextStyles.optikBody2;
      if (currentUserRanking.userRank == index+1 && currentUserRanking.userRank <= itemList.length){
        return SingleRankingContainer(
          rank:currentUserRanking.userRank,
          name:currentUserRanking.userName,
          school:currentUserRanking.userSchool,
          score: currentUserRanking.userScore,
          textStyle: _textStyle.copyWith(color: o.Colors.optikWhite),
          isUser: true);
      }
      if(index < itemList.length){
        return SingleRankingContainer(
          rank:_rankingList[index].userRank,
          name:_rankingList[index].userName,
          school:_rankingList[index].userSchool,
          score: _rankingList[index].userScore,
          textStyle: _textStyle,);
      }
      else if (index == itemList.length){
        return GestureDetector(onTap: _loadMore,child:Container(color:o.Colors.optikWhite,width:double.infinity,child:Icon(Icons.more_horiz)));
      }
      else if (index > itemList.length && currentUserRanking.userRank > itemList.length ){
        return SingleRankingContainer(
          rank:currentUserRanking.userRank,
          name:currentUserRanking.userName,
          school:currentUserRanking.userSchool,
          score: currentUserRanking.userScore,
          textStyle: _textStyle.copyWith(color: o.Colors.optikWhite),
          isUser: true);
      } else {
        return null;
      }
    }

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
    if(args['cache']['LeaderBoardDenemeSorulariPage']!=null){
      _rankingList = args['cache']['LeaderBoardDenemeSorulariPage']['_rankingList'];
      currentUserRanking = args['cache']['LeaderBoardDenemeSorulariPage']['currentUserRanking'];
      loading = false;
    } else{
      loading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
    }
    itemList = List.generate(9, (v) => v);
  }


  @override
  Widget 
  build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return reloadState?Center(child:RaisedButton(
      color: o.Colors.optikBlue,
      child: Text('İnternet bağlantısı bulunamadı. Tekrar dene.',style: o.TextStyles.optikBody1White,),
      onPressed: !isTappable?(){}:() async {
        setState(() {
          isTappable = false;
        });
        await onAfterBuild(context);
      },
      )):loading?Loading(negative: true):Column(children: <Widget>[
      Container(
        margin: EdgeInsets.symmetric(vertical:4.0,horizontal: 8.0),
        padding: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: o.Colors.optikBorder)),
        ),
        child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(width: _width/9,child:Text('Sıra',style: o.TextStyles.optikBody2Bold,textAlign: TextAlign.center,)),
              Container(width: _width*3/11,child:Text('Kullanıcı',style: o.TextStyles.optikBody2Bold,textAlign: TextAlign.center,)),
              Container(width: _width/3,child:Text('Okul',style: o.TextStyles.optikBody2Bold,textAlign: TextAlign.center,)),
              Container(width: _width/6,child:Text('Puan',style: o.TextStyles.optikBody2Bold,textAlign: TextAlign.center,))
           ],
          )
      ),
      Expanded(
        child: 
          ListView.builder(
          itemCount: itemList.length+2,
          itemBuilder: (BuildContext context, int index) => buildItem(context, index)
          )
      ),
    ]
    );
  }

  onAfterBuild(BuildContext context) async {
    if(loading&&mounted){
      if(!NO_INTERNET){
        try{
          args['cache']['LeaderBoardDenemeSorulariPage']={};
          args['cache']['LeaderBoardDenemeSorulariPage']['cacheTime'] = DateTime.now();

          dynamic responseGeneral = await fetchLeaderBoardDenemeSorulariGeneralStats();
          /* dynamic responsePersonal = await fetchLeaderBoardDenemeSorulariPersonalStats(); */
          _rankingList = [];
          for(var i in responseGeneral["array"]){
            _rankingList.add(RankingDS(i[0],i[1],i[2],i[3]));
          }
          /* currentUserRanking = RankingDS(responsePersonal[0],responsePersonal[1],responsePersonal[2],responsePersonal[3]); */
          currentUserRanking = _rankingList[0];
          args['cache']['LeaderBoardDenemeSorulariPage']['_rankingList'] = _rankingList;
          args['cache']['LeaderBoardDenemeSorulariPage']['currentUserRanking'] = currentUserRanking;
          if(mounted){
            setState(() {
              loading=false;
              reloadState = false;
            });
          }
        } catch(e){
          print(e);
          if(mounted){
            setState(() {
              reloadState = true;
              isTappable = true;
            });
          }
        }
      }
      else {
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

class SingleRankingContainer extends StatelessWidget{
  SingleRankingContainer({Key key, this.rank,this.name,this.school,this.score,this.isUser:false,this.textStyle}) : super(key: key);
  final int rank;
  final String name;
  final String school;
  final double score;
  final bool isUser;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical:4.0,horizontal: 8.0),
      padding: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: isUser? o.Colors.optikBlue : o.Colors.optikWhite,
        border: isUser? null : Border.all(width: 1.0,color: o.Colors.optikBorder),
        borderRadius: BorderRadius.all(Radius.circular(4.0 )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(width: _width/9, child:Text(rank.toString(), style: textStyle,softWrap: true, textAlign: TextAlign.center)),
          SizedBox(width: _width*3/11, child:Text(name,style: textStyle.copyWith(fontWeight: FontWeight.w600),softWrap: true, textAlign: TextAlign.center)),
          SizedBox(width: _width*1/3, child:Text(school,style: textStyle,softWrap: true, textAlign: TextAlign.center)),
          SizedBox(width: _width*3/18, child:Text(score.toString(), style: textStyle,softWrap: true, textAlign: TextAlign.center))
        ]
      )
    );
  }
}