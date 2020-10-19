import 'package:Optik/scoped_models/home_view_model.dart';
import 'package:Optik/services/service_locator.dart';
import 'package:Optik/views/base_view.dart';
import 'package:Optik/views/home_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Optik/screens/deneme_sorulari_stats_page.dart';
import 'package:Optik/screens/exam_question_page.dart';
import 'package:Optik/screens/forgot_password_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'screens/change_area_page.dart';
import 'screens/change_email_page.dart';
import 'screens/change_password_page.dart';
import 'screens/exam_before_results_page.dart';
import 'screens/exam_hold_page.dart';
import 'screens/exam_lobby_page.dart';
import 'screens/entrance_page.dart';
import 'screens/deneme_sorulari_answer_page.dart';
import 'screens/deneme_sorulari_question_page.dart';
import 'screens/deneme_sorulari_run_page.dart';
import 'screens/deneme_sorulari_select_parenttopic_page.dart';
import 'screens/deneme_sorulari_select_subtopic_page.dart';
import 'screens/deneme_sorulari_select_topic_page.dart';
import 'screens/deneme_sorulari_session_end_page.dart';
import 'screens/exam_results_page.dart';
import 'screens/exam_review_page.dart';
import 'screens/get_user_password_page.dart';
import 'screens/help_page.dart';
import 'screens/how_page.dart';
import 'screens/settings_page.dart';
import 'screens/signup_form.dart';
import 'screens/signup_form_demographics.dart';
import 'screens/signup_form_demographics_cont.dart';
import 'screens/signup_form_demographics_search_page.dart';
import 'screens/signup_form_verify_phone.dart';
import 'screens/spa_page.dart';
import 'screens/spb_page.dart';
import 'screens/welcome_page.dart';
import 'screens/myresults.dart';
import 'models/app_body.dart';
import 'models/timer_service_provider.dart';
import 'screens/signup_form_enter_phone.dart';
import 'package:wakelock/wakelock.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


void main() async{
  final timerService = TimerService();
  setupLocator();
  runApp(
    TimerServiceProvider( // provide timer service to all widgets of your app
      service: timerService,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  final state = _MyAppState();
  MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => state;
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    print('configured');
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    print('premission requsted');
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    print('listening..');
    _firebaseMessaging.getToken().then((String token) {assert(token != null); print(token);});
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(builder: (context, child, model) => 
      OverlaySupport(child:MaterialApp(
        title: 'Optik',
        debugShowCheckedModeBanner: false,
        routes:<String, WidgetBuilder>{
          // Welcome
          "/" : (context)=> EntrancePage(),
          // Login
          '/login_page' : (context)=> WelcomePage(),
          '/get_user_password' : (context)=> GetUserPasswordPage(),
          '/forgot_password' : (context)=> ForgotPasswordPage(),
          // Signup
          "/signup" : (context)=> SignupForm(),
          "/signup_enterphone" : (context)=> SignupFormPhoneNumber(),
          "/signup_verifyphone" : (context)=> VerifyPhoneNumber(),
          "/signup_demographics" : (context)=> SignupFormDemographics(),
          "/signup_demographics_dropdown" : (context)=> SignupFormDemographicsSearchPage(),
          "/signup_demographics2" : (context)=> SignupFormDemographicsContd(),
          // App
          "/home" : (context)=> AppBody(),
          "/settings_page" : (context)=> SettingsPage(),
          "/change_area" : (context)=> ChangeAreaPage(),
          "/change_password" : (context)=> ChangePasswordPage(),
          "/change_email" : (context)=> ChangeEmailPage(),
          "/how" : (context)=> HowPage(),
          "/help" : (context)=> HelpPage(),
          // OptikExam
          "/lobby" : (context) => ExamLobby(model),
          "/exam_question_page":(context) => OptikExamQuestionPage(),
          "/exam_hold_page":(context) => OptikExamHoldPage(),
          "/exam_review_page":(context) => OptikExamReviewPage(),
          "/exam_before_results_page":(context) => OptikExamBeforeResultsPage(),
          "/exam_results_page":(context) => OptikExamResultsPage(),
          // Game
          "/deneme_sorulari_select_parenttopic" : (context)=> DenemeSorulariSelectParentTopicPage(),
          "/deneme_sorulari_select_topic" : (context)=> DenemeSorulariSelectTopicPage(),
          "/deneme_sorulari_select_subtopic" : (context)=> DenemeSorulariSelectSubTopicPage(),
          "/deneme_sorulari_run" : (context)=> DenemeSorulariRunPage(),
          "/deneme_sorulari_question" : (context)=> DenemeSorulariQuestionPage(),
          "/deneme_sorulari_answer" : (context)=> DenemeSorulariAnswerPage(),
          "/deneme_sorulari_session_end" : (context) => DenemeSorulariSessionEndPage(),
          // Results Related
          "/myresults" : (context)=> MyResults(),
          "/spb" : (context)=> SPBPage(),
          "/spa" : (context)=> SPAPage(),
          "/deneme_sorulari_stats" : (context) => DenemeSorulariStatsPage(),
          // Temp
          "/live_users": (context)=> HomeView(model)
          }
        )
      )
    );
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print(notification);
  }
  return null;
  // Or do other work.
}