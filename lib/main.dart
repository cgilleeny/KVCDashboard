import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_check_kidz_dashboard/data/authorization/authorization_repository.dart';
import 'package:go_check_kidz_dashboard/data/dashboard_user/dashboard_user_network_service.dart';
import 'package:go_check_kidz_dashboard/data/dashboard_user/dashboard_user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_check_kidz_dashboard/cubit/authorization_cubit.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'cubit/dashboard_users_cubit.dart';
import 'cubit/eyepair_cubit.dart';
import 'data/eyepair/eyepair_repository_instance.dart';
import 'screens/signin_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final appleSignInAvailable = await TheAppleSignIn.isAvailable();
  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(
      sharedPreferences.getString('socialPlatform'), appleSignInAvailable));
}

class MyApp extends StatelessWidget {
  final String? previousSocialEmail;
  final bool appleSignInAvailable;
  MyApp(
    this.previousSocialEmail,
    this.appleSignInAvailable, {
    Key? key,
  }) : super(key: key);

  final authorizationRepository = AuthorizationRepository();
  final dashboardUserRepository =
      DashboardUserRepository(DashboardUserNetworkService());
  // final eyepairRepository = EyepairRepository(EyepairNetworkService());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DashboardUsersCubit(dashboardUserRepository)
            ..fetchDashboardUsers(),
        ),
        BlocProvider(
            create: (context) => AuthorizationCubit(authorizationRepository)
              ..signInSilently(previousSocialEmail, appleSignInAvailable)),
        BlocProvider(
          create: (context) =>
              EyepairCubit(EyepairRepositoryInstance.repository)..fetchFirstPage(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255,69,179,216),
          appBarTheme: const AppBarTheme(backgroundColor: Color.fromARGB(255,66,106,206),),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Color.fromARGB(255,69,179,216),),
          
          buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        home: SignInPage(appleSignInAvailable),
      ),
    );
  }
}

/*
class SilentSignInPage extends StatelessWidget {
  const SilentSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthorizationCubit, AuthorizationState>(
          listener: (context, state) {
            if (state is SilentlyAuthorized) {
              socialEmail = state.socialEmail.toLowerCase();
              if (dashboardUsersInitialized) {
                FlutterNativeSplash.remove();
                BlocProvider.of<DashboardUsersCubit>(context)
                    .fetchDashboardUser(socialEmail!);
              }
            }
            if (state is SilentAuthorizationFailed || state is! SilentlyAuthorizing) {
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
*/