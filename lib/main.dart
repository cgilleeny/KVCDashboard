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
import 'keys/azure_connection_strings.dart';
import 'package:azstore/azstore.dart';

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
  final String? previousSocialPlatform;
  final bool appleSignInAvailable;
  MyApp(
    this.previousSocialPlatform,
    this.appleSignInAvailable, {
    Key? key,
  }) : super(key: key);

  final authorizationRepository = AuthorizationRepository();
  final dashboardUserRepository =
      DashboardUserRepository(DashboardUserNetworkService(AzureStorage.parse(dashboardUserConnectionString), 'dashboardusers'));
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
              ..signInSilently(previousSocialPlatform, appleSignInAvailable)),
        BlocProvider(
          create: (context) =>
              EyepairCubit(EyepairRepositoryInstance.repository),
          // ..fetchFirstPage(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 69, 179, 216),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 66, 106, 206),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 69, 179, 216),
          ),
          buttonTheme:
              const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        home: SignInPage(appleSignInAvailable),
      ),
    );
  }
}
