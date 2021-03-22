import 'package:get_it/get_it.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

import 'package:plan_it/services/database_service.dart';
import 'package:plan_it/services/navigation_service.dart';
import 'package:plan_it/managers/notification_handler.dart';
import 'package:plan_it/services/connectivity_service.dart';
import 'package:plan_it/services/local_storage_service.dart';
import 'package:plan_it/services/firebase_authentication_service.dart';

import 'package:plan_it/viewmodels/home_viewmodel.dart';
import 'package:plan_it/viewmodels/task_viewmodel.dart';
import 'package:plan_it/viewmodels/login_viewmodel.dart';
import 'package:plan_it/viewmodels/signup_viewmodel.dart';
import 'package:plan_it/viewmodels/startup_viewmodel.dart';
import 'package:plan_it/viewmodels/verification_viewmodel.dart';

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
  locator.registerFactory(() => TaskViewModel());
  locator.registerFactory(() => VerificationViewModel());
}
