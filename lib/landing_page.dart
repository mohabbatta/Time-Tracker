import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/home/jobs/jobs_page.dart';
import 'package:timetracker/app/sign_in/sign_in_page.dart';
import 'package:timetracker/servies/auth.dart';
import 'package:timetracker/servies/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBase = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder(
        stream: authBase.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
            return Provider<Database>(
                create: (_) => FireStoreDatabase(uid: user.uid),
                child: JobsPage());
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
