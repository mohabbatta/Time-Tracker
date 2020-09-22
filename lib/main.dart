import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/landing_page.dart';
import 'package:timetracker/servies/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(primaryColor: Colors.indigo),
        home: LandingPage(),
      ),
    );
  }
}
