import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/auth_new.dart';

class HomeSecond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authNew = Provider.of<AuthNew>(context);
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user.name ?? " "),
            Text(user.email ?? " "),
            Text(user.url ?? " "),
            Center(
              child: FlatButton(
                  onPressed: () async {
                    await authNew.signOut();
                  },
                  child: Text('data')),
            ),
          ],
        ),
      ),
    );
  }
}
