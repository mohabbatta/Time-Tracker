import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/auth_new.dart';
import 'package:timetracker/next.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  String user = " ";
  String newUser = " ";
  var firebaseAuth = FirebaseAuth.instance;

  Future<void> signInGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleSignInAccount = await googleSignIn.signIn();
    //googleSignInAccount.clearAuthCache();
    if (googleSignInAccount != null) {
      try {
        final googleAuth = await googleSignInAccount.authentication;
        if (googleAuth.idToken != null && googleAuth.accessToken != null) {
          final authResult = await firebaseAuth.signInWithCredential(
              GoogleAuthProvider.getCredential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          print(authResult);

          if (authResult != null) {
            if (newUser == "true") {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => Next(),
                ),
              );
            } else {
              setState(() {
                user = authResult.user.displayName;
                newUser = authResult.additionalUserInfo.isNewUser.toString();
              });
            }
          }
        } else {
          throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH',
            message: 'Missing Google Auth Token ',
          );
        }
      } catch (e) {
        print(e.toString());
        final googleSignIn = GoogleSignIn();
        //  final googleSignInAccount = await googleSignIn.signIn();
        googleSignIn.signInSilently(suppressErrors: false);
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'SIGN IN ABOURTED BY USER ',
      );
    }
  }

//  void signInFace() async {
//    final authNew = Provider.of<AuthNew>(context, listen: false);
//    var authResult = await authNew.signInWithFaceBook();
//    if (authResult != null) {
//      setState(() {
//        user = authResult.user.displayName;
//        newUser = authResult.additionalUserInfo.isNewUser.toString();
//      });
//      if (newUser == "true") {
//        Navigator.of(context).push(
//          MaterialPageRoute(
//            fullscreenDialog: true,
//            builder: (context) => Next(),
//          ),
//        );
//      }
//    }
//  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
//    final faceBookLogIn = FacebookLogin();
//    await faceBookLogIn.logOut();
    await firebaseAuth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                await signInGoogle();
              },
              child: Text('press'),
            ),
            Text(user),
            Text(newUser.toString()),
            FlatButton(
              onPressed: () {
                signOut();
              },
              child: Text('face'),
            )
          ],
        ),
      ),
    );
  }
}
