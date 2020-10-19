import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/models/leaderboard_page_optikexam.dart' as tab1;
import 'package:Optik/models/leaderboard_page_denemesorulari.dart' as tab2;
/* import 'package:Optik/models/leaderboard_page_optikoffline.dart' as tab3;*/
class Choice {
const Choice({this.title, this.icon});
final String title;
final TextStyle textStyle = o.TextStyles.optikBody1Bold;
final Icon icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Deneme Sınavları', icon: Icon(Icons.timer,color: o.Colors.optikBlack)),
  const Choice(title: 'Deneme Soruları', icon: Icon(Icons.hot_tub,color: o.Colors.optikBlack)),
  /* const Choice(title: 'Deneme Sınavları', icon: Icon(Icons.redeem,color: o.Colors.optikBlack)) */
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = o.TextStyles.optikBody1Bold;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            choice.icon,
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}

class LeaderboardPage extends StatefulWidget {
  LeaderboardPage({Key key}) : super(key: key);
  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();

}

class _LeaderboardPageState extends State<LeaderboardPage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
        DefaultTabController(
          length: choices.length,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabs: choices.map((Choice choice) {
                  return Tab(
                    child: Text(choice.title,style:choice.textStyle),
                    icon: choice.icon,
                  );
                }).toList(),
              ),
              Expanded(
                child:TabBarView(
                  physics: BouncingScrollPhysics(parent:AlwaysScrollableScrollPhysics()),
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:8.0),
                      child:tab1.LeaderboardPageOptikExam()
                    ),
                    Container(
                      child:tab2.LeaderboardPageDenemeSorulari(),
                    ),
                  ]
                )
              )
              
            ]
          ),
        
      
    );
  }
}