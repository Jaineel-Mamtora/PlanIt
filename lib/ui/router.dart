import 'package:sprintf/sprintf.dart';
import 'package:flutter/material.dart';

import 'package:plan_it/constants.dart';
import 'package:plan_it/ui/views/task_view.dart';
import 'package:plan_it/ui/views/home_view.dart';
import 'package:plan_it/ui/views/login_view.dart';
import 'package:plan_it/ui/views/signup_view.dart';
import 'package:plan_it/ui/views/verification_view.dart';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginView.routeName:
        return MaterialPageRoute(builder: (_) => LoginView());
      case SignUpView.routeName:
        return MaterialPageRoute(builder: (_) => SignUpView());
      case HomeView.routeName:
        var _args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => HomeView(
            taskId: _args['taskId'],
            dateInEpoch: _args['fromTime'],
          ),
        );
      case VerificationView.routeName:
        return MaterialPageRoute(builder: (_) => VerificationView());
      case TaskView.routeName:
        var _args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TaskView(
            refreshIndicatorKey: _args['refreshKey'],
            isEditing: _args['isEditing'],
            task: _args['task'],
            dateSelected: _args['dateSelected'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                sprintf(
                  GeneralConstants.NO_ROUTES_DEFINED,
                  [settings.name],
                ),
              ),
            ),
          ),
        );
    }
  }
}
