import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:PlanIt/colors.dart';
import 'package:PlanIt/locator.dart';
import 'package:PlanIt/constants.dart';
import 'package:PlanIt/ui/router.dart';
import 'package:PlanIt/ui/views/startup_view.dart';
import 'package:PlanIt/services/navigation_service.dart';
import 'package:PlanIt/managers/notification_handler.dart';

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
  _notificationHandler
      .setOnNotificationReceive(_notificationHandler.onNotificationReceive);
  runApp(
    MyPlanItApp(),
  );
}

class MyPlanItApp extends StatelessWidget {
  final _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
        child: MaterialApp(
          title: APP_NAME,
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigationService.navigatorKey,
          onGenerateRoute: CustomRouter.generateRoute,
          theme: ThemeData(
            textTheme: TextTheme(
              caption: TextStyle(
                fontSize: 24,
                color: Color(0xFF072F5F),
              ),
              headline1: TextStyle(
                fontSize: 18,
                color: Color(0xFF072F5F),
              ),
              headline2: TextStyle(
                fontSize: 14,
                color: Color(0xFF222222),
              ),
              subtitle1: TextStyle(
                fontSize: 12,
                color: Color(0xFF6C8389),
              ),
              subtitle2: TextStyle(
                fontSize: 12,
                color: Color(0xFFC2CFE1),
              ),
              headline3: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0080FF),
              ),
              headline4: TextStyle(
                fontSize: 16,
                color: Color(0xFF072F5F),
              ),
              headline5: TextStyle(
                fontSize: 14,
                color: Color(0xFF6A707E),
              ),
              headline6: TextStyle(
                fontSize: 10,
                color: Color(0xFF072F5F),
              ),
            ),
            primarySwatch: generateMaterialColor(Color(0xFF0080FF)),
            fontFamily: FONT_NAME,
            scaffoldBackgroundColor: Colors.white,
            cursorColor: Color(0xFF072F5F),
            highlightColor: Color(0xFFC2CFE1),
            accentColor: Color(0xFFE69518),
            unselectedWidgetColor: Color(0xFFC4C4C4),
            focusColor: Color(0xFF072F5F),
            indicatorColor: Color(0xFF90A0B8),
            primaryColorDark: Color(0xFF072F5F),
            toggleableActiveColor: Color(0xFF90A0B8),
          ),
          home: StartUpView(),
        ),
      ),
    );
  }
}
