class Exam {
  // ui elements
  final String name; // should go
  final String date; // should go
  final String description; // should go 
  final String examID; // should go
  final String soruSayisi = '20'; // should go

  // from "exam" collection
  final String id;
  final List<dynamic> questionIDs;
  final String parentExamID;
  final DateTime examDate;
  final String parentTopic;
  final String topic;
  final int nQuestions;
  final dynamic subjectMap; // Map<String,List<dynamic>> formatı bu
  final bool isMakeup;
  final String parentExamName;
  final bool lastExam;
  final bool implementMaximumTime;
  final String lobbyAd;
  final String persistentAd;
  int reviewDuration;

  Exam(
    {this.id,
    this.name, 
    this.date, 
    this.description, 
    this.parentExamID,
    this.examID,
    this.examDate,
    this.parentTopic,
    this.topic,
    this.questionIDs, 
    this.subjectMap,
    this.isMakeup,
    this.nQuestions,
    this.parentExamName,
    this.lastExam,
    this.lobbyAd,
    this.persistentAd,
    this.reviewDuration = 180,
    this.implementMaximumTime = false,
    });
}