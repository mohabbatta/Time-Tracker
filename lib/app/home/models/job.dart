import 'package:flutter/foundation.dart';

class Job {
  Job({@required this.name, @required this.ratePerHour, @required this.id});
  final String name;
  final int ratePerHour;
  final String id;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(name: name, ratePerHour: ratePerHour, id: documentId);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
