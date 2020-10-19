import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:package_info/package_info.dart';
import 'package:Optik/collections/globals.dart';
import 'package:Optik/services/post_functions.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart';

Future<dynamic> fetchUser({String username, String deviceID}) async {
  return await rootBundle.loadString("assets/cfg/sampleUser.json").then((str) => json.decode(str));
}

Future<dynamic> fetchExam({
  String id, 
  String parentExamName,
  String examID,
  bool isToday=false, 
  bool forSchedule=false,
  bool forCurrentParentExam=false,
  bool forAnyExam=false}) async {
  if(isToday){
    String url = address+'/todays_exam';
    print("fetching today's exam");
    dynamic res = trySend(url:url,postString:json.encode({'sessionID':SESSION_ID}),maxTrials: 3);
    return res;
    /* return await rootBundle.loadString("assets/cfg/sampleTodaysExam.json").then((str) => json.decode(str)); */
  } else if(forSchedule){
    String url = address+'/scheduled_exams';
    print("fetching scheduled exams");
    Response response = await post(url,headers:headers, body:json.encode({'sessionID':SESSION_ID,}));
    dynamic res = json.decode(response.body);
    print(res);
    return res['array'];
    /* return await rootBundle.loadString("assets/cfg/sampleScheduleExams.json").then((str) => json.decode(str)); */
  } else if(forCurrentParentExam){
    String url = address+'/current_exams';
    print("fetching current exams");
    print({'parentExamName':parentExamName});
    /* Response response = await post(
      url, 
      headers:headers,
      body: json.encode({'parentExamName':parentExamName,'sessionID':SESSION_ID,})); */
    dynamic res = await trySend(url:url,postString:json.encode({'parentExamName':parentExamName,'sessionID':SESSION_ID,}),maxTrials: 1);
    if(res['success']){
      return res['array'];
    } else {
      if(res['error']!=null){
        return res['error'];
      } else {
        return null;
      }
    }
    /* return await rootBundle.loadString("assets/cfg/sampleCurrentExams.json").then((str) => json.decode(str)); */
  } else if(forAnyExam){
    String url = address+'/any_exam';
    print("fetching any exam");
    print(json.encode({'examID':examID,'sessionID':SESSION_ID}));
    dynamic res = await trySend(url:url, postString:json.encode({'examID':examID,'sessionID':SESSION_ID}),maxTrials: 1);
    print(res);
    return res;
    /* return await rootBundle.loadString("assets/cfg/sampleAnyExam.json").then((str) => json.decode(str)); */
  } else {
    return null;
  }
}

Future<dynamic> fetchFinalAnswers({String examID}) async {
  String url = address+'/answers_only_by_exam';
  print("fetching final answers");
  dynamic res = await trySend(url:url, postString:json.encode({'sessionID':SESSION_ID,'examID':examID}));
  print('res:');
  print(res);
  if(res['success']){
    return res['array'];
  } else {
    return null;
  }
}

Future<dynamic> fetchAttendeeCount({String sessionID}) async {
  String url = address+'/attendee_count';
  // make POST request
  print("fetching test question");
  Response response = await post(
    url,
    headers:headers,
    body: json.encode({'sessionID':SESSION_ID})
  );
  // check the status code for the result
  dynamic res = json.decode(response.body);
  if(res['success']){
    return res['count'].toString();
  } else {
    return '~';
  }
}

Future<dynamic> fetchLeaderBoardOptikExamGeneralStats() async {
  String url = address+'/stats_general';
  print("fetching leaderboard general stats");
  dynamic res = await trySend(postString: json.encode({'sessionID':SESSION_ID}), url:url,maxTrials: 1);
  if(res['success']!=null){
    if(res['success']){
      return res;
    }
  }
  return null;
  /* return await rootBundle.loadString("assets/cfg/sampleLeaderBoardOptikExamGeneralStats.json").then((str) => json.decode(str)); */
  /* return null; */
}

Future<dynamic> fetchLeaderBoardOptikExamPersonalStats() async {
  String url = address+'/stats_personal';
  print("fetching leaderboard personal stats");
  dynamic res = await trySend(postString: json.encode({'sessionID':SESSION_ID}), url:url,maxTrials: 1);
  if(res['success']!=null){
    if(res['success']){
      return res;
    }
  }
  return null;
  /* return await rootBundle.loadString("assets/cfg/sampleLeaderBoardOptikExamPersonalStats.json").then((str) => json.decode(str)); */
}

Future<dynamic> fetchLeaderBoardDenemeSorulariGeneralStats() async {
  String url = address+'/stats_test';
  print("fetching leaderboard deneme sorulari stats");
  dynamic res = await trySend(postString: json.encode({'sessionID':SESSION_ID}), url:url,maxTrials: 1);
  if(res['success']!=null){
    if(res['success']){
      return res;
    }
  }
  return null;
  /* return await rootBundle.loadString("assets/cfg/sampleLeaderBoardDenemeSorulariGeneralStats.json").then((str) => json.decode(str)); */
}

