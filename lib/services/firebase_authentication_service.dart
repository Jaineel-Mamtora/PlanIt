import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import 'package:plan_it/locator.dart';
import 'package:plan_it/constants.dart';
import 'package:plan_it/ui/views/login_view.dart';
import 'package:plan_it/services/navigation_service.dart';
import 'package:plan_it/services/local_storage_service.dart';

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
      Fluttertoast.showToast(msg: AuthConstants.PLEASE_FILL_ALL_THE_DETAILS);

      return false;
    }
    if (!EmailValidator.validate(email)) {
      Fluttertoast.showToast(
        msg: AuthConstants.PLEASE_ENTER_A_VALID_EMAIL_ADDRESS,
      );

      return false;
    }
    if (password != confirmPassword) {
      Fluttertoast.showToast(
        msg: AuthConstants.PASSWORD_DO_NOT_MATCH,
      );

      return false;
    }
    if (password.length < 6) {
      Fluttertoast.showToast(
        msg: AuthConstants.PASSWORD_LENGTH_ATLEAST_SIX_CHARACTERS,
      );
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
          return AuthConstants.NOT_VERIFIED;
        } else {
          _localStorageService.isLoggedIn = true;
          return true;
        }
      }
    } catch (e) {
      switch (e.message) {
        case AuthConstants.ERROR_EMAIL_ALREADY_IN_USE:
          Fluttertoast.showToast(
            msg: AuthConstants.EMAIL_ALREADY_LINKED_TO_ACCOUNT,
          );
          break;
        default:
          Fluttertoast.showToast(
            msg: AuthConstants.REGISTRATION_PROBLEM,
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
        msg: AuthConstants.PLEASE_FILL_ALL_THE_DETAILS,
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
      Fluttertoast.showToast(
        msg: AuthConstants.PLEASE_ENTER_YOUR_EMAIL_ADDRESS,
      );
      return;
    }
    if (!EmailValidator.validate(email)) {
      Fluttertoast.showToast(
        msg: AuthConstants.PLEASE_ENTER_A_VALID_EMAIL_ADDRESS,
      );
      return;
    }
    try {
      _auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: AuthConstants.PASSWORD_RESET_MAIL_SENT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
      _navigationService.pushNamedAndRemoveUntil(
        LoginView.routeName,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: AuthConstants.ERROR_SENDING_MAIL_PLEASE_TRY_LATER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void sendVerificationMail() async {
    try {
      var user = _auth.currentUser;
      await user.sendEmailVerification();
      Fluttertoast.showToast(msg: AuthConstants.EMAIL_SENT);
    } catch (e) {
      Fluttertoast.showToast(
        msg: AuthConstants.ERROR_SENDING_MAIL_PLEASE_TRY_LATER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
