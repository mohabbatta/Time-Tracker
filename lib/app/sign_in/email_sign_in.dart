import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/email_signin_form.dart';
import 'package:timetracker/servies/auth.dart';

class EmailSignIn extends StatelessWidget {
  EmailSignIn({@required this.authBase});
  final AuthBase authBase;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              child: EmailSignInForm(
                authBase: authBase,
              ),
            )),
      ),
    );
  }
}