Future<dynamic> fetchLeaderBoardDenemeSorulariPersonalStats({String username}) async {  
  return await rootBundle.loadString("assets/cfg/sampleLeaderBoardDenemeSorulariPersonalStats.json").then((str) => json.decode(str));
}

Future<dynamic> fetchQuestion({
  String userID,
  /* String username, */
  String subtopic,
  bool isGununSorusu=false,
  bool isDenemeSorusu=false,
  bool isSinavSorusu=false,
  }) async {
  if(isGununSorusu){
    // set up POST request arguments
    String url = address+'/todays_question';
    // make POST request
    print("fetching today's question");
    Response response = await post(
      url, 
      headers:headers,
      body: json.encode({'userID':userID, "sessionID":SESSION_ID}));
    // check the status code for the result
    dynamic res = json.decode(response.body);
    res['_id']=res['questionID'];
    return res;
  } else if (isDenemeSorusu){
    // subtopic şunlardan biri olabilir:
    // T, M, ST, SC, SF, SD, FF, FK, FB, T2E, T2T, T2C, M2, S2T, S2C, S2F, S2D, F2F, F2K, F2B,
    // set up POST request arguments
    String url = address+'/generate_test';
    // make POST request
    print("fetching test question");
    Response response = await post(
      url,
      headers:headers,
      body: json.encode({'subTopic':subtopic,'sessionID':SESSION_ID})
    );
    // check the status code for the result
    dynamic res = json.decode(response.body);
    if(res['success']){
      print('test question successfully fetched');
      return res;
    } else if(res['error']=="404"){
      return null;
    } else {
      return null;
    }
    
    /* return await rootBundle.loadString("assets/cfg/sampleDenemeSorusu.json").then((str) => json.decode(str)); */
    /* return null; */
  } else if (isSinavSorusu){
    return await rootBundle.loadString("assets/cfg/sampleSinavSorusu.json").then((str) => json.decode(str));
  } else{
    return null;
  }
}

Future<dynamic> fetchQListBatch({
  /* List<dynamic> questionIDs, */
  bool forExamLobby = false,
  bool isExam = true,
  bool forResult = false,
  String subTopic,
  String examID,
  String userID}) async {
    if(forExamLobby){
      String url = address+'/todays_exam_questions';
      String postString = json.encode({'sessionID':SESSION_ID});
      print('qList query:');
      print(postString);
      dynamic res =  await trySend(postString: postString, url:url,maxTrials: 10);
      if(res['success']){
        return res['array'];
      } else {
        return null;
      }
      /* return await rootBundle.loadString("assets/cfg/sampleBatchQListExamLobby.json").then((str) => json.decode(str)); */
    } else if (forResult){
      if(isExam){
        String url = address+'/answers_by_exam';
        String postString = json.encode({'sessionID':SESSION_ID,'examID':examID});
        // check the status code for the result
        dynamic res = await trySend(postString: postString, url:url,maxTrials: 1);
        if(res['success']){
          return res['array'];
        } else {
          if(res['error']=='404'){
            return null;
          } else {
            return null; // Burada hata döndürebiliriz
          }
        }
      } else {
        String url = address+'/answers_by_subtopic';
        String postString = json.encode({'sessionID':SESSION_ID,'subTopic':subTopic});
        dynamic res = await trySend(postString: postString, url:url,maxTrials: 1);
        if(res['success']){
          print(res['array']);
          return res['array'];
        } else {
          if(res['error']=='404'){
            return null;
          } else{
            return null; // Burada hata döndürebiliriz
          }
        }
      }
  }
}

/* Future<dynamic> fetchAnswListBatch({String username,String examID}) async {
  // set up POST request arguments
  String url = address+'/review_answers';
  String postString = json.encode({'sessionID':SESSION_ID,'examID':examID});
  dynamic res =  await trySend(postString: postString, url:url,maxTrials: 3);
  if(res['success']){
    return res['array'];
  } else {
    return null;
  }
  /* return await rootBundle.loadString("assets/cfg/sampleAnswList.json").then((str) => json.decode(str)); */
} */

Future<dynamic> fetchMyResults({List<dynamic> parentExamIDs}) async {
  String url = address+'/stats_parent';
  print('sending for myresults:');
  print(json.encode({'sessionID':SESSION_ID}));
  dynamic res = await trySend(
    url:url,
    postString: json.encode({'sessionID':SESSION_ID}),
    maxTrials:3
  );
  print("response:");
  print(res);
  if(res['success']){
    return res['array'];
  } else {
    return null;
  }
}

Future<dynamic> fetchSPBData({String parentExamName}) async {
  String url = address+'/stats_spb';
  print('sending for spb data:');
  print(json.encode({"parentExamName":parentExamName,'sessionID':SESSION_ID}));
  dynamic res = await trySend(
    url:url,
    postString: json.encode({"parentExamName":parentExamName,'sessionID':SESSION_ID}),
    maxTrials:3
  );
  print("response:");
  print(res);
  if(res['success']){
    return res;
  } else {
    return null;
  }
  /* return await rootBundle.loadString("assets/cfg/sampleSPBData.json").then((str) => json.decode(str)); */
}

