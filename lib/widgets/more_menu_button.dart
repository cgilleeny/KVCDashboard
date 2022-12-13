import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_check_kidz_dashboard/UI/shared/basic_dialog.dart';
import 'package:go_check_kidz_dashboard/cubit/eyepair_cubit.dart';
import 'package:go_check_kidz_dashboard/screens/signin_page.dart';
import 'package:go_check_kidz_dashboard/widgets/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../cubit/authorization_cubit.dart';
import '../cubit/dashboard_users_cubit.dart';
import '../data/model/dashboard_user.dart';
import '../enums/dialog_type.dart';
import '../screens/admin_page.dart';
import '../utils/custom_page_route.dart';

class MoreMenuButton extends StatefulWidget {

  const MoreMenuButton({Key? key}) : super(key: key);

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
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardUsersCubit, DashboardUsersState>(
        builder: ((context, state) {
      if (state is DashboardUserFound) {
        authenticatedUser = state.dashboardUser;
      }
      return PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            // onTap: () {},
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
            enabled: authenticatedUser == null ? false : true,
            child: Row(
              children: const [
                Icon(Icons.portrait),
                SizedBox(
                  width: 10,
                ),
                Text("Profile")
              ],
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Row(
              children: const [
                Icon(Icons.logout),
                SizedBox(
                  width: 10,
                ),
                Text("Sign Out")
              ],
            ),
          ),
        ].toList(),
        offset: const Offset(0, 100),
        color: Colors.grey,
        elevation: 2,
        onSelected: (value) async {
          if (value == 1) {
            Navigator.of(context).push(
              CustomPageRoute(child: const AdminPage()),
            );
          } else if (value == 2) {
            await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return BasicDialog(
                      BasicDialogType.portrait,
                      UserProfile(authenticatedUser!),
                      buttonsDef: [DialogButton('OK', true)]);
                });
          } else if (value == 3) {
            bool continueLogout = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return BasicDialog(
                      BasicDialogType.warning,
                      const Text(
                        'Are you sure about signing out?',
                      ),
                      buttonsDef: [
                        DialogButton('Cancel', false),
                        DialogButton('Continue', true),
                      ]);
                }) as bool;
            final appleSignInAvailable = await TheAppleSignIn.isAvailable();
            if (!continueLogout || !mounted) {
              return;
            }

            BlocProvider.of<DashboardUsersCubit>(context).fetchDashboardUsers();
            BlocProvider.of<AuthorizationCubit>(context).signOut();
            SharedPreferences.getInstance()
                .then((sharedPreferences) => sharedPreferences.setString(
                      'socialPlatform',
                      'none',
                    ));

            Navigator.of(context).pushReplacement(
              CustomPageRoute(
                child: SignInPage(appleSignInAvailable),
              ),
            );
            // BlocProvider.of<EyepairCubit>(context).fetchFirstPage();
          }
        }, // onSelected
      );
    }));
  }
}

class ConfirmLogout extends StatelessWidget {
  const ConfirmLogout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Warning!"),
      content: const Text("Do you really want to logout?"),
      actions: [
        MaterialButton(
          child: const Text("Cancel"),
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

// void _showDialog(BuildContext context) async {
//   return await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("Warning!"),
//         content: Text("Do you really want to logout?"),
//         actions: [
//           MaterialButton(
//             child: Text("Cancel"),
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             },
//           ),
//           MaterialButton(
//             child: Text("Yes"),
//             onPressed: () {
//               GoogleSignIn().disconnect();
//               Navigator.of(context).pop(true);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
