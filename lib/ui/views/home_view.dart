import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:PlanIt/constants.dart';
import 'package:PlanIt/ui/views/base_view.dart';
import 'package:PlanIt/ui/utils/size_config.dart';
import 'package:PlanIt/ui/components/custom_card.dart';
import 'package:PlanIt/viewmodels/home_viewmodel.dart';
import 'package:PlanIt/ui/components/custom_table_calendar.dart';
import 'package:PlanIt/ui/components/custom_modal_bottom_sheet.dart';
import 'package:PlanIt/ui/components/custom_task_complete_container.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
  CalendarController _calendarController;
  var _currentIndex = 0;

  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

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
              topLeft: Radius.circular(4.5 * SizeConfig.heightMultiplier),
              topRight: Radius.circular(4.5 * SizeConfig.heightMultiplier),
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

  Future<DateTime> showMyDatePicker({
    BuildContext ctx,
    HomeViewModel model,
  }) async {
    return showDatePicker(
      context: ctx,
      initialDate: DateTime.fromMillisecondsSinceEpoch(model.selectedDate),
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime(2050, 12, 31),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
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
              toolbarHeight: 30 * SizeConfig.heightMultiplier,
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              elevation: 2,
              title: Text(
                APP_NAME,
                style: Theme.of(context).textTheme.headline6,
              ),
              bottom: PreferredSize(
                child: Column(
                  children: [
                    CustomTableCalendar(
                      controller: _calendarController,
                      model: model,
                      refreshKey: _currentIndex == 0
                          ? _refreshIndicatorKey1
                          : _refreshIndicatorKey2,
                    ),
                    TabBar(
                      labelPadding: const EdgeInsets.all(0),
                      indicatorPadding: const EdgeInsets.all(0),
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Theme.of(context).primaryColor,
                      onTap: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      tabs: [
                        Tab(
                          child: Text(
                            TaskConstants.PENDING,
                          ),
                        ),
                        Tab(
                          child: Text(
                            TaskConstants.COMPLETED,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                preferredSize: Size(
                  double.infinity,
                  AppBar().preferredSize.height,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              actions: [
                Center(
                  child: Text(
                    DateFormat('EEE, MMM dd').format(model.getSelectedDate()),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    splashRadius: 3.57 * SizeConfig.heightMultiplier,
                    iconSize: 4.46 * SizeConfig.heightMultiplier,
                    color: Theme.of(context).primaryColorDark,
                    icon: Icon(MdiIcons.calendarMonth),
                    onPressed: () async {
                      DateTime selectedDate = await showMyDatePicker(
                        ctx: context,
                        model: model,
                      );
                      if (selectedDate != null) {
                        _calendarController.setSelectedDay(selectedDate);
                        model.setSelectedDate(selectedDate);
                        if (_currentIndex == 0) {
                          await _refreshIndicatorKey1.currentState.show();
                        } else {
                          await _refreshIndicatorKey2.currentState.show();
                        }
                      }
                    },
                  ),
                ),
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
                            padding: EdgeInsets.only(
                              top: 2.38 * SizeConfig.heightMultiplier,
                              bottom: 8.93 * SizeConfig.heightMultiplier,
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
                            padding: EdgeInsets.only(
                              top: 2.38 * SizeConfig.heightMultiplier,
                              bottom: 8.93 * SizeConfig.heightMultiplier,
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
                                    SizedBox(
                                      height:
                                          2.23 * SizeConfig.heightMultiplier,
                                    ),
                                  ],
                                );
                              }
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 10.42 * SizeConfig.heightMultiplier,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/no_tasks_found.svg',
                                    height: 22.32 * SizeConfig.heightMultiplier,
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
              padding: EdgeInsets.symmetric(
                horizontal: 3 * SizeConfig.heightMultiplier,
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
                    height: 6.7 * SizeConfig.heightMultiplier,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(
                        0.74 * SizeConfig.heightMultiplier,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 1.49 * SizeConfig.heightMultiplier,
                      ),
                      child: Text(
                        TaskConstants.WHAT_DO_YOU_NEED_TO_DO,
                        style: Theme.of(context).textTheme.bodyText1,
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
