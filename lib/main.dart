import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:plan_it/locator.dart';
import 'package:plan_it/styling.dart';
import 'package:plan_it/constants.dart';
import 'package:plan_it/ui/router.dart';
import 'package:plan_it/ui/utils/size_config.dart';
import 'package:plan_it/ui/views/startup_view.dart';
import 'package:plan_it/services/navigation_service.dart';
import 'package:plan_it/managers/notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  final _notificationHandler = locator<NotificationHandler>();
  _notificationHandler.initLocalNotification();
  _notificationHandler.setOnNotificationReceive(
    _notificationHandler.onNotificationReceive,
  );
  runApp(
    MyPlanItApp(),
  );
}

class MyPlanItApp extends StatelessWidget {
  final _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: MultiProvider(
        providers: [
          StreamProvider<User>.value(
            value: FirebaseAuth.instance.userChanges(),
          ),
        ],
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus.unfocus();
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return OrientationBuilder(
                builder: (context, orientation) {
                  SizeConfig().init(constraints, orientation);
                  return MaterialApp(
                    title: APP_NAME,
                    debugShowCheckedModeBanner: false,
                    navigatorKey: _navigationService.navigatorKey,
                    onGenerateRoute: CustomRouter.generateRoute,
                    theme: AppTheme.lightTheme,
                    home: StartUpView(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
