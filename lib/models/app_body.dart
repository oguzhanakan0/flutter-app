import 'dart:io' show Platform;
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:Optik/widgets/no_internet_info_box.dart';
import 'package:flutter/material.dart';
import 'package:Optik/collections/exam.dart';
import 'package:Optik/collections/globals.dart';
import 'package:Optik/screens/home_page.dart';
import 'package:Optik/screens/profile_page.dart';
import 'package:Optik/screens/leaderboard_page.dart';
import 'package:Optik/screens/schedule.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/services/convert_functions.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:Optik/widgets/loading.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> with WidgetsBindingObserver{
  Exam todaysExam;
  DateTime examDate;
  bool loading;
  bool error;
  bool isLive;
  Map<dynamic,dynamic> args;
  bool reloadState;
  bool isTappable;
  /* bool args['cache']['examPushed']; */
  var timeLeft;
  
  final List<Widget> pages = [
    HomePage(key: PageStorageKey('HomePage')),
    LeaderboardPage(key:Key('LeaderBoard')),
    Schedule(key: PageStorageKey('Schedule')),
    ProfilePage(key: PageStorageKey('ProfilePage'))
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  int _selectedIndex = 0;
  bool noInternet;
  final Connectivity _connectivity = new Connectivity();

  BottomNavigationBarItem bottomItem(Icon ico){
    return BottomNavigationBarItem(icon:ico,title:Text(''));
  }
  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        onTap: (int index) => setState(() => _selectedIndex = index),
        currentIndex: selectedIndex,
        selectedItemColor: o.Colors.optikBlue,
        unselectedItemColor: o.Colors.optikBlack,
        items: [
          bottomItem(Icon(Icons.home)), // HOME
          bottomItem(Icon(Icons.insert_chart)), // LEADERBOARD
          bottomItem(Icon(Icons.schedule)), // SCHEDULE
          /* bottomItem(Icon(Icons.archive,color:o.Colors.optikBlack)), // OPTIKSELF */
          bottomItem(Icon(Icons.person)) // PROFILE
        ],
      );

  // APPBAR
  PreferredSize _appBar(int ix) {
    var title;
    switch (ix) {
      case 0: title = 'Anasayfa'; break;
      case 1: title = 'İstatistikler'; break;
      case 2: title = 'Takvim'; break;
      case 3: title = 'Profil'; break;
    }
    bool settingsButton = title=='Profil' ? true:false;
    var _actions = settingsButton ? <Widget>[IconButton(icon: Icon(Icons.settings,color:o.Colors.optikBlack),
      onPressed: () {
        Navigator.pushNamed(context,'/settings_page',arguments: ModalRoute.of(context).settings.arguments);
      })]: null;
    return PreferredSize(preferredSize: Size.fromHeight(50.0),
      child:AppBar(
        title:Center(child:Text(title,style: o.TextStyles.optikTitle)),
        actions:_actions,
        centerTitle: true,
        backgroundColor: o.Colors.optikLightGray,
        automaticallyImplyLeading: false,
    ));
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    error = false;
    isLive = true;
    noInternet = false;
    reloadState = false;
    isTappable = true;
    WidgetsBinding.instance.addObserver(this);
    

    initConnectivity();
    _connectionSubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          if(result==ConnectivityResult.none){
            setState(() {
              noInternet = true;
              NO_INTERNET = true;
            });
            print('NO_INTERNET set to:'+ NO_INTERNET.toString());
            if(ON_EXAM){
              print('NO_NITERNET nofitication sent');
              showSimpleNotification(
                NoInternetInfoBox(),
                background: o.Colors.optikWhite.withOpacity(0.0),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                slideDismiss: true,
                autoDismiss: true
              );
            }
          } else {
            setState(() {
              noInternet = false;
              NO_INTERNET = false;
              print('NO_INTERNET set to:'+ NO_INTERNET.toString());
            });
          }
    });
    try{
      fetchExamAndConfig();
    } catch(e){
      setState(() {
        reloadState = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectionSubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        print('[app body] isLive is false now');
        setState(() {
          isLive = false;
        });
        break;
      case AppLifecycleState.resumed:
        print('[app body] isLive is true now');
        timeLeft = examDate.difference(DateTime.now().add(Duration(milliseconds: timeOffset))).inSeconds;
        // DID HE MISS THE EXAM COMPLETELY?
        if(timeLeft<-1*GRACE_PERIOD){
          showSimpleNotification(
            Text("Sınavı kaçırdın! Çok üzgünüz, bir dahaki sınava vaktinde bekliyoruz."),
            background: o.Colors.optikBlue,
            trailing: Builder(builder: (context) {
              return FlatButton(
                textColor: Colors.yellow,
                onPressed: () {
                  OverlaySupportEntry.of(context).dismiss();
                },
                child: Text('Tamam'));
          }));
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (Route<dynamic> route) => false,
            arguments: {'user':args['user'],'cache':Map<String,dynamic>()}
          );
        } else {
          pushExam();
        }
        setState(() {
          isLive = true;
        });
        break;
      case AppLifecycleState.inactive:
        print('inactive state');
        break;
      case AppLifecycleState.detached:
        print('detached state');
        break;
    }
  }

  onAfterBuild(BuildContext context) async {
    if(loading&&mounted){
      if(!NO_INTERNET){
        try{
          pushExam();
          notifyExam3();
          notifyExam1();
          setState(() {
            loading = false;
            reloadState = false;
          });
        } catch(e){
          if(mounted){
            setState(() {
              loading = false;
              reloadState = true;
              isTappable = true;
            });
          }
        }
      } else {
        if(mounted){
          setState(() {
            loading = false;
            reloadState = true;
            isTappable = true;
          });
        }
      }
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showDialog({BuildContext context, Function onPressed, bool canDismiss}){
    return showDialog (
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop:(){},
          child:AlertDialog (
          title: Text("Uyarı",style: o.TextStyles.optikBody1Bold,),
          content: Text("Yeni bir güncelleme var. Lütfen uygulamayı hatasız bir şekilde kullanabilmek için güncelleme yapın."),
          actions: <Widget>[
            RaisedButton(
              elevation: 0.5,
              color: o.Colors.optikBlue,
              child: Text('Güncelle',style: o.TextStyles.optikBody1White,),
              onPressed: onPressed),
            canDismiss?
            RaisedButton(
              elevation: 0.0,
              color: o.Colors.optikLightGray,
              child: Text('Daha Sonra', style: o.TextStyles.optikBody1,),
              onPressed: (){fetchExamAndConfig(versionMessage:"correct");Navigator.pop(context);},
            ):SizedBox()
          ],
      ));});
  }

  Future fetchExamAndConfig({String versionMessage}) async {
    try{
      versionMessage = versionMessage ?? await fetchConfigurations();
      switch (versionMessage) {
        case 'exists_mandatory':
          _showDialog(
            context:context,
            canDismiss: false, 
            onPressed: (){
              if (Platform.isAndroid) {
                _launchURL(PLAYSTORE_LINK);
              } else if (Platform.isIOS) {
                _launchURL(APPSTORE_LINK);
              }
            }); break;
        case 'exists':
          _showDialog(
            context:context,
            canDismiss: true, 
            onPressed: (){
              if (Platform.isAndroid) {
                _launchURL(PLAYSTORE_LINK);
              } else if (Platform.isIOS) {
                _launchURL(APPSTORE_LINK);
              }
            }); break;
        case 'correct':
          dynamic res= await fetchExam(isToday: true);
            if(res['success']){
              todaysExam = convertExam(res);
              examDate = todaysExam.examDate;
              args = ModalRoute.of(context).settings.arguments;
              WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
              args['cache']['examPushed'] = false;
              args['cache']['todaysExam']=todaysExam;
              args['cache']['referenceDate']= todaysExam.examDate.difference(DateTime.now().add(Duration(milliseconds: timeOffset))) > Duration(days: 1) ?
                DateTime.now().add(Duration(milliseconds: timeOffset)):todaysExam.examDate.add(Duration(days: -1));
            } else{
              if(mounted){
                setState(() {
                  error = true;
                });
              }
            }
      }
    } catch(e){
      if(mounted){
        setState(() {
          error = true;
        });
      }
    }
  }

  void incrementUsers() {
    Firestore.instance.collection('info').document('project_stats').updateData({'users':FieldValue.increment(1)});
  }
  
  Future pushExam() async {
    timeLeft = examDate.difference(DateTime.now().add(Duration(milliseconds: timeOffset))).inSeconds;
    timeLeft = timeLeft < 0 ? 0 : timeLeft;
    await new Future.delayed(Duration(seconds: timeLeft), () {
      if(mounted && !args['cache']['examPushed'] && isLive){
        incrementUsers();
        Navigator.pushReplacementNamed(
          context,
          '/lobby',
          arguments: ModalRoute.of(context).settings.arguments);
        setState(() {
          args['cache']['examPushed'] = true;
        });
      }
    });
  }

  Future notifyExam3() async {
    if(timeLeft>180){
      await new Future.delayed(Duration(seconds: timeLeft-180), () {
          notify(3);
        }
      );
    }
  }

  Future notifyExam1() async {
    if(timeLeft>60){
      await new Future.delayed(Duration(seconds: timeLeft-60), () {
          notify(1);
        }
      );
    }
  }

  void notify(int n){
    showSimpleNotification(
      Text("Bugünkü sınava son "+n.toString()+" dakika kaldı!"),
      background: o.Colors.optikBlue,
      autoDismiss: true,
      trailing: Builder(builder: (context) {
        return FlatButton(
          textColor: Colors.yellow,
          onPressed: () {
            OverlaySupportEntry.of(context).dismiss();
          },
          child: Text('Tamam'));
    }));
  }

  //For subscription to the ConnectivityResult stream
  StreamSubscription<ConnectivityResult> _connectionSubscription;

  //called in initState
  /*
    _connectivity.checkConnectivity() checks the connection state of the device.
    Recommended way is to use onConnectivityChanged stream for listening to connectivity changes.
    It is done in initState function.
  */
  Future<Null> initConnectivity() async {
    try {
      _connectivity.checkConnectivity();
      setState(() {
        noInternet = false;
      });
    } catch (e) {
      setState(() {
        noInternet = true;  
      });
    }
    if (!mounted) {
      return;
    }
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    print('app body built!');
    return reloadState?Scaffold(body:Center(child:RaisedButton(
      color: o.Colors.optikBlue,
      child: Text('Tekrar dene\nBir şeyler ters gitti.',style: o.TextStyles.optikBody1White,),
      onPressed: !isTappable?(){}:() async {
        setState(() {
          isTappable = false;
        });
        await onAfterBuild(context);
      },
      ))):loading?
          Loading(negative:true):
            error?
            Scaffold(body: Center(child: Text('Yüklenirken bir hata oluştu. Lütfen internet bağlantınızı kontrol edin.'),),):
              Scaffold(
              extendBody: true,
              appBar: _selectedIndex==0 ? null : _appBar(_selectedIndex),
              bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
              body: PageStorage(child:pages[_selectedIndex],bucket: bucket),
            );
  }
}