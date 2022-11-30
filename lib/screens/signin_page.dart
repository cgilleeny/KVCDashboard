
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:go_check_kidz_dashboard/cubit/authorization_cubit.dart';
import 'package:go_check_kidz_dashboard/cubit/dashboard_users_cubit.dart';
import 'package:go_check_kidz_dashboard/screens/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/dashboard_user.dart';
import '../utils/custom_page_route.dart';
import '../widgets/error_banner.dart';

enum SocialPlatform {
  apple,
  google,
}

class SignInPage extends StatefulWidget {

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String? socialEmail;
  String? errorDescription;
  List<DashboardUser> dashboardUsers = [];

  SocialPlatform? socialPlatform;

  void _navigateToDashboard(BuildContext context) {
    if (socialPlatform != null) {
      SharedPreferences.getInstance()
          .then((sharedPreferences) => sharedPreferences.setString(
                'socialPlatform',
                socialPlatform!.name,
              ));
    }

    Navigator.of(context).pushReplacement(
      CustomPageRoute(
          child: DashboardPage(
            socialEmail!,
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthorizationCubit, AuthorizationState>(
          listener: (context, state) {
            if (state is SilentlyAuthorized) {
              // print('state is SilentlyAuthorized');
              socialEmail = state.socialEmail.toLowerCase();
              if (dashboardUsers.isNotEmpty) {
                BlocProvider.of<DashboardUsersCubit>(context)
                    .fetchDashboardUser(socialEmail!);
              }
            }
            if (state is Authorized) {
              // print('state is Authorized');
              socialEmail = state.socialEmail.toLowerCase();
              if (dashboardUsers.isNotEmpty) {
                BlocProvider.of<DashboardUsersCubit>(context)
                    .fetchDashboardUser(socialEmail!);
              }
            }
          },
        ),
        BlocListener<DashboardUsersCubit, DashboardUsersState>(
          listener: (context, state) {
            if (state is DashboardUsersLoaded) {
              dashboardUsers = state.dashboardUsers;
              if (socialEmail != null) {
                BlocProvider.of<DashboardUsersCubit>(context)
                    .fetchDashboardUser(socialEmail!);
              }
            }
            if (state is DashboardUserFound) {
              if (state.dashboardUser.read) {
                return _navigateToDashboard(context);
              }
              setState(() {
                errorDescription =
                    'Dashboard user $socialEmail! does not have permission to view this dashboard.';
              });
            }
            if (state is DashboardUserNotFound) {
              setState(() {
                errorDescription =
                    'Counld not find dashboard user $socialEmail!.';
              });
            }
            if (state is DashboardUsersLoadError) {
              setState(() {
                errorDescription = state.errorDescription;
              });
            }
          },
        ),
      ],
      child: BlocBuilder<AuthorizationCubit, AuthorizationState>(
          builder: ((context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Social Sign In',
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                state is AuthorizationFailed
                    ? ErrorBanner(state.errorDescription)
                    : null,
                errorDescription != null ? ErrorBanner(errorDescription) : null,
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SignInButton(
                          Buttons.Apple,
                          text: 'Apple Sign In',
                          onPressed: () {
                            socialPlatform = SocialPlatform.apple;
                          },
                        ),
                        const SizedBox(
                          height: 25,
                          width: 220,
                        ),
                        SignInButton(
                          Buttons.GoogleDark,
                          text: 'Google Sign In',
                          onPressed: () {
                            if (state is! SilentlyAuthorizing) {
                              setState(() {
                                errorDescription = null;
                              });
                              socialPlatform = SocialPlatform.google;
                              BlocProvider.of<AuthorizationCubit>(context)
                                  .googleSignIn();
                            }
                          },
                        ),
                      ],
                    ),
                    state is SilentlyAuthorizing
                        ? const CircularProgressIndicator()
                        : null,
                    state is Authorizing
                        ? const CircularProgressIndicator()
                        : null,
                    state is AuthorizationFailed ? Text('falied') : null,
                  ].whereType<Widget>().toList(),
                ),
              ].whereType<Widget>().toList(),
            ),
          ),
        );
      })),
    );
  }
}
