import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T> pushNamed<T extends Object>(
    String routeName, {
    Object arguments,
  }) {
    return navigatorKey.currentState.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<T> pushReplacementNamed<T extends Object>(String routeName,
      {Object arguments}) {
    return navigatorKey.currentState.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<T> pushNamedAndRemoveUntil<T extends Object>(String routeName,
      {Object arguments}) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  void pop<T extends Object>([T result]) {
    return navigatorKey.currentState.pop(
      result,
    );
  }
}
