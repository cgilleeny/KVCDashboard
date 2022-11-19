import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../cubit/authorization_cubit.dart';
import '../cubit/dashboard_users_cubit.dart';

import '../data/model/dashboard_user.dart';

class ProfilePage extends StatefulWidget {
  // GoogleSignInAccount user;


  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DashboardUser? authenticatedUser;
  final controller = ScrollController();
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardUsersCubit, DashboardUsersState>(
      builder: ((context, state) {
              if (state is DashboardUserFound) {
              authenticatedUser = state.dashboardUser;  
      }
        return SimpleDialog(
      // chil: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.person,
                size: 80,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      authenticatedUser?.email ?? 'Unavailable',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Permissions',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Read: ${authenticatedUser?.read ?? 'unavalable'}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Write: ${authenticatedUser?.write ?? 'unavalable'}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Admin: ${authenticatedUser?.admin ?? 'unavalable'}',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        IconButton(
          icon: const Icon(
            Icons.logout,
          ),
          tooltip: 'logout',
          onPressed: () => Navigator.pop(context, true),
        ),
      ].whereType<Widget>().toList(),
      // ),
    );
          }
  ));
  }
}
