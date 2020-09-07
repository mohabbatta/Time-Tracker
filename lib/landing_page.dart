import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/sign_in_page.dart';
import 'package:timetracker/home_page.dart';
import 'package:timetracker/servies/auth.dart';

class LandingPage extends StatelessWidget {
  LandingPage({@required this.authBase});

  final AuthBase authBase;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authBase.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage(
                authBase: authBase,
              );
            }
            return HomePage(
              authBase: authBase,
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
