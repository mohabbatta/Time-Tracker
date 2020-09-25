import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/home/models/job.dart';
import 'package:timetracker/common_widgets/platform_alert_dialog.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
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
    try {
      final dataBase = Provider.of<Database>(context, listen: false);
      await dataBase.createJob(Job(name: 'n', ratePerHour: '10'));
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(title: 'operation failed', exception: e)
          .show(context);
    }
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
      body: _builtContent(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createJop(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _builtContent(BuildContext context) {
    final dataBase = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
        stream: dataBase.jobStreams(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jobs = snapshot.data;
            final children = jobs.map((job) => Text(job.name)).toList();
            return ListView(children: children);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
