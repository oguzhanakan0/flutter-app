class Answer {
  // from "answer" collection
  final String id;
  final String questionID;
  final String userID;
  final String choice;
  final DateTime time;
  
  Answer(
    this.id,
    this.questionID,
    this.userID,
    this.choice,
    this.time
  );
}