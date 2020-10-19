import 'dart:collection';

import 'package:Optik/collections/exam.dart';
import 'package:Optik/collections/globals.dart';
import 'package:Optik/collections/parentExam.dart';
import 'package:Optik/collections/pie_stat.dart';
import 'package:Optik/collections/question.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:Optik/collections/user.dart';

User convertUser(Map<String,dynamic> response) {
  User user = User(
    id:response['_id'],
    username:response['username'],
    password:response['password'],
    phoneNumber:response['phoneNumber'],
    email:response['email']!=null?response['email']:'',
    firstName:response['firstName'],
    city:response['city'],
    lastName:response['lastName'],
    areaChoice:response['areaChoice'],
    desiredMajors:response['desiredMajors'],
    schoolID:response['schoolID'],
    grade:response['grade'],
    ppUrl:response['ppUrl'],
    schoolName:response['schoolName'],
    displaySchoolName:response['displaySchoolName'],
    marketingCheck:response['marketingCheck'],
    googleUserID: response['userID'],
    parentExamIDs:response['parentExamIDs'],
    extraQuestionIDs:response['extraQuestionIDs'],
    phoneVerified: response['phoneVerified'],
    avatarIndex: response['avatarIndex']??0
    );
  return user;
}
  
Exam convertExam(Map<String,dynamic> response){
  Exam exam = Exam(
    examID:response['_id'],
    questionIDs:response['questionIDs'],
    parentExamID:response['parentExamID'],
    examDate: DateTime.parse(response['examDate']),
    parentTopic:response['parentTopic'],
    topic:response['topic'],
    nQuestions:response['nQuestions'],
    subjectMap:response['subjectMap'],
    isMakeup:response['isMakeup'],
    parentExamName:response['parentExamName'],
    lobbyAd: response['lobbyAd'],
    persistentAd: response['persistentAd'],
    reviewDuration:REVIEW_DURATION,
    lastExam: response['lastExam'],
    implementMaximumTime: response['implementMaximumTime']??false
  );
  return exam;
}

ParentExam convertParentExam(Map<String,dynamic> response){
  ParentExam parentExam = ParentExam(
    id:response['id'],
    examStartDate:DateTime.parse(response['examStartDate']),
    examEndDate:DateTime.parse(response['examEndDate']),
    examIDs:response['examIDs'],
    parentExamName:response['parentExamName'],
  );
  return parentExam;
}

Question convertQuestion(Map<String,dynamic> response){
  if(response==null){
    return null;
  } else {
    DateTime deadline = response['deadline']==null?null:DateTime.parse(response['deadline']);
    DateTime answerTime = response['answerTime']==null?null:DateTime.parse(response['answerTime']);
    Question question = Question(
      questionID:response['_id'],
      examID:response['examID'],
      parentExamID:response['parentExamID'],
      header1:response['header1'],
      header2:response['header2'],
      body:response['body'],
      choices:response['choices'],
      correctChoice:response['correctChoice'],
      userChoice:response['userChoice'],
      isTappable:response['userChoice']==null?false:true,
      order:response['order'],
      subject:response['subject'],
      parentSubject:response['parentSubject'],
      imageUrl:response['imageUrl'],
      duration:response['duration'],
      footer:response['footer'],
      deadline:deadline,
      answerTime:answerTime
    );
    return question;
  }
}

List<ChartData> convertPieChart(Map<String,dynamic> response){
  List<ChartData> res = [];
  for (var i in response.keys){
    res.add(ChartData(int.parse(i),response[i]));
  }
  return res;
}

Future<dynamic> fetchQList({
  String username,
  List<dynamic> questionIDs,
  bool forResult = false,
  bool isExam = true,
  bool forExamLobby = false,
  String subTopic,
  String examID,
  String userID}) async {
  
  Map<int,Question> qList = {};
  Map<dynamic,Question> qList2 = {};
  if(forResult){
    if(isExam){
      dynamic response = await fetchQListBatch(forResult:true,examID:examID,userID:userID);
      if(response!=null){
        for (var i in response){
          qList[i['order']] = convertQuestion(i);
          
        }
        print(qList.keys.toList());
        return SplayTreeMap<int,dynamic>.from(qList, (a, b) => a.compareTo(b));
      } else {
        return null;
      }
    } else {
      dynamic response = await fetchQListBatch(userID:userID,subTopic:subTopic,forResult:true,isExam:isExam);
      if(response!=null){
        for (var i in response){
          qList2[i['answerTime']] = convertQuestion(i);
          
        }
        return SplayTreeMap<dynamic,dynamic>.from(qList2);
      } else {
        return null;
      }
    }
  } else if(forExamLobby){
    dynamic response = await fetchQListBatch(forExamLobby:true);
    if(response!=null){
      for (var i in response){
        print(i['order']);
        qList[i['order']] = convertQuestion(i);
        
      }
    }
    print(qList.keys.toList());
    return SplayTreeMap<int,dynamic>.from(qList, (a, b) => a.compareTo(b));
  } 
  
  else{
    return null;
  }
}