import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// return 값이 null인 경우 로그아웃 상태
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // sign up
  void signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required Function() onSuccess,
    required Function(String err) onError,
  }) async {
    if (email.isEmpty) {
      onError("Enter your email.");
      return;
    } else if (password.isEmpty || confirmPassword.isEmpty || password.length < 6) {
      onError("Enter your password at least 6 characters.");
      return;
    } else if (password != confirmPassword) {
      onError("Passwords do not match!");
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      await _firestore.collection("members").doc(user!.uid).set({
        "uid": user.uid,
        "email": user.email,
      });

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.code);
    }
  }

  // login
  void signIn({
    required String email,
    required String password,
    required Function() onSuccess,
    required Function(String err) onError,
  }) async {
    if (email.isEmpty) {
      onError("Enter your email.");
      return;
    } else if (password.isEmpty) {
      onError("Enter your password.");
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      onSuccess();
      notifyListeners(); // 로그인 상태 변경 알림
    } on FirebaseAuthException catch (e) {
      onError(e.code);
    }
  }

  // logout
  void logout() async {
    await _auth.signOut();
    notifyListeners(); // 로그아웃 상태 변경 알림
  }
}
