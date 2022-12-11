import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:go_check_kidz_dashboard/cubit/dashboard_users_cubit.dart';
import 'package:go_check_kidz_dashboard/widgets/error_banner.dart';
import '../UI/shared/basic_dialog.dart';
import '../data/model/dashboard_user.dart';
import '../enums/dialog_type.dart';
import '../widgets/insert_dashboard_user.dart';
import '../widgets/update_dashboard_user.dart';

enum AdminAction {
  edit,
  delete,
}

class AdminPage extends StatefulWidget {
  // GoogleSignInAccount user;
  // List<AzureUser> azureUsers;

  AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _controller = ScrollController();
  List<DashboardUser> dashboardUsers = [];
  // List<AzureUser> azureUsers = [];
  DashboardUser? userToUpdate;
  DashboardUser? userToInsert;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        dashboardUsers = BlocProvider.of<DashboardUsersCubit>(context)
            .repository
            .dashboardUsers;
      });
    });
    // azureUsers = widget.azureUsers;
  }

  void onUpdateValue(DashboardUser userToUpdate) {
    this.userToUpdate = userToUpdate;
  }

  void onInsertValue(DashboardUser userToInsert) {
    this.userToInsert = userToInsert;
  }

  void _insertDashboardUser() {
    showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return BasicDialog(
          BasicDialogType.add,
          InsertDashboardUser(onInsertValue),
          buttonsDef: [
            DialogButton(
              'Cancel',
              true,
              onPressed: () {
                BlocProvider.of<DashboardUsersCubit>(context).reset();
                Navigator.of(context).pop(false);
              },
            ),
            DialogButton(
              'Add',
              true,
              onPressed: () {
                BlocProvider.of<DashboardUsersCubit>(context)
                    .insertDashboardUser(userToInsert!);
              },
            ),
          ],
        );
      },
      animationType: DialogTransitionType.fade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }

  void _updateDashboardUser(DashboardUser dashboardUser) {
    showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return BasicDialog(
          BasicDialogType.edit,
          UpdateDashboardUser(dashboardUser, onUpdateValue),
          buttonsDef: [
            DialogButton(
              'Cancel',
              true,
              onPressed: () {
                BlocProvider.of<DashboardUsersCubit>(context).reset();
                Navigator.of(context).pop(false);
              },
            ),
            DialogButton(
              'Update',
              true,
              onPressed: () {
                BlocProvider.of<DashboardUsersCubit>(context)
                    .updateDashboardUser(
                  userToUpdate,
                );
              },
            ),
          ],
        );
      },
      animationType: DialogTransitionType.fade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Manage Dashboard Users'),
      ),
      body: BlocListener<DashboardUsersCubit, DashboardUsersState>(
        listener: (listenerContext, state) {
          if (state is DashboardUsersLoaded) {
            setState(() {
              dashboardUsers = state.dashboardUsers;
            });
          }
        },
        child: BlocBuilder<DashboardUsersCubit, DashboardUsersState>(
          builder: (blocContext, state) {
            return SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      if (state is DashboardUsersLoadError)
                          ErrorBanner(state.errorDescription),
                      NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (kDebugMode) {
                            print('_controller.offset: ${_controller.offset}');
                          }
                          if (_controller.offset <= -160.0 &&
                              state is! DashboardUsersLoading) {
                            BlocProvider.of<DashboardUsersCubit>(context)
                                .fetchDashboardUsers();
                          }
                          return false;
                        },
                        child: Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(bottom: 56),
                            itemCount: dashboardUsers.length,
                            itemBuilder: (_, i) {
                              final emailWithLineBreak =
                                  dashboardUsers[i].email.length > 25
                                      ? dashboardUsers[i]
                                          .email
                                          .split('@')
                                          .join('\n@')
                                      : dashboardUsers[i].email;
                              return ListTile(
                                title: Text(emailWithLineBreak,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                subtitle: PermissionsSubtitleWidget(
                                    dashboardUsers[i]),
                                trailing: IconButton(
                                  onPressed: () =>
                                      _updateDashboardUser(dashboardUsers[i]),
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            scrollDirection: Axis.vertical,
                            controller: _controller,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (state is DashboardUsersLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _insertDashboardUser(),
        tooltip: 'Add a gmail address for a new dashboard user.',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PermissionsSubtitleWidget extends StatelessWidget {
  // final AzureUser azureUser;
  final DashboardUser dashboardUser;
  const PermissionsSubtitleWidget(
    this.dashboardUser, {
    Key? key,
  }) : super(key: key);

  String _permissionChar(bool permission) {
    return permission ? '\u2714' : '\u274c';
  }

  @override
  Widget build(BuildContext context) {
    // String readPermission = azureUser.read ? '\u2705' : '\u274c';

    return Text(
        'read: ${_permissionChar(dashboardUser.read)}, write: ${_permissionChar(dashboardUser.write)}, admin: ${_permissionChar(dashboardUser.admin)}');
  }
}
