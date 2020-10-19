import 'package:flutter/material.dart';
import 'package:Optik/collections/deneme_sorulari.dart';
import 'package:Optik/collections/question.dart';
import 'package:Optik/models/theme.dart' as o;


class DenemeSorulariInherited extends InheritedWidget {
  final DenemeSorulariPageArgs pageArgs;
  final Map<int,Question> questions;
  final dynamic args;

  DenemeSorulariInherited({
    Key key,
    this.args,
    @required this.pageArgs,
    @required this.questions,
    @required Widget child,
  }) : super(key: key, child: child);

  static DenemeSorulariInherited of(BuildContext context) {
    /* return (context.dependOnInheritedWidgetOfExactType()
            as DenemeSorulariInherited); */
    return (context.inheritFromWidgetOfExactType(DenemeSorulariInherited)
            as DenemeSorulariInherited);
  }

  @override
  bool updateShouldNotify(DenemeSorulariInherited old) => true;
  }

class DenemeSorulariSelectParentTopicPage extends StatelessWidget {
  const DenemeSorulariSelectParentTopicPage({Key key}) : super(key: key);
  /* final List<Question> questions; */

  @override
  Widget build(BuildContext context) {
    final dynamic args = ModalRoute.of(context).settings.arguments;
    return DenemeSorulariInherited(
      pageArgs: DenemeSorulariPageArgs(username: args['user'].username, userID: args['user'].id),
      questions: Map<int,Question> (),
      args: args,
      child: const DenemeSorulariPageWidget(),
    );
  }
}

class DenemeSorulariPageWidget extends StatelessWidget {
  const DenemeSorulariPageWidget();

  Widget build(BuildContext context){
    var args = DenemeSorulariInherited.of(context);
    var _buttonWidth = MediaQuery.of(context).size.width * 0.4;
    return Scaffold(
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
        title: Text("Deneme Soruları",
          style:o.TextStyles.optikBoldTitle)
      ),
      body:Center(child:SingleChildScrollView(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(height: 60, child:Image(image: AssetImage('assets/images/logo.png'))),
          Text('Deneme Soruları',
            style: o.TextStyles.optikTitle),
          SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: _buttonWidth,
                height: _buttonWidth*3/4,
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: o.Colors.optikBlue,
                  borderRadius: BorderRadius.all(Radius.circular(16.0 )),
                ),
                child:FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text('TYT',style: o.TextStyles.optikBoldTitle.copyWith(color: o.Colors.optikWhite),textAlign: TextAlign.center,),
                  onPressed: (){
                    print(args);
                    print(args.pageArgs);
                    args.pageArgs.parentTopicChoice = 'TYT';
                    Navigator.pushNamed(
                      context,
                      '/deneme_sorulari_select_topic',
                      arguments: args
                    );
                  },
                )
              ),
              Container(
                width: _buttonWidth,
                height: _buttonWidth*3/4,
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  /* border: Border.all(width: 4.0,color: o.Colors.optikTurkce), */
                  color: o.Colors.optikDarkBlue,
                  borderRadius: BorderRadius.all(Radius.circular(16.0 )),
                ),
                child:FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text('AYT',style: o.TextStyles.optikBoldTitle.copyWith(color: o.Colors.optikWhite),textAlign: TextAlign.center,),
                  onPressed: (){
                    args.pageArgs.parentTopicChoice = 'AYT';
                    Navigator.pushNamed(
                      context,
                      '/deneme_sorulari_select_topic',
                      arguments: args
                    );},
                )
              ),
            ],
          )
        ]
      ))
    ));
  }
}

class MyWidget extends StatelessWidget {
  
    const MyWidget();
    
    Widget build(BuildContext context) {
      // somewhere down the line
      /* const MyOtherWidget(); */
      return const MyOtherWidget();
    }
  }
  
  
  class MyOtherWidget extends StatelessWidget {
    const MyOtherWidget();
    
    Widget build(BuildContext context) {
      print('buraya kadar geldim');
      final myInheritedWidget = DenemeSorulariInherited.of(context);
      print(myInheritedWidget);
      print(myInheritedWidget.pageArgs);
      print(myInheritedWidget.questions);
      print(myInheritedWidget.pageArgs.topicChoice);
      print(myInheritedWidget.pageArgs.subTopicChoice);
      myInheritedWidget.pageArgs.subTopicChoice = 'SDF';
      print(myInheritedWidget.pageArgs.subTopicChoice);
      return Container(child: Text('hi'));
  }
}