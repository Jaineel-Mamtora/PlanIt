import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:PlanIt/locator.dart';
import 'package:PlanIt/constants.dart';
import 'package:PlanIt/ui/views/home_view.dart';
import 'package:PlanIt/viewmodels/base_viewmodel.dart';
import 'package:PlanIt/services/navigation_service.dart';
import 'package:PlanIt/services/firebase_authentication_service.dart';

class VerificationViewModel extends BaseViewModel {
  final _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _auth = FirebaseAuth.instance;

  Future<void> onModelReady() async {}

  void refresh(BuildContext context) async {
    var user = _auth.currentUser;
    await user.reload();
    user = _auth.currentUser;
    if (user.emailVerified) {
      Fluttertoast.showToast(
        msg: AuthConstants.EMAIL_VERIFIED,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      _navigationService.pushReplacementNamed(HomeView.routeName);
    } else {
      Fluttertoast.showToast(
        msg: AuthConstants.EMAIL_NOT_VERIFIED,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
  }

  void sendVerificationMail() {
    _firebaseAuthenticationService.sendVerificationMail();
  }

  Future<void> signOut() async {
    await _firebaseAuthenticationService.signOut();
  }

  void onModelDestroy() {}
}
