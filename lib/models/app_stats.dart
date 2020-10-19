import 'package:cloud_firestore/cloud_firestore.dart';

class Stats {
  final int userCount;
  Stats({this.userCount});

  Stats.fromSnapshot(DocumentSnapshot snapShot) :
    userCount = snapShot['users'] ?? 0;
}