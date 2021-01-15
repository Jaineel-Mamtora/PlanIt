import 'package:get_it/get_it.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

import 'package:PlanIt/services/database_service.dart';
import 'package:PlanIt/services/navigation_service.dart';
import 'package:PlanIt/managers/notification_handler.dart';
import 'package:PlanIt/services/connectivity_service.dart';
import 'package:PlanIt/services/local_storage_service.dart';
import 'package:PlanIt/services/firebase_authentication_service.dart';

import 'package:PlanIt/viewmodels/home_viewmodel.dart';
import 'package:PlanIt/viewmodels/login_viewmodel.dart';
import 'package:PlanIt/viewmodels/signup_viewmodel.dart';
import 'package:PlanIt/viewmodels/startup_viewmodel.dart';
import 'package:PlanIt/viewmodels/verification_viewmodel.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // services or handlers
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DatabaseService());
  locator.registerLazySingleton(() => DatabaseMigrationService());
  var localStorageService = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(localStorageService);
  locator.registerLazySingleton(() => NotificationHandler());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => FirebaseAuthenticationService());

  // viewmodels
  locator.registerFactory(() => StartUpViewModel());
  locator.registerFactory(() => LoginViewModel());
  locator.registerFactory(() => SignUpViewModel());
  locator.registerFactory(() => HomeViewModel());
  locator.registerFactory(() => VerificationViewModel());
}
