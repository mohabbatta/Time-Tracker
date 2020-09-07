import 'package:flutter/material.dart';
import 'package:timetracker/servies/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.authBase});
  final AuthBase authBase;

  Future<void> _signOut() async {
    try {
      await authBase.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        actions: <Widget>[
          FlatButton(
              onPressed: _signOut,
              child: Text(
                'LogOut',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
    );
  }
}
