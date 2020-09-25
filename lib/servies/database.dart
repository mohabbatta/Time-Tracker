import 'package:flutter/foundation.dart';
import 'package:timetracker/app/home/models/job.dart';
import 'package:timetracker/servies/api_path.dart';
import 'package:timetracker/servies/firstore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobStreams();
}

class FireStoreDatabase implements Database {
  FireStoreDatabase({@required this.userID}) : assert(userID != null);
  final String userID;

  final _service = FireStoreService.instance;

  Stream<List<Job>> jobStreams() => _service.collectionStream(
        path: ApiPath.jobs(userID),
        builder: (data) => Job.fromMap(data),
      );

  Future<void> createJob(Job job) async => _service.setData(
        path: ApiPath.job(userID, 'job_abc'),
        data: job.toMap(),
      );
}
