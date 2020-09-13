import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/email_sign_in.dart';
import 'package:timetracker/app/sign_in/sing_in_button.dart';
import 'package:timetracker/app/sign_in/social_sigin_button.dart';
import 'package:timetracker/servies/auth.dart';

class SignInPage extends StatelessWidget {
  SignInPage({@required this.authBase});
  final AuthBase authBase;

  Future<void> _signInAnonymously() async {
    try {
      await authBase.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await authBase.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithFaceBook() async {
    try {
      await authBase.signInWithFaceBook();
    } catch (e) {
      print(e.toString());
    }
  }

  void _emailSignIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignIn(
          authBase: authBase,
        ),
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
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign In ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 48),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: _signInWithGoogle,
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: _signInWithFaceBook,
          ),
          SizedBox(height: 8),
          SingInButton(
            text: 'Sign With Email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: () {
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
            onPressed: _signInAnonymously,
          ),
        ],
      ),
    );
  }
}
