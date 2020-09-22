import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/sign_in/email_signin_change_model.dart';
import 'package:timetracker/common_widgets/form_raised_button.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/servies/auth.dart';
import 'package:flutter/services.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({@required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
          builder: (context, model, _) =>
              EmailSignInFormChangeNotifier(model: model)),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'SignIn Failed',
        exception: e,
      ).show(context);
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8),
      _buildPasswordTextField(),
      SizedBox(height: 8),
      FormRaisedButton(
        onPressed: model.canSubmit ? _submit : null,
        text: model.primaryButtonText,
      ),
      SizedBox(height: 8),
      FlatButton(
        onPressed: !model.isLoaded ? () => _toggleFormType() : null,
        child: Text(model.secondButtonText),
      )
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoaded == false,
      ),
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
      focusNode: _passwordFocusNode,
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'user@email.com',
        errorText: model.emailErrorText,
        enabled: model.isLoaded == false,
      ),
      onChanged: model.updateEmail,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
