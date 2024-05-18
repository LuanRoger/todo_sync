import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = NotifierProvider<AuthProvider, User?>(
  AuthProvider.new,
);

class AuthProvider extends Notifier<User?> {
  bool get isAuthenticated => state != null;
  late final StreamSubscription<User?> _userChangeSubscription;

  @override
  User? build() {
    final currentUser = FirebaseAuth.instance.currentUser;
    _userChangeSubscription =
        FirebaseAuth.instance.authStateChanges().listen(_updateAuthState);
    ref.onDispose(() {
      _userChangeSubscription.cancel();
    });

    return currentUser;
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }

  void _updateAuthState(User? user) {
    state = user;
  }
}
