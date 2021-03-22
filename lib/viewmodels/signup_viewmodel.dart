import 'package:plan_it/locator.dart';
import 'package:plan_it/constants.dart';
import 'package:plan_it/enums/viewstate.dart';
import 'package:plan_it/ui/views/home_view.dart';
import 'package:plan_it/viewmodels/base_viewmodel.dart';
import 'package:plan_it/ui/views/verification_view.dart';
import 'package:plan_it/services/navigation_service.dart';
import 'package:plan_it/services/firebase_authentication_service.dart';

class SignUpViewModel extends BaseViewModel {
  final _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();

  Future<void> onModelReady() async {}

  Future signUpWithEmail({
    String email,
    String password,
    String confirmPassword,
    Function switchLoading,
  }) async {
    setState(ViewState.Busy);
    dynamic result = await _firebaseAuthenticationService.signUpWithEmail(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    if (result == AuthConstants.NOT_VERIFIED) {
      _navigationService.pushReplacementNamed(VerificationView.routeName);
      setState(ViewState.Error);
    } else if (result == true) {
      _navigationService.pushReplacementNamed(HomeView.routeName);
      setState(ViewState.Idle);
    }
  }

  void onModelDestroy() {}
}