/* Deneme Soruları SPA'sını gösterebilmek için fetchQIDs diye bir fonksiyon var. Normal Exam SPA'ları Exam'ın içindeki questionIDs ile kotarıyor zaten*/
Future<dynamic> fetchQIDs({String username, String topic}) async {
  return await rootBundle.loadString("assets/cfg/sampleQIDsDenemeSorulari.json").then((str) => json.decode(str));
}

/* Future<dynamic> fetchDenemeSorulariStats({String username}) async {
  return await rootBundle.loadString("assets/cfg/sampleDenemeSorulariStats.json").then((str) => json.decode(str));
} */

Future<dynamic> fetchDenemeSorulariSubPanelStats({String username}) async {
  return await rootBundle.loadString("assets/cfg/sampleDenemeSorulariSubPanelStats.json").then((str) => json.decode(str));
}

Future<dynamic> fetchPieChart({String questionID}) async {
  // TODO: trysend timeout 10 sn yap
  return await rootBundle.loadString("assets/cfg/samplePieChart.json").then((str) => json.decode(str));
}

Future<dynamic> fetchTekilSiralama({String examID}) async {
  String url = address+'/single_ranking';
  print(json.encode({"examID":examID,'sessionID':SESSION_ID}));
  // TODO: ENABLE LATER
  /* dynamic res = await trySend(
    url:url,
    postString: json.encode({"examID":examID,'sessionID':SESSION_ID}),
    maxTrials:5,
    timeout: 30
  );
  if(res['success']){
    return res;
  } else {
    return null;
  } */
  // TODO: DISABLE LATER
  return await rootBundle.loadString("assets/cfg/sampleTekilSiralama.json").then((str) => json.decode(str));
}

Future<dynamic> fetchHowPage({String username, String examID}) async {
  return await rootBundle.loadString("assets/cfg/sampleHowPage.json").then((str) => json.decode(str));
}


Future<dynamic> fetchIfUserParticipatedInExam({String username, String examID}) async {
  return true;
}

Future<dynamic> fetchConfigurations() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  int versionNumber = int.parse(packageInfo.version.replaceAll('.', ''));
  String url = address+'/config';
  print('sending:');
  print(json.encode({'versionNumber':versionNumber,'sessionID':SESSION_ID}));
  dynamic res = await trySend(
    url:url,
    postString: json.encode({'versionNumber':versionNumber,'sessionID':SESSION_ID}),
    maxTrials:3
  );
  print(res);
  res["homepageNotification"] = "Anasayfa Notifikasyonudur bu"; //TODO : DELETE LATER
  res["updateExists"] = false; //TODO : DELETE LATER
  res["updateMandatory"] = false; //TODO : DELETE LATER
  res["updateExists"] = res["updateExists"] ?? false;
  res["updateMandatory"] = res["updateMandatory"] ?? false;
  if(res['updateExists']){
    APPSTORE_LINK = res['appStoreLink'];
    PLAYSTORE_LINK = res['playStoreLink'];
    PLAYSTORE_LINK = "https://www.google.com"; //TODO : DELETE LATER
    if(res['updateMandatory']){
      return 'exists_mandatory';
    } else {
      return 'exists';
    }
  }

  REVIEW_DURATION = res['reviewDuration'];
  HOLD_DURATION = res['holdDuration'];
  LOBBY_DURATION = res['lobbyDuration'];
  GRACE_PERIOD = res['gracePeriod'];
  MAXIMUM_TIME = res['maximumTime'];
  RESULT_BUFFER = res['resultBuffer'];
  LOBBY_INFO_TEXT = res['lobbyText'];
  SHOW_TODAYS_QUESTION = res['showTodaysQuestion'] ?? false;
  LOBBY_INFO_TEXT = [
    'Sınav boyunca uygulamadan çıkmaman gerekiyor',
    'İnternet bağlantını kontrol et!',
    'Bağlantın koparsa cevapların kaydedilmeyebilir',
    'Sınav bitiminde doğru cevapları ve sıralamanı görebilirsin',
    'Kopya çekmek yasak!'
  ];

  REVIEW_DURATION = 10; //TODO : DELETE LATER
  HOLD_DURATION = 3; //TODO : DELETE LATER
  LOBBY_DURATION = 20; //TODO : DELETE LATER
  GRACE_PERIOD = 10; //TODO : DELETE LATER
  MAXIMUM_TIME = 10; //TODO : DELETE LATER
  RESULT_BUFFER = 20; //TODO : DELETE LATER
  if(res["homepageNotification"]!=null){
    if(res["homepageNotification"]!="N/A"){
      showSimpleNotification(Text(res["homepageNotification"]));
    }
  }
  print('config fetched!');
  return 'correct';
}


getServerTime() async {
  String url = address+'/servertime';
  Response response = await post(url);
  return response;
}