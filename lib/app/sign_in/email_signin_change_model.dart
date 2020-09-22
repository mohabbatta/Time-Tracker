import 'package:flutter/cupertino.dart';
import 'package:timetracker/app/sign_in/email_signin_model.dart';
import 'package:timetracker/app/sign_in/validator.dart';
import 'package:timetracker/servies/auth.dart';

class EmailSignInChangeModel with EmailPasswordValidator, ChangeNotifier {
  EmailSignInChangeModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInformType.signIn,
    this.isLoaded = false,
    this.submitted = false,
    @required this.auth,
  });

  String email;
  String password;
  EmailSignInformType formType;
  bool isLoaded;
  bool submitted;
  final AuthBase auth;

  Future<void> submit() async {
    updateWith(submitted: true, isLoaded: true);
    try {
      if (formType == EmailSignInformType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoaded: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    updateWith(
      email: '',
      password: '',
      formType: formType == EmailSignInformType.signIn
          ? EmailSignInformType.register
          : EmailSignInformType.signIn,
      submitted: false,
      isLoaded: false,
    );
  }

  String get primaryButtonText {
    return formType == EmailSignInformType.signIn
        ? 'Sign In'
        : 'Create a new account';
  }

  String get secondButtonText {
    return formType == EmailSignInformType.signIn
        ? 'Need an Account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoaded;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? passwordError : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? emailError : null;
  }

  void updateWith({
    String email,
    String password,
    EmailSignInformType formType,
    bool isLoaded,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoaded = isLoaded ?? this.isLoaded;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
