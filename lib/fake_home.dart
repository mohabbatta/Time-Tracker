import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/auth_new.dart';
import 'package:timetracker/home_second.dart';
import 'package:timetracker/test.dart';

class FakeHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authNew = Provider.of<AuthNew>(context);
    return StreamBuilder(
        stream: authNew.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user != null) {
              return Provider<User>.value(
                value: user,
                child: HomeSecond(),
              );
            } else {
              return Test();
            }
          }
          return Scaffold();
        });
  }
}
