import 'package:PlanIt/ui/views/home_view.dart';
import 'package:PlanIt/ui/views/login_view.dart';
import 'package:PlanIt/ui/views/signup_view.dart';
import 'package:PlanIt/ui/views/verification_view.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginView.routeName:
        return MaterialPageRoute(builder: (_) => LoginView());
      case SignUpView.routeName:
        return MaterialPageRoute(builder: (_) => SignUpView());
      case HomeView.routeName:
        var _args = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => HomeView(
            taskId: _args,
          ),
        );
      case VerificationView.routeName:
        return MaterialPageRoute(builder: (_) => VerificationView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
