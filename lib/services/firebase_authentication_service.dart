import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import 'package:PlanIt/locator.dart';
import 'package:PlanIt/ui/views/login_view.dart';
import 'package:PlanIt/services/navigation_service.dart';
import 'package:PlanIt/services/local_storage_service.dart';

class FirebaseAuthenticationService {
  final _auth = FirebaseAuth.instance;
  final _localStorageService = locator<LocalStorageService>();
  final _navigationService = locator<NavigationService>();

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String confirmPassword,
  }) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill up all the fields.');

      return false;
    }
    if (!EmailValidator.validate(email)) {
      Fluttertoast.showToast(msg: 'Please enter a valid email address.');

      return false;
    }
    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: 'Passwords do not match.');

      return false;
    }
    if (password.length < 6) {
      Fluttertoast.showToast(
          msg: 'Password must be atleast 6 characters long.');
      return false;
    }
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (authResult.user != null) {
        sendVerificationMail();
        if (!authResult.user.emailVerified) {
          return 'Not Verified';
        } else {
          _localStorageService.isLoggedIn = true;
          return true;
        }
      }
    } catch (e) {
      switch (e.message) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          Fluttertoast.showToast(
            msg: 'This email is linked to an existing account',
          );
          break;
        default:
          Fluttertoast.showToast(
            msg: 'Registration Problem!',
          );
      }
      return;
    }
  }

  Future signInWithEmail({
    @required String email,
    @required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill up all the fields.',
      );
      return false;
    }

    try {
      var user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user != null) {
        _localStorageService.isLoggedIn = true;
        return true;
      }
      return user != null;
    } catch (e) {
      Fluttertoast.showToast(msg: e.message);
      return;
    }
  }

  Future<void> signOut() async {
    _localStorageService.isLoggedIn = false;
    await _auth.signOut();
    _navigationService.pushNamedAndRemoveUntil(
      LoginView.routeName,
    );
  }

  void sendPasswordResetEmail(String email) {
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your Email Address!");
      return;
    }
    if (!EmailValidator.validate(email)) {
      Fluttertoast.showToast(msg: "Please enter a valid Email Address!");
      return;
    }
    try {
      _auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: "Password reset mail sent!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
      _navigationService.pushNamedAndRemoveUntil(
        LoginView.routeName,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error sending mail! Please try later",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void sendVerificationMail() async {
    try {
      var user = _auth.currentUser;
      await user.sendEmailVerification();
      Fluttertoast.showToast(msg: 'Email sent!');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error sending email! Try later!',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
