import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/authorization/authorization_repository.dart';


part 'authorization_state.dart';

class AuthorizationCubit extends Cubit<AuthorizationState> {
  final AuthorizationRepository repository;
  AuthorizationCubit(this.repository) : super(AuthorizationInitial());

  void signInSilently(String? previousSocialEmail) {
    if (previousSocialEmail == null) {
      return;
    }
    if (previousSocialEmail == 'google') {
      return _googleSignInSilently();
    }
    if (previousSocialEmail == 'apple') {
      return _appleSignInSilently();
    }
  }

  void _googleSignInSilently() {
    emit(SilentlyAuthorizing());
    GoogleSignIn().signInSilently().then((googleUser) {
      if (googleUser != null) {
        emit(SilentlyAuthorized(googleUser.email));
      } else {
        emit(SilentAuthorizationFailed());
      }
    }).catchError((error) {
      print(error);
      emit(SilentAuthorizationFailed());
    });
  }

  void googleSignIn() {
    emit(Authorizing());
    try {
      GoogleSignIn().signIn().then((googleUser) {
        if (googleUser != null) {
          emit(Authorized(googleUser.email));
        } else {
          emit(AuthorizationFailed('Null user'));
        }
      }).catchError((error) {
        print(error);
        emit(AuthorizationFailed(error.toString()));
      });
    } on PlatformException catch (e) {
      emit(AuthorizationFailed(e.message ?? e.toString()));
    }
  }

  void _appleSignInSilently() {}
}
