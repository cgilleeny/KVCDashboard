import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_check_kidz_dashboard/UI/shared/basic_dialog.dart';
import 'package:go_check_kidz_dashboard/screens/signin_page.dart';
import 'package:go_check_kidz_dashboard/widgets/update_dashboard_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../cubit/authorization_cubit.dart';
import '../cubit/dashboard_users_cubit.dart';
import '../data/model/dashboard_user.dart';
import '../enums/dialog_type.dart';
import '../screens/admin_page.dart';
import '../utils/custom_page_route.dart';

class MoreMenuButton extends StatefulWidget {
  // GoogleSignInAccount user;
  // List<AzureUser> azureUsers;
  MoreMenuButton({Key? key}) : super(key: key);

  @override
  State<MoreMenuButton> createState() => _MoreMenuButtonState();
}

class _MoreMenuButtonState extends State<MoreMenuButton> {
  // late List<AzureUser> azureUsers;
  late bool hasAdminPermissions;
  DashboardUser? authenticatedUser;
  String? socialEmail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      socialEmail =
          BlocProvider.of<AuthorizationCubit>(context).repository.socialEmail;
      if (socialEmail != null) {
        BlocProvider.of<DashboardUsersCubit>(context)
            .fetchDashboardUser(socialEmail!);
      }
    });
  }

  final verbal =
      'Hello this fine morning.  I hope all is well with ya today.  Im trying to really use up some space here';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<DashboardUsersCubit, DashboardUsersState>(
      builder: ((context, state) {
              if (state is DashboardUserFound) {
              authenticatedUser = state.dashboardUser;  
      }
        return PopupMenuButton<int>(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              onTap: () {},
              enabled: authenticatedUser?.admin ?? false,
              child: Row(
                children: const [
                  Icon(Icons.admin_panel_settings),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Admin Page")
                ],
              ),
            ),
            PopupMenuItem(
              value: 2,
              // row with two children
              child: Row(
                children: const [
                  Icon(Icons.info),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Info Dialog")
                ],
              ),
            ),
            PopupMenuItem(
              value: 3,
              // row with two children
              child: Row(
                children: const [
                  Icon(Icons.check),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Success Dialog")
                ],
              ),
            ),
            PopupMenuItem(
              value: 4,
              // row with two children
              child: Row(
                children: const [
                  Icon(Icons.warning),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Warning Dialog")
                ],
              ),
            ),
            PopupMenuItem(
              value: 5,
              // row with two children
              child: Row(
                children: const [
                  Icon(Icons.error),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Error Dialog")
                ],
              ),
            ),
          ].toList(),
          offset: Offset(0, 100),
          color: Colors.grey,
          elevation: 2,
          // on selected we show the dialog box
          onSelected: (value) async {
            // if value 1 show dialog
            if (value == 1) {
              Navigator.of(context).push(CustomPageRoute(child:  AdminPage()),
              );
            } else if (value == 2) {
              bool continueLogout = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return BasicDialog(
                        BasicDialogType.info,
                        Text(
                          verbal,
                        ),
                        buttonsDef: [DialogButton('Continue', true)]);
                  }) as bool;
            } else if (value == 3) {
              bool continueLogout = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return BasicDialog(
                        BasicDialogType.success,
                        Text(
                          verbal,
                        ),
                        buttonsDef: [DialogButton('Continue', true)]);
                  }) as bool;
            } else if (value == 4) {
              bool continueLogout = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return BasicDialog(
                        BasicDialogType.warning,
                        Text(
                          verbal,
                        ),
                        buttonsDef: [
                          DialogButton('Cancel', false),
                          DialogButton('OK', true)
                        ]);
                  }) as bool;
            } else if (value == 5) {
              bool continueLogout = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return BasicDialog(
                        BasicDialogType.error,
                        Text(
                          verbal,
                        ),
                        buttonsDef: [
                          DialogButton('Cancel', false),
                          DialogButton('Continue', true)
                        ]);
                  }) as bool;
            }
          }, // onSelected
        );
      }
  ));
  }
}

class ConfirmLogout extends StatelessWidget {
  const ConfirmLogout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Warning!"),
      content: Text("Do you really want to logout?"),
      actions: [
        MaterialButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        MaterialButton(
          child: const Text("Yes"),
          onPressed: () {
            // GoogleSignIn().disconnect();
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}

void _showDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Warning!"),
        content: Text("Do you really want to logout?"),
        actions: [
          MaterialButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          MaterialButton(
            child: Text("Yes"),
            onPressed: () {
              GoogleSignIn().disconnect();
              Navigator.of(context).pop(true);
// Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => SignInPage(azureUsers: widget.azureUsers),
//       ),
//     );
            },
          ),
        ],
      );
    },
  );
}
