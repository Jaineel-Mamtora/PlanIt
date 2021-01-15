import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:PlanIt/colors.dart';
import 'package:PlanIt/locator.dart';
import 'package:PlanIt/services/firebase_authentication_service.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final Size deviceSize = mediaQuery.size;
    final user = Provider.of<User>(context);
    return Container(
      width: deviceSize.width * 0.85,
      child: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 120,
                    color: LIGHT_BLUE,
                    child: ListTile(
                      leading: SvgPicture.asset(
                        'assets/icons/logo.svg',
                        height: 50,
                        width: 100,
                      ),
                      title: Text(
                        'PlanIt',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: user != null
                          ? Text(
                              "${user.email}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              FlatButton.icon(
                onPressed: () async {
                  _firebaseAuthenticationService.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  'SIGN OUT',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
