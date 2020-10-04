import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timetracker/app/home/models/job.dart';
import 'package:timetracker/common_widgets/platform_alert_dialog.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/servies/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(
    BuildContext context, {
    Database database,
    Job job,
  }) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditJobPage(
        database: database,
        job: job,
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _ratePerHourFocusNode = FocusNode();

  String _name;
  int _ratePerHour;

  bool _validateSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  void _onEditComplete() {
    final newFocus = _name.isEmpty ? _ratePerHourFocusNode : _nameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
    //TODO create FocusScope and loading state
  }

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
      print(_name + " " + "$_ratePerHour");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: <Widget>[
          FlatButton(
              onPressed: _submit,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ))
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _formChildren(),
      ),
    );
  }

  List<Widget> _formChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job Name'),
        validator: (value) => value.isNotEmpty ? null : "Name Can\' be empty",
        initialValue: _name,
        onSaved: (value) => _name = value,
        focusNode: _nameFocusNode,
        onEditingComplete: () => _onEditComplete,
        textInputAction: TextInputAction.next,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate Per Hour'),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        focusNode: _ratePerHourFocusNode,
        onEditingComplete: () => _submit(),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
      )
    ];
  }
}
