import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/common_widgets/platform_alert_dialog.dart';
import 'package:timetracker/servies/auth.dart';
import 'package:timetracker/servies/database.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final authBase = Provider.of<AuthBase>(context, listen: false);
      await authBase.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'LogOut',
      content: 'Are You Sure That you want to Logout',
      defaultActionText: 'LogOut',
      cancelActionText: 'Cancel',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _createJop(BuildContext context) async {
    final dataBase = Provider.of<Database>(context, listen: false);
    await dataBase.createJob({'name': 'coding', 'rate': '10'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[
          FlatButton(
              onPressed: () => _confirmSignOut(context),
              child: Text(
                'LogOut',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createJop(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
