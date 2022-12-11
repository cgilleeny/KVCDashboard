import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_check_kidz_dashboard/cubit/dashboard_users_cubit.dart';
import 'package:go_check_kidz_dashboard/widgets/error_banner.dart';

import '../data/model/dashboard_user.dart';
import 'azure_user_permissions_view.dart';

class InsertDashboardUser extends StatefulWidget {
  final void Function(DashboardUser dashboardUser) onInsertValue;
  const InsertDashboardUser(this.onInsertValue, {Key? key}) : super(key: key);

  @override
  State<InsertDashboardUser> createState() => _InsertDashboardUserState();
}

class _InsertDashboardUserState extends State<InsertDashboardUser> {
  final controller = TextEditingController();
  bool read = true;
  bool write = false;
  bool admin = false;

  void _onChange(newRead, newWrite, newAdmin) {
    setState(() {
      read = newRead;
      write = newWrite;
      admin = newAdmin;
    });
    widget.onInsertValue(
      DashboardUser(
        email: controller.text,
        read: read,
        write: write,
        admin: admin,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardUsersCubit, DashboardUsersState>(
      listener: (context, state) {
        if (state is DashboardUserInserted) {
          BlocProvider.of<DashboardUsersCubit>(context).fetchDashboardUsers();
        } else if (state is DashboardUsersLoaded) {
          Navigator.of(context).pop(true);
        }
      },
      child: BlocBuilder<DashboardUsersCubit, DashboardUsersState>(
        builder: (context, state) {
          return Column(
              children: [
            state is DashboardUserInsertError
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
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
                          showCursor: true,
                          cursorColor: Colors.black,
                          textAlign: TextAlign.start,
                          onSubmitted: (value) {
                            widget.onInsertValue(
                              DashboardUser(
                                email: value,
                                read: read,
                                write: write,
                                admin: admin,
                              ),
                            );
                          },
                          controller: controller,
                          style: const TextStyle(height: 1.0, fontSize: 13.0),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(6, 15, 6, 9),
                            hintText: 'Gmail address or Apple ID',
                            hintStyle: TextStyle(
                                color: Theme.of(context).primaryColor),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AzureUserPermissionsView(
                          onChange: _onChange,
                          read: true,
                          write: false,
                          admin: false,
                        ),
                      ),
                    ],
                  ),
                ),
                state is DashboardUserInserting
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
