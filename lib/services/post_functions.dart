import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/collections/user.dart';
import 'package:Optik/collections/globals.dart';
import 'dart:convert';
import 'package:Optik/services/convert_functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:overlay_support/overlay_support.dart';


// THIS IS FOR RETRYING REQUEST IF INTERNET CONNECTION IS GONE. IT IS USED IN NEARLY ALL POST FUNCTIONS
Future<dynamic> trySend({String url, String postString, int maxTrials = 5, int timeout = 4}) async {
  int i = 0;
  while(true){
    if(i==maxTrials){
      showSimpleNotification(
        Text('İşlem başarısız oldu. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.', style: o.TextStyles.optikBody1White,),
        contentPadding: EdgeInsets.symmetric(horizontal:8.0)
      );
      break;
    }
    else{
      if(i==3){
        showSimpleNotification(
          Text('İşlem olması gerekenden çok daha uzun sürüyor. Lütfen internet bağlantınızı kontrol edin.',style: o.TextStyles.optikBody1White,),
          autoDismiss:false,
          contentPadding: EdgeInsets.symmetric(horizontal:8.0),
          trailing: Builder(builder: (context) {
          return FlatButton(
              textColor: Colors.yellow,
              onPressed: () {
                OverlaySupportEntry.of(context).dismiss();
              },
              child: Text('Tamam'));
          })
        );
      }
      try{
        Response response = await post(
          url,
          headers:headers,
          body:postString).timeout(Duration(seconds: timeout));
        dynamic res = json.decode(response.body);
        return res;
      } catch(e){
        await Future.delayed(Duration(seconds:2));
        i++;
      }
    }
  }
  return {"success":false,"error":"ERROR_NO_INTERNET"};
}

Future<bool> sendAnswer({String userID, String answer, String questionID, bool isExam = true, String examID}) async{
  String postString;
  String url;
  if(!isExam){
    url = address+'/answer_test_question';
    postString = json.encode(
      {
        "userID":userID,
        "questionID":questionID,
        "userChoice":answer==null?"X":answer,
        "sessionID":SESSION_ID
      }
    );
    dynamic res = await trySend(postString: postString, url:url,maxTrials: 1);
    return res['success'];
  }else {
    // IF THIS IS AN EXAM ANSWER, FIRST DEFINE THE POSTSTRING
    url = address+'/answer_exam_question';
    postString = json.encode(
      {
        "userID":userID,
        "questionID":questionID,
        "userChoice":answer==null?"X":answer,
        "examID":examID,
        "sessionID":SESSION_ID
      }
    );
    int i = 1;
    // NOW, POST THE ANSWER
    while(true){
      // IF WE ARE ON REVIEW PAGE, DON'T SEND THE ANSWER
      if(ON_REVIEW){
        print('[ANSWER_EXAM_QUESTION] Reached to review page. breaking..');
        break;
      } else {
        try {
          Response response = await post(
            url,
            headers:headers,
            body:postString);
          dynamic res = json.decode(response.body);
          print('[ANSWER_EXAM_QUESTION] successful');
          return res['success'];
        } catch (e){
          if(i==6){
            print('[ANSWER_EXAM_QUESTION] reached maximum trials. breaking...');
            break;
          } else {
            print('[ANSWER_EXAM_QUESTION] NOT successful');
            await Future.delayed(Duration(seconds: i*3));
            i++;
          }
        }
      }
    }
  }
  return null;
}

Future<bool> sendAnswersInBatch({String userID, var qList, String examID}) async{
  String url = address+'/batch_answer_exam_questions';
  var postList = [];
  for(var i in qList){
    postList.add(
      {
        "questionID":i.questionID,
        "userChoice":i.userChoice
      }
    );
  }
  var postString = json.encode(
    {
      "examID":examID,
      'sessionID':SESSION_ID,
      "userID":userID,
      "answers":postList,
    }
  );
  print("Answers submiting in batch:");
  print(postString);
  dynamic res = await trySend(postString: postString, url:url,maxTrials: 3);
  // Soruları başarılı bir şekilde postlayabilmişsek true, hata olduysa false dönebilir. Ama hata olmaması lazım :)
  return res["success"];
}

