import 'package:flutter/foundation.dart';

class Job {
  Job({@required this.name, @required this.ratePerHour});
  final String name;
  final String ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String ratePerHour = data['final String ratePerHour'];
    return Job(name: name, ratePerHour: ratePerHour);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
