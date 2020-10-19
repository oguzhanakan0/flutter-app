
import 'package:flutter/material.dart';
import 'package:Optik/models/spb.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/screens/myresults.dart';

class SPBPage extends StatefulWidget {
	final String username;
  final String examID;
  final String title;
  final bool isVisibleTYT;
  final bool isVisibleAYT;
	SPBPage({this.username, this.examID,this.title,this.isVisibleTYT,this.isVisibleAYT});
  @override
  _SPBPageState createState() => _SPBPageState();
}

class _SPBPageState extends State<SPBPage> {

  @override
	Widget build(context) {
    final SPBArguments args = ModalRoute.of(context).settings.arguments;
    /* print(args.parentExamID);
    print(args.username);
    print(args.isVisibleTYT); */
    return Scaffold(
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
          title: Text('Sınav Sonucu',
            style:o.TextStyles.optikBoldTitle)
        ),
      body:SPB(
        parentExam: args.parentExam,
        username: args.username)
    );
  }
}