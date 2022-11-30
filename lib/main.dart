import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_check_kidz_dashboard/data/authorization/authorization_repository.dart';
import 'package:go_check_kidz_dashboard/data/dashboard_user/dashboard_user_network_service.dart';
import 'package:go_check_kidz_dashboard/data/dashboard_user/dashboard_user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_check_kidz_dashboard/cubit/authorization_cubit.dart';
import 'cubit/dashboard_users_cubit.dart';
import 'cubit/eyepair_cubit.dart';
import 'cubit/image_cubit.dart';
import 'data/eyepair/eyepair_network_service.dart';
import 'data/eyepair/eyepair_repository.dart';
import 'data/eyepair_image/eyepair_image_network_service.dart';
import 'data/eyepair_image/eyepair_image_repository.dart';
import 'data/eyepair_image/eyepair_image_repository_instance.dart';
import 'screens/signin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences.getString('socialPlatform')));
}

class MyApp extends StatelessWidget {
  final String? previousSocialEmail;
  MyApp(
    this.previousSocialEmail, {
    Key? key,
  }) : super(key: key);

  final authorizationRepository = AuthorizationRepository();
  final dashboardUserRepository = DashboardUserRepository(DashboardUserNetworkService());
    final eyepairRepository = EyepairRepository(EyepairNetworkService());

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
              ..signInSilently(previousSocialEmail)
            // child: const SignInDemo(),
            ),
                        BlocProvider(
              create: (context) =>
                  EyepairCubit(eyepairRepository)..fetchFirstPage(),
            ),
            // BlocProvider(
            //   create: (context) => ImageCubit(ImageEyepairRepositoryInstance.repository),
            // ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 62, 220, 57),
              brightness: Brightness.light,
              secondary: Colors.lightBlue),
          // primarySwatch: Colors.blue,
        ),
        home: SignInPage(),
      ),
    );
  }
}
