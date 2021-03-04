import 'package:flutter/material.dart';

import 'package:plan_it/locator.dart';
import 'package:plan_it/enums/viewstate.dart';
import 'package:plan_it/enums/connectivity_status.dart';
import 'package:plan_it/services/connectivity_service.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  final _connectivityService = locator<ConnectivityService>();

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  void setupConnectivity() {
    _connectivityService.connectionStatusController.stream.listen((event) {
      if (event == ConnectivityStatus.Offline) {
        setState(ViewState.NoConnection);
      } else {
        setState(ViewState.Idle);
      }
    });
  }
}
