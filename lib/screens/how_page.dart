import 'package:Optik/services/fetch_functions.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/widgets/loading.dart';

class HowPage extends StatefulWidget {
  HowPage({Key key}) : super(key: key);  
  @override
  State<HowPage> createState() => _HowPageState();
}

class _HowPageState extends State<HowPage> {
  Map<dynamic,dynamic> args;
  String howPageString;
  bool loading;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    if(args['cache']['HowPage']!=null){
      howPageString = args['cache']['HowPage']['howPageString'];
      loading = false;
    } else{
      loading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
    }
  }

  onAfterBuild(BuildContext context) async {
    if(loading){
      args['cache']['HowPage'] = {};
      args['cache']['HowPage']['cacheTime'] = DateTime.now();
      howPageString = await fetchHowPage();
      args['cache']['HowPage']['howPageString']  = howPageString;
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        loading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:PreferredSize(preferredSize:Size.fromHeight(50.0),child:AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios,color: o.Colors.optikBlack,),
              onPressed: () {Navigator.of(context).pop();},
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        centerTitle: true,
        title:Text('Nasıl Kullanılır?',style: o.TextStyles.optikTitle),
        backgroundColor: o.Colors.optikWhite,)),
        body: loading?Loading(negative:true):Padding(
          padding: EdgeInsets.symmetric(horizontal:12.0,vertical: 12.0),
          child: ListView(children:[Text(howPageString)])
      ),
    );
  }
}