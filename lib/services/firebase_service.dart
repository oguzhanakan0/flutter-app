import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Optik/models/app_stats.dart';

class FirebaseService {

  final StreamController<Stats> _statsController = StreamController<Stats>.broadcast();
  FirebaseService(){
    
    Firestore.instance // Get the firebase instance
          .collection('info') // Get the informations collection
          .document('project_stats') // Get the project_stats document
          .snapshots() // Get the Stream of DocumentSnapshot
          .listen(_statsUpdated); // Listen to it and conver
  }

  Stream<Stats> get appStats => _statsController.stream.asBroadcastStream();

  void _statsUpdated(DocumentSnapshot snapShot){
    _statsController.add(Stats.fromSnapshot(snapShot));
  }
}