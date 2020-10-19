import 'package:Optik/collections/globals.dart';

class Question {
  // ui elements
  final String questionID; // should go
  final String examID; // should go
  final String parentExamID; // should go
  final String parentSubject; // should go
  final String header1; // should go
  final String header2; // should go
  final int order; // should stay
  bool isTappable; //should stay
  String userChoice; // should stay
  int holdDuration = HOLD_DURATION; // should stay
  
  // from "question" collection
  final String id;
  final bool isUsed;
  final String header;
  final String body;
  final String footer;
  final String imageUrl;
  final dynamic choices; //Map<String,String> orijinal formatı bu
  final String correctChoice;
  int duration;
  final String parentTopic;
  final String topic;
  final String subTopic;
  final String subject;
  final bool isGununSorusu;
  final DateTime deadline;
  DateTime answerTime;
  Question({
    this.id,
    this.isUsed,
    this.questionID, 
    this.examID, 
    this.parentExamID, 
    this.header,
    this.body, 
    this.footer,
    this.choices, 
    this.correctChoice,
    this.order,
    this.subject,
    this.parentSubject,
    this.header1,
    this.header2,
    this.imageUrl,
    this.duration,
    this.parentTopic,
    this.topic,
    this.subTopic,
    this.isGununSorusu,
    this.userChoice = 'X',
    this.isTappable = true,
    this.deadline,
    this.answerTime,
    }
  );
}