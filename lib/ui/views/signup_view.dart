import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:plan_it/locator.dart';
import 'package:plan_it/constants.dart';
import 'package:plan_it/ui/views/base_view.dart';
import 'package:plan_it/ui/views/login_view.dart';
import 'package:plan_it/viewmodels/signup_viewmodel.dart';
import 'package:plan_it/services/navigation_service.dart';
import 'package:plan_it/ui/components/custom_text_field.dart';

class SignUpView extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _navigationService = locator<NavigationService>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    return BaseView<SignUpViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: deviceSize.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF80C0FF),
                            Color(0xFF0080FF),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      left: 20,
                      right: 20,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SvgPicture.asset(
                                'assets/icons/logo_black.svg',
                                width: 60,
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.all(0),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                height: 420,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 20,
                                        bottom: 20,
                                      ),
                                      child: Text(
                                        AuthConstants.SIGN_UP,
                                        style: TextStyle(
                                          fontSize: 30,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom: 15,
                                      ),
                                      child: CustomTextField(
                                        controller: _emailController,
                                        labelText: AuthConstants.EMAIL,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom: 15,
                                      ),
                                      child: CustomTextField(
                                        controller: _passwordController,
                                        labelText: AuthConstants.PASSWORD,
                                        obscureText: true,
                                        customMaxLines: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom: 15,
                                      ),
                                      child: CustomTextField(
                                        controller: _confirmPasswordController,
                                        labelText:
                                            AuthConstants.CONFIRM_PASSWORD,
                                        obscureText: true,
                                        customMaxLines: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ElevatedButton(
                                            // color: Colors.white,
                                            // elevation: 3,
                                            // padding: EdgeInsets.symmetric(
                                            //   horizontal: 40,
                                            //   vertical: 5,
                                            // ),
                                            // materialTapTargetSize:
                                            //     MaterialTapTargetSize
                                            //         .shrinkWrap,
                                            // shape: RoundedRectangleBorder(
                                            //   borderRadius:
                                            //       BorderRadius.circular(4),
                                            //   side: BorderSide(
                                            //     color: Theme.of(context)
                                            //         .primaryColor,
                                            //     width: 2,
                                            //   ),
                                            // ),
                                            onPressed: () {
                                              model.signUpWithEmail(
                                                email: _emailController.text,
                                                password: _passwordController
                                                    .text
                                                    .trim(),
                                                confirmPassword:
                                                    _confirmPasswordController
                                                        .text
                                                        .trim(),
                                              );
                                              FocusScope.of(context).unfocus();
                                            },
                                            child: Text(
                                              AuthConstants.SIGN_UP,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 2.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        top: 15,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                left: 25,
                                                right: 15,
                                              ),
                                              child: Divider(
                                                color: Colors.black,
                                                height: 1,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            AuthConstants.OR,
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                left: 15,
                                                right: 25,
                                              ),
                                              child: Divider(
                                                color: Colors.black,
                                                height: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ElevatedButton.icon(
                                            // padding: const EdgeInsets.symmetric(
                                            //   horizontal: 20,
                                            //   vertical: 5,
                                            // ),
                                            // highlightColor: Color(0xFF0066CC),
                                            // elevation: 3,
                                            // materialTapTargetSize:
                                            //     MaterialTapTargetSize
                                            //         .shrinkWrap,
                                            // shape: RoundedRectangleBorder(
                                            //   borderRadius:
                                            //       BorderRadius.circular(4),
                                            // ),
                                            // color:
                                            //     Color.fromRGBO(76, 139, 245, 1),
                                            icon: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 13,
                                              child: SvgPicture.asset(
                                                'assets/icons/google.svg',
                                              ),
                                            ),
                                            label: Text(
                                              AuthConstants.SIGN_IN_WITH_GOOGLE,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    AuthConstants.ALREADY_HAVE_AN_ACCOUNT,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () {
                                      _navigationService.pushReplacementNamed(
                                        LoginView.routeName,
                                      );
                                    },
                                    child: Text(
                                      AuthConstants.LOG_IN,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
