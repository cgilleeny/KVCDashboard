import 'package:flutter/material.dart';
import 'package:go_check_kidz_dashboard/widgets/dashboard_user_permission_view.dart';
import '../data/model/dashboard_user.dart';

class UserProfile extends StatelessWidget {
  final DashboardUser dashboardUser;

  const UserProfile(this.dashboardUser, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
          final emailWithLineBreak = dashboardUser.email.length > 25
              ? dashboardUser.email.split('@').join('\n@')
              : dashboardUser.email;

          return Column(
              children: [
                Card(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          emailWithLineBreak,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DashboardUserPermissionView(
                          read: dashboardUser.read,
                          write: dashboardUser.write,
                          admin: dashboardUser.admin,
                          isEdit: false,
                        ),
                      ),
                    ],
                  ),
                ),
          ]);
  }
}
