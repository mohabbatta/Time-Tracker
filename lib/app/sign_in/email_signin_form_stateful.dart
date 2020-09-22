import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/sign_in/email_signin_model.dart';
import 'package:timetracker/app/sign_in/validator.dart';
import 'package:timetracker/common_widgets/form_raised_button.dart';
import 'package:timetracker/common_widgets/platform_alert_dialog.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/servies/auth.dart';
import 'package:flutter/services.dart';

class EmailSignInFormStateful extends StatefulWidget
    with EmailPasswordValidator {
  @override
  _EmailSignInFormStatefulState createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  EmailSignInformType _formType = EmailSignInformType.signIn;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  Future<void> _submit() async {
    final authBase = Provider.of<AuthBase>(context, listen: false);
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      if (_formType == EmailSignInformType.signIn) {
        await authBase.signInWithEmailAndPassword(_email, _password);
      } else {
        await authBase.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'SignIn Failed',
        exception: e,
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInformType.signIn
          ? EmailSignInformType.register
          : EmailSignInformType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInformType.signIn
        ? 'Sign In'
        : 'Create a new account';
    final secondText = _formType == EmailSignInformType.signIn
        ? 'Need an Account? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.emailValidator.isValid(_password) &&
        !_isLoading;
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 8,
      ),
      FormRaisedButton(
        onPressed: submitEnabled ? _submit : null,
        text: primaryText,
      ),
      SizedBox(
        height: 8,
      ),
      FlatButton(
        onPressed: _toggleFormType,
        child: !_isLoading ? Text(secondText) : null,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.passwordError : null,
        enabled: _isLoading == false,
      ),
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
      focusNode: _passwordFocusNode,
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'user@email.com',
        errorText: showErrorText ? widget.emailError : null,
        enabled: _isLoading == false,
      ),
      onChanged: (email) => _updateState(),
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
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

  void _updateState() {
    setState(() {});
  }
}
