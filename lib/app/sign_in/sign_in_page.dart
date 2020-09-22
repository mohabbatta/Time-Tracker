import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/sign_in/email_sign_in.dart';
import 'package:timetracker/app/sign_in/sign_in_manager.dart';
import 'package:timetracker/app/sign_in/sing_in_button.dart';
import 'package:timetracker/app/sign_in/social_sigin_button.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/servies/auth.dart';

class SignInPage extends StatelessWidget {
  final SignInManager manager;
  final bool isLoading;
  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);

//  static Widget create(BuildContext context) {
//    final auth = Provider.of<AuthBase>(context);
//    return Provider<SignInBloc>(
//      create: (_) => SignInBloc(auth: auth),
//      dispose: (context, bloc) => bloc.dispose(),
//      child: Consumer<SignInBloc>(
//          builder: (context, bloc, _) => SignInPage(
//                bloc: bloc,
//              )),
//    );
//  }

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
              builder: (context, bloc, _) => SignInPage(
                    manager: bloc,
                    isLoading: isLoading.value,
                  )),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
        title: 'Sign In Failed ', exception: exception);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFaceBook(BuildContext context) async {
    try {
      await manager.signInWithFaceBook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _emailSignIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Time Tracker'),
          elevation: 2.0,
        ),
        backgroundColor: Colors.grey[200],
        body: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: _buildHeader(),
            height: 50,
          ),
          SizedBox(height: 48),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading
                ? null
                : () {
                    _signInWithGoogle(context);
                  },
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: isLoading
                ? null
                : () {
                    _signInWithFaceBook(context);
                  },
          ),
          SizedBox(height: 8),
          SingInButton(
            text: 'Sign With Email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: isLoading
                ? null
                : () {
                    _emailSignIn(context);
                  },
          ),
          SizedBox(height: 8),
          Text(
            'Or',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          SingInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: isLoading
                ? null
                : () {
                    _signInAnonymously(context);
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign In ',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
