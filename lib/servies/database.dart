import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class Database {
  Future<void> createJob(Map<String, dynamic> jobData);
}

class FireStoreDatabase implements Database {
  FireStoreDatabase({@required this.userID}) : assert(userID != null);
  final String userID;

  Future<void> createJob(Map<String, dynamic> jobData) async {
    final path = '/users/$userID/jobs/job_abc';
    final documentReference = Firestore.instance.document(path);
    await documentReference.setData(jobData);
  }
}
