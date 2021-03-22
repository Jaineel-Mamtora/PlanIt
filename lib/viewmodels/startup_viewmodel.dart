import 'package:plan_it/locator.dart';
import 'package:plan_it/ui/views/home_view.dart';
// import 'package:plan_it/ui/views/signup_view.dart';
import 'package:plan_it/services/database_service.dart';
import 'package:plan_it/viewmodels/base_viewmodel.dart';
import 'package:plan_it/services/navigation_service.dart';
// import 'package:plan_it/services/local_storage_service.dart';

class StartUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  // final _localStorageService = locator<LocalStorageService>();
  final _databaseService = locator<DatabaseService>();

  Future<void> onModelReady() async {
    // important line!!
    await Future.delayed(Duration(milliseconds: 500));
    await _databaseService.initialize();
    // if (_localStorageService.isLoggedIn == false) {
    //   _navigationService.pushNamedAndRemoveUntil(SignUpView.routeName);
    // } else if (_localStorageService.isLoggedIn == true) {
    //   _navigationService.pushNamedAndRemoveUntil(HomeView.routeName);
    // } else {
    //   await _navigationService.pushNamedAndRemoveUntil(SignUpView.routeName);
    // }
    _navigationService.pushNamedAndRemoveUntil(
      HomeView.routeName,
      arguments: {
        'taskId': 0,
        'fromTime': 0,
      },
    );
  }

  void onModelDestroy() {}
}
