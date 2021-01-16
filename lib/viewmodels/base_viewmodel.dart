import 'package:flutter/material.dart';

import 'package:PlanIt/locator.dart';
import 'package:PlanIt/enums/viewstate.dart';
import 'package:PlanIt/enums/connectivity_status.dart';
import 'package:PlanIt/services/connectivity_service.dart';

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
