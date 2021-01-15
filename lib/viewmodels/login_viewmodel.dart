import 'package:PlanIt/enums/viewstate.dart';
import 'package:PlanIt/locator.dart';
import 'package:PlanIt/ui/views/home_view.dart';
import 'package:PlanIt/viewmodels/base_viewmodel.dart';
import 'package:PlanIt/services/navigation_service.dart';
import 'package:PlanIt/services/firebase_authentication_service.dart';

class LoginViewModel extends BaseViewModel {
  final _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();

  Future<void> onModelReady() async {}

  Future signInWithEmail({
    String email,
    String password,
  }) async {
    setState(ViewState.Busy);
    bool result = await _firebaseAuthenticationService.signInWithEmail(
      email: email,
      password: password,
    );
    if (result == true) {
      _navigationService.pushReplacementNamed(HomeView.routeName);
      setState(ViewState.Idle);
    } else {
      setState(ViewState.Error);
    }
  }

  void sendPasswordResetEmail(String email) {
    _firebaseAuthenticationService.sendPasswordResetEmail(email);
  }

  void onModelDestroy() {}
}
