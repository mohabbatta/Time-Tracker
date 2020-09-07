import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFaceBook();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final googleAuth = await googleSignInAccount.authentication;

      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH',
          message: 'Missing Google Auth Token ',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'SIGN IN ABOURTED BY USER ',
      );
    }
  }

  @override
  Future<User> signInWithFaceBook() async {
    final faceBookLogIn = FacebookLogin();
    final result = await faceBookLogIn.logInWithReadPermissions(
      ['public_profile'],
    );
    if (result.accessToken != null) {
      final authResult = await _firebaseAuth
          .signInWithCredential(FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      ));
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'sign in aborted by user');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final faceBookLogIn = FacebookLogin();
      await faceBookLogIn.logOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
