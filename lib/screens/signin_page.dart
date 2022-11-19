import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:go_check_kidz_dashboard/cubit/authorization_cubit.dart';
import 'package:go_check_kidz_dashboard/cubit/dashboard_users_cubit.dart';
import 'package:go_check_kidz_dashboard/cubit/eyepair_cubit.dart';
import 'package:go_check_kidz_dashboard/data/eyepair/eyepair_repository.dart';
import 'package:go_check_kidz_dashboard/data/eyepair_image/eyepair_image_network_service.dart';
import 'package:go_check_kidz_dashboard/data/eyepair_image/eyepair_image_repository.dart';
import 'package:go_check_kidz_dashboard/screens/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubit/image_cubit.dart';
import '../data/eyepair/eyepair_network_service.dart';
import '../data/model/dashboard_user.dart';
import '../utils/custom_page_route.dart';
import '../widgets/error_banner.dart';

enum SocialPlatform {
  apple,
  google,
}

class SignInPage extends StatefulWidget {
  // List<AzureUser> azureUsers;

  SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String? socialEmail;
  String? errorDescription;
  // late List<AzureUser> azureUsers;
  List<DashboardUser> dashboardUsers = [];

  SocialPlatform? socialPlatform;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   azureUsers = widget.azureUsers;
  // }

  // bool _isAuthorized(BuildContext context) {
  //   if (azureUsers.isEmpty) {
  //     return false;
  //   }
  //   if (socialEmail == null) {
  //     return false;
  //   }

  //   final thisAzureUser = azureUsers.firstWhereOrNull(
  //       (azureUser) => azureUser.email.toLowerCase() == socialEmail!);
  //   if (thisAzureUser == null) {
  //     setState(() {
  //       errorDescription = '$socialEmail! is not an authorized dashboard user';
  //     });
  //     return false;
  //   }

  //   if (socialPlatform != null) {
  //     SharedPreferences.getInstance()
  //         .then((sharedPreferences) => sharedPreferences.setString(
  //               'socialPlatform',
  //               socialPlatform!.name,
  //             ));
  //   }

  //   final eyepairRepository = EyepairRepository(EyepairNetworkService());
  //   final ImageRepository =
  //       ImageRepository(ImageNetworkService());
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (context) => MultiBlocProvider(
  //         providers: [
  //           BlocProvider(
  //             create: (context) =>
  //                 EyepairCubit(eyepairRepository)..fetchFirstPage(),
  //           ),
  //           BlocProvider(
  //             create: (context) => ImageCubit(ImageRepository),
  //           ),
  //         ],
  //         child: DashboardPage(socialEmail!, azureUsers),
  //       ),
  //     ),
  //   );
  //   // Navigator.of(context).pushReplacement(
  //   //   MaterialPageRoute(
  //   //     builder: (context) => BlocProvider(
  //   //       create: (context) => EyepairsBloc(),
  //   //       child: DashboardPage(socialEmail!, azureUsers),
  //   //     ),
  //   //   ),
  //   // );
  //   return true;
  // }

// bool _isAuthorized(BuildContext context) {
//     if (dashboardUsers.isEmpty) {
//       return false;
//     }
//     if (socialEmail == null) {
//       return false;
//     }

//     if (socialPlatform != null) {
//       SharedPreferences.getInstance()
//           .then((sharedPreferences) => sharedPreferences.setString(
//                 'socialPlatform',
//                 socialPlatform!.name,
//               ));
//     }

//     final eyepairRepository = EyepairRepository(EyepairNetworkService());
//     final ImageRepository =
//         ImageRepository(ImageNetworkService());

//     Navigator.of(context).pushReplacement(
//       CustomPageRoute(child: MultiBlocProvider(
//           providers: [
//             BlocProvider(
//               create: (context) =>
//                   EyepairCubit(eyepairRepository)..fetchFirstPage(),
//             ),
//             BlocProvider(
//               create: (context) => ImageCubit(ImageRepository),
//             ),
//           ],
//           child: DashboardPage(socialEmail!,),
//         ),
//       ),
//     );
//     return true;
//   }

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
        // child: MultiBlocProvider(
        //   providers: [
        //     BlocProvider(
        //       create: (context) =>
        //           EyepairCubit(eyepairRepository)..fetchFirstPage(),
        //     ),
        //     BlocProvider(
        //       create: (context) => ImageCubit(imageRepository),
        //     ),
        //   ],
          child: DashboardPage(
            socialEmail!,
          ),
        // ),
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
