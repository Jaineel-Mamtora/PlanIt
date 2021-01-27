import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:PlanIt/colors.dart';
import 'package:PlanIt/constants.dart';
import 'package:PlanIt/ui/views/base_view.dart';
import 'package:PlanIt/ui/components/custom_card.dart';
import 'package:PlanIt/viewmodels/home_viewmodel.dart';
import 'package:PlanIt/ui/components/custom_table_calendar.dart';
import 'package:PlanIt/ui/components/custom_modal_bottom_sheet.dart';
import 'package:PlanIt/ui/components/custom_task_complete_container.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';

  final int taskId;
  final int dateInEpoch;

  const HomeView({
    Key key,
    this.taskId,
    this.dateInEpoch,
  }) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshIndicatorKey1 = GlobalKey<RefreshIndicatorState>();
  final _refreshIndicatorKey2 = GlobalKey<RefreshIndicatorState>();
  var _currentIndex = 0;

  DateTime selectedDate;

  Future _addPlanBottomSheet({
    BuildContext ctx,
    HomeViewModel model,
  }) async {
    var result = await showModalBottomSheet(
          context: ctx,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(30.0),
              topRight: const Radius.circular(30.0),
            ),
          ),
          builder: (_) {
            return CustomModalBottomSheet(
              date: model.getSelectedDate(),
              model: model,
              refreshKey: _currentIndex == 0
                  ? _refreshIndicatorKey1
                  : _refreshIndicatorKey2,
            );
          },
        ) ??
        false;
    if (result == true) {
      if (_currentIndex == 0) {
        await _refreshIndicatorKey1.currentState.show();
      } else {
        await _refreshIndicatorKey2.currentState.show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      onModelReady: (model) {
        model.onModelReady(
          taskId: widget.taskId,
          fromTime: widget.dateInEpoch,
        );
      },
      builder: (context, model, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              elevation: 2,
              title: Text(
                APP_NAME,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              bottom: PreferredSize(
                child: Column(
                  children: [
                    CustomTableCalendar(
                      model: model,
                      refreshKey: _currentIndex == 0
                          ? _refreshIndicatorKey1
                          : _refreshIndicatorKey2,
                    ),
                    TabBar(
                      onTap: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      tabs: [
                        Tab(
                          child: Text(
                            TaskConstants.PENDING,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            TaskConstants.COMPLETED,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                preferredSize: Size(
                  double.infinity,
                  AppBar().preferredSize.height + 70,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      DateFormat('EEE, MMM dd').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     right: 20,
                //     left: 5,
                //   ),
                //   child: SvgPicture.asset(
                //     'assets/icons/calendar.svg',
                //     width: 25,
                //   ),
                // ),
                // PopupMenuButton(
                //   child: Padding(
                //     padding: const EdgeInsets.only(right: 20),
                //     child: Icon(
                //       Icons.more_vert,
                //     ),
                //   ),
                //   onSelected: (value) async {
                //     if (value == 'Sign out') {
                //       await showDialog(
                //           context: context,
                //           builder: (context) {
                //             return AlertDialog(
                //               content: Text(
                //                 'Are you sure you want to Log Out?',
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.w300,
                //                   fontSize: 16,
                //                 ),
                //               ),
                //               actions: <Widget>[
                //                 FlatButton(
                //                   onPressed: () {
                //                     Navigator.pop(context);
                //                   },
                //                   child: Text('CANCEL'),
                //                 ),
                //                 FlatButton(
                //                   onPressed: () async {
                //                     Navigator.pop(context);
                //                     Fluttertoast.showToast(
                //                       msg: 'You have been logged out',
                //                     );
                //                     await model.logout();
                //                   },
                //                   child: Text('LOG OUT'),
                //                 ),
                //               ],
                //             );
                //           });
                //     }
                //   },
                //   itemBuilder: (context) {
                //     return <PopupMenuEntry<String>>[
                //       PopupMenuItem(
                //         value: 'Sign out',
                //         child: Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             SvgPicture.asset(
                //               'assets/icons/log_out.svg',
                //             ),
                //             SizedBox(
                //               width: 10,
                //             ),
                //             Text(
                //               'Sign out',
                //               style: Theme.of(context).textTheme.headline2,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ];
                //   },
                // ),
              ],
            ),
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            // drawer: CustomDrawer(),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                RefreshIndicator(
                  key: _refreshIndicatorKey1,
                  onRefresh: () async {
                    await model.onModelReady(
                      taskId: widget.taskId,
                      fromTime: widget.dateInEpoch,
                    );
                  },
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowGlow();
                      return false;
                    },
                    child: model.pendingTasks.isEmpty
                        ? LayoutBuilder(
                            builder: (context, constraints) => ListView(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(bottom: 60),
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/no_tasks_found.svg',
                                      width: 180,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 60,
                            ),
                            itemCount: model.pendingTasks.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  model.getSelectedDate() ==
                                          DateTime.fromMillisecondsSinceEpoch(
                                              model.pendingTasks[index].date)
                                      ? CustomCard(
                                          refreshKey: _refreshIndicatorKey1,
                                          taskEntity: model.pendingTasks[index],
                                        )
                                      : Container(),
                                  SizedBox(height: 15),
                                ],
                              );
                            },
                          ),
                  ),
                ),
                RefreshIndicator(
                  key: _refreshIndicatorKey2,
                  onRefresh: () async {
                    await model.onModelReady(
                      taskId: widget.taskId,
                      fromTime: widget.dateInEpoch,
                    );
                  },
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowGlow();
                      return false;
                    },
                    child: model.completedTasks.isEmpty
                        ? LayoutBuilder(
                            builder: (context, constraints) => ListView(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(bottom: 60),
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/no_tasks_found.svg',
                                      width: 180,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 60,
                            ),
                            itemCount: model.completedTasks.length,
                            itemBuilder: (context, index) {
                              if (model.completedTasks.isNotEmpty) {
                                return Column(
                                  children: [
                                    model.getSelectedDate() ==
                                            DateTime.fromMillisecondsSinceEpoch(
                                                model
                                                    .completedTasks[index].date)
                                        ? CustomTaskCompleteContainer(
                                            refreshKey: _refreshIndicatorKey2,
                                            id: model.completedTasks[index].id,
                                            title: model
                                                .completedTasks[index].title,
                                          )
                                        : Container(),
                                    SizedBox(height: 15),
                                  ],
                                );
                              }
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 70),
                                  child: SvgPicture.asset(
                                    'assets/icons/no_tasks_found.svg',
                                    height: 150,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: InkWell(
                onTap: () => _addPlanBottomSheet(
                  ctx: context,
                  model: model,
                ),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        TaskConstants.WHAT_DO_YOU_NEED_TO_DO,
                        style: TextStyle(
                          fontSize: 18,
                          color: GREY,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