Future<dynamic> sendLoginInfo({String userID, String token}) async {
  String postString;
  String url;
  url = address+'/login';
  postString = json.encode(
    {
      "userID":userID,
      "userToken":token
    }
  );
  dynamic res = await trySend(postString: postString, url:url);
  if(res['success']){
    SESSION_ID = res['sessionID'];
    return convertUser(res);
  } else{
    return null;
  }
}

Future<bool> postUserDemographics({User user, String token, String sessionID}) async {
  String postString;
  String url;
  
  url = address+'/verify_user';
  postString = json.encode(
    {
      "username":user.username,
      "password":user.password,
      "phoneNumber":user.phoneNumber,
      "email":user.email,
      "firstName":user.firstName,
      "city":user.city,
      "lastName":user.lastName,
      "areaChoice":user.areaChoice,
      "desiredMajors":user.desiredMajors==null?[]:user.desiredMajors,
      "grade":user.grade,
      "schoolName":user.schoolName,
      "displaySchoolName":user.displaySchoolName,
      "userID":user.googleUserID,
      "avatarIndex":user.avatarIndex,
      "sessionID":SESSION_ID,
      "phoneToken":token,
    }
  );
  dynamic res =  await trySend(postString: postString, url:url);
  return(res['success']);
}

Future<bool> isUsernameAvailable({String username}) async {
  String postString;
  String url;
  url = address+'/check_username';
  postString = json.encode(
    {
      "username":username,
      "sessionID":SESSION_ID,
    }
  );
  dynamic res = await trySend(postString: postString, url:url,maxTrials: 1);
  if(res['success']){
    return true;
  } else {
    if(res['error']!=null){
      if(res['error']=='406'){showSimpleNotification(Text('Bu kullanıcı adı sistemde mevcut. Lütfen farklı bir kullanıcı adı seçin.'));}
    }
    return false;
  }
}

Future<dynamic> optikCreateUser({String userID, String token}) async{
  String postString;
  String url;
  
  url = address+'/new_user';
  postString = json.encode(
    {
      "userID":userID,
      "token":token
    }
  );
  dynamic res = await trySend(postString: postString, url:url, maxTrials: 2);
  if(res['success']){
    SESSION_ID = res['sessionID'];
    return true;
  } else {
    if(res['error']!=null){
      showSimpleNotification(Text('Kullanıcı yaratılırken bir problem oluştu. Lütfen tekrar deneyin.'));
    }
    return false;
  }
}

Future<bool> updateOptikDBEmail({String userID, String newEmail}) async {
  String postString;
  String url;
  url = address+'/update_user_info';
  postString = json.encode(
    {
      "userID":userID,
      "email":newEmail,
      "sessionID":SESSION_ID
    }
  );
  dynamic res = await trySend(postString: postString, url:url);
  if(res['success']){
    showSimpleNotification(Text('Email adresiniz başarıyla değiştirildi.'));
    return true;
  } else {
    if(res['error']!=null){
      if(res['error']=='500'){
        showSimpleNotification(Text('Email adresini güncellerken bir hata oluştu. Lütfen tekrar deneyin.'));
      }
    }
    return false;
  }
}

Future<bool> sendHelpMessage({String username, String message, String contactChoice}) async {
  /* String postString = json.encode(
    {
      "username":username,
      "message":message,
      "contactChoice":contactChoice,
      'sessionID':SESSION_ID,
    }
  ); */
  return true;
}

Future<bool> sendChangeAreaInfo({String userID, String areaChoice}) async {
  String url= address+'/update_user_info';
  String postString = json.encode(
    {
      "userID":userID,
      "areaChoice":areaChoice,
      "sessionID": SESSION_ID
    }
  );
  dynamic res = await trySend(postString: postString, url:url,maxTrials: 2);
  if(res['success']){
    showSimpleNotification(Text("Alan seçeneğiniz başarıyla değiştirildi."));
    return true;
  } else {
    if(res['error'] == null){
      if(res['error']!='ERROR_NO_INTERNET'){
        showSimpleNotification(Text('Alan seçeneğinizi güncellerken bir hata oluştu. Lütfen tekrar deneyin.'));
      }
    }
    return false;
  }
}
