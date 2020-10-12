import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/home/job_entries/job_entries_page.dart';
import 'package:timetracker/app/home/jobs/edit_jobs_page.dart';
import 'package:timetracker/app/home/jobs/job_list_tile.dart';
import 'package:timetracker/app/home/jobs/list_item_builder.dart';
import 'package:timetracker/app/home/models/job.dart';
import 'package:timetracker/common_widgets/platform_alert_dialog.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/servies/auth.dart';
import 'package:timetracker/servies/database.dart';

class JobsPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final dataBase = Provider.of<Database>(context, listen: false);
      await dataBase.deleteJob(job);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'operation Failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => EditJobPage.show(context,
                database: Provider.of<Database>(context, listen: false)),
          ),
        ],
      ),
      body: _builtContent(context),
    );
  }

  Widget _builtContent(BuildContext context) {
    final dataBase = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
        stream: dataBase.jobsStream(),
        builder: (context, snapshot) {
          return ListItemBuilder<Job>(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible(
              key: Key('job-${job.id}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _delete(context, job),
              child: JobListTile(
                job: job,
                onTap: () => JobEntriesPage.show(context, job),
              ),
            ),
          );
        });
  }
}
