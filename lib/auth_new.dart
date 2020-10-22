import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User({@required this.uid, this.name, this.url, this.email});
  final String uid;
  final String name;
  final String url;
  final String email;
}

class AuthNew {
  var firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
        uid: user.uid,
        name: user.displayName,
        url: user.photoUrl,
        email: user.email);
  }

  Stream<User> get onAuthStateChanged {
    return firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<AuthResult> signInWithFaceBook() async {
    final faceBookLogIn = FacebookLogin();
    final result = await faceBookLogIn.logInWithReadPermissions(
      ['public_profile', 'email'],
    );
    if (result.accessToken != null) {
      final authResult = await firebaseAuth
          .signInWithCredential(FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      ));
      _userFromFirebase(authResult.user);
      print(authResult.user.email);
      return authResult;
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'sign in aborted by user');
    }
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final faceBookLogIn = FacebookLogin();
    await faceBookLogIn.logOut();
    await firebaseAuth.signOut();
  }
}
