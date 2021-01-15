import 'package:PlanIt/locator.dart';
import 'package:PlanIt/enums/viewstate.dart';
import 'package:PlanIt/services/firebase_authentication_service.dart';
import 'package:PlanIt/services/navigation_service.dart';
import 'package:PlanIt/ui/views/home_view.dart';
import 'package:PlanIt/ui/views/verification_view.dart';
import 'package:PlanIt/viewmodels/base_viewmodel.dart';

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
    if (result == 'Not Verified') {
      _navigationService.pushReplacementNamed(VerificationView.routeName);
      setState(ViewState.Error);
    } else if (result == true) {
      _navigationService.pushReplacementNamed(HomeView.routeName);
      setState(ViewState.Idle);
    }
  }

  void onModelDestroy() {}
}
