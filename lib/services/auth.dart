import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users? _userFromFirebaseUser(User? user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  Future logInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      AlertDialog(
        content: Text('$e'),
      );
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      AlertDialog(
        content: Text('$e'),
      );
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      AlertDialog(
        content: Text('$e'),
      );
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      AlertDialog(
        content: Text('$e'),
      );
    }
  }
}
