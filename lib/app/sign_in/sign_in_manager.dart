import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:timetracker/servies/auth.dart';

class SignInManager {
  SignInManager({@required this.isLoading, @required this.auth});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

//  final StreamController<bool> _isLoadingController = StreamController<bool>();
//  Stream<bool> get isLoadingStream => _isLoadingController.stream;
//
//  void dispose() {
//    _isLoadingController.close();
//  }
//
//  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      // _setIsLoading(true);
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      //_setIsLoading(false);
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);
  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
  Future<User> signInWithFaceBook() async =>
      await _signIn(auth.signInWithFaceBook);
}
