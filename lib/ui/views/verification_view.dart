import 'package:flutter/material.dart';

import 'package:PlanIt/constants.dart';
import 'package:PlanIt/ui/views/base_view.dart';
import 'package:PlanIt/ui/utils/background_clipper.dart';
import 'package:PlanIt/viewmodels/verification_viewmodel.dart';

class VerificationView extends StatelessWidget {
  static const routeName = '/verification';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    return BaseView<VerificationViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: BackgroundClipper(),
                      child: Container(
                        height: deviceSize.height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(16, 156, 242, 1),
                              Color.fromRGBO(40, 84, 112, 1),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      left: 20,
                      right: 20,
                      child: Align(
                        alignment: Alignment.center,
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 8),
                                  Text(
                                    AuthConstants.VERIFICATION_PENDING,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    AuthConstants
                                        .PLEASE_CLICK_THE_LINK_IN_THE_VERIFICATION_EMAIL_SENT_TO_YOU,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 8,
                                    ),
                                    child: RaisedButton(
                                      color: Colors.white,
                                      elevation: 2,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 5,
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 3,
                                        ),
                                      ),
                                      onPressed: () => model.refresh(context),
                                      child: Text(
                                        AuthConstants.REFRESH,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: RaisedButton(
                                      color: Colors.white,
                                      elevation: 2,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 5,
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 3,
                                        ),
                                      ),
                                      onPressed: () =>
                                          model.sendVerificationMail(),
                                      child: Text(
                                        AuthConstants.SEND_MAIL_AGAIN,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 8,
                                    ),
                                    child: RaisedButton(
                                      color: Colors.white,
                                      elevation: 2,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 5,
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 3,
                                        ),
                                      ),
                                      onPressed: () => model.signOut(),
                                      child: Text(
                                        AuthConstants.SIGN_OUT,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
