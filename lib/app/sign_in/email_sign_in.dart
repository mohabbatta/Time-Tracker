import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/email_signin_form_change_notifier.dart';

class EmailSignIn extends StatelessWidget {
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
              child: EmailSignInFormChangeNotifier.create(context),
            )),
      ),
    );
  }
}
