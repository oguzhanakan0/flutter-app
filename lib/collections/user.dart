class User {
  // from "user" collection
  final String id;
  String username;
  String password;
  String phoneNumber;
  String firstName;
  String lastName;
  String areaChoice;
  List<dynamic> desiredMajors;
  String schoolID;
  String schoolName;
  String city;
  String grade;
  String ppUrl;
  bool marketingCheck;
  List<dynamic> parentExamIDs;
  List<dynamic> extraQuestionIDs;
  String displaySchoolName;
  String googleUserID;
  bool phoneVerified;
  String email;
  int avatarIndex;
  User({
    this.id,
    this.googleUserID,
    this.username,
    this.password,
    this.phoneNumber,
    this.email,
    this.firstName,
    this.city,
    this.lastName,
    this.areaChoice,
    this.desiredMajors,
    this.schoolID,
    this.grade,
    this.ppUrl,
    this.schoolName,
    this.displaySchoolName,
    this.marketingCheck,
    this.parentExamIDs,
    this.extraQuestionIDs,
    this.phoneVerified,
    this.avatarIndex=0
    }
  );
}