class ParentExam {
  // from "parentExam" collection
  final String id;
  final List<String> examIDs;
  final DateTime examStartDate;
  final DateTime examEndDate;
  final String parentExamName;

  ParentExam({
    this.id,
    this.examStartDate,
    this.examEndDate,
    this.examIDs,
    this.parentExamName
  });
}