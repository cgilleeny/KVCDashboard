import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_check_kidz_dashboard/cubit/dashboard_users_cubit.dart';
import 'package:go_check_kidz_dashboard/widgets/dashboard_user_permission_view.dart';
import 'package:go_check_kidz_dashboard/widgets/error_banner.dart';
import '../data/model/dashboard_user.dart';

class UpdateDashboardUser extends StatelessWidget {
  final DashboardUser dashboardUser;
  final void Function(DashboardUser dashboardUser) onUpdateValue;

  const UpdateDashboardUser(this.dashboardUser, this.onUpdateValue, {Key? key})
      : super(key: key);

  void _onChange(newRead, newWrite, newAdmin) {
    onUpdateValue(DashboardUser(
        email: dashboardUser.email,
        read: newRead,
        write: newWrite,
        admin: newAdmin));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardUsersCubit, DashboardUsersState>(
      listener: (context, state) {
        if (state is DashboardUserUpdated) {
          BlocProvider.of<DashboardUsersCubit>(context).fetchDashboardUsers();
        } else if (state is DashboardUsersLoaded) {
          Navigator.of(context).pop(true);
        }
      },
      child: BlocBuilder<DashboardUsersCubit, DashboardUsersState>(
        builder: (context, state) {
          final emailWithLineBreak = dashboardUser.email.length > 25
              ? dashboardUser.email.split('@').join('\n@')
              : dashboardUser.email;

          return Column(
              children: [
            state is DashboardUserUpdateError
                ? ErrorBanner(state.errorDescription)
                : null,
            Stack(
              alignment: Alignment.center,
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
                          onChange: _onChange,
                          read: dashboardUser.read,
                          write: dashboardUser.write,
                          admin: dashboardUser.admin,
                        ),
                      ),
                    ],
                  ),
                ),
                state is DashboardUserUpdating
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : null,
                state is DashboardUsersLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : null,
              ].whereType<Widget>().toList(),
            ),
          ].whereType<Widget>().toList());
        },
      ),
    );
  }
}
