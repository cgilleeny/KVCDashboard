import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:go_check_kidz_dashboard/cubit/authorization_cubit.dart';
import 'package:go_check_kidz_dashboard/cubit/dashboard_users_cubit.dart';
import 'package:go_check_kidz_dashboard/screens/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/apple_sign_in_button.dart' as i_button;
import '../data/model/dashboard_user.dart';
import '../utils/custom_page_route.dart';
import '../widgets/error_banner.dart';

enum SocialPlatform {
  apple,
  google,
}

class SignInPage extends StatefulWidget {
  final bool appleSignInAvailable;

  const SignInPage(this.appleSignInAvailable, {Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String? socialEmail;
  String? errorDescription;
  bool dashboardUsersInitialized = false;
  bool isSilentlyAuthorized = false;
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
      isSilentlyAuthorized  // don't animate if we never showed the signin page
          ? MaterialPageRoute(
              builder: (context) => const DashboardPage(),
            )
          : CustomPageRoute(
              child: const DashboardPage(),
            ),
    );

    // Navigator.of(context).pushReplacement(
    //   CustomPageRoute(
    //     child: const DashboardPage(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthorizationCubit, AuthorizationState>(
          listener: (context, state) {
            if (state is SilentlyAuthorized) {
              isSilentlyAuthorized = true;
              socialEmail = state.socialEmail.toLowerCase();
              if (dashboardUsersInitialized) {
                BlocProvider.of<DashboardUsersCubit>(context)
                    .fetchDashboardUser(socialEmail!);
              }
            }
            if (state is SilentAuthorizationFailed) {
              FlutterNativeSplash.remove();
            }
            if (state is Authorized) {
              socialEmail = state.socialEmail.toLowerCase();
              if (dashboardUsersInitialized) {
                BlocProvider.of<DashboardUsersCubit>(context)
                    .fetchDashboardUser(socialEmail!);
              }
            }
          },
        ),
        BlocListener<DashboardUsersCubit, DashboardUsersState>(
          listener: (context, state) {
            if (state is DashboardUsersLoaded) {
              dashboardUsersInitialized = true;
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
                errorDescription = 'Unrecognized dashboard user: $socialEmail.';
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
              'KVC Dashboard',
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is AuthorizationFailed)
                  ErrorBanner(state.errorDescription),
                if (errorDescription != null) ErrorBanner(errorDescription),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.appleSignInAvailable)
                          SignInButton(
                            Buttons.Apple,
                            text: 'Apple Sign In',
                            onPressed: () {
                              if (state is! SilentlyAuthorizing) {
                                setState(() {
                                  errorDescription = null;
                                });
                                BlocProvider.of<DashboardUsersCubit>(context)
                                    .reset();
                                socialPlatform = SocialPlatform.apple;
                                BlocProvider.of<AuthorizationCubit>(context)
                                    .appleSignIn();
                              }
                            },
                          ),
                        if (widget.appleSignInAvailable)
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
                  ],
                ),
              ],
            ),
          ),
        );
      })),
    );
  }
}
