import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/authorization/authorization_repository.dart';


part 'authorization_state.dart';

class AuthorizationCubit extends Cubit<AuthorizationState> {
  final AuthorizationRepository repository;
  AuthorizationCubit(this.repository) : super(AuthorizationInitial());

  void signInSilently(String? previousSocialEmail) {
    if (previousSocialEmail == null) {
      emit(SilentAuthorizationFailed());
    }
    emit(SilentlyAuthorizing());
    repository.signInSilently(previousSocialEmail!).then((socialEmail) {
      if (socialEmail == null) {
        return emit(SilentAuthorizationFailed());
      }
      emit(SilentlyAuthorized(socialEmail));
    }).catchError((error) {
      print(error);
      emit(SilentAuthorizationFailed());
    });
  }

  void googleSignIn() {
    emit(Authorizing());
    repository.googleSignIn().then((socialEmail) {
      if (socialEmail == null) {
        return emit(const AuthorizationFailed('Null user'));
      }
      emit(Authorized(socialEmail));
    }).catchError((error) {
      print(error);
      emit(AuthorizationFailed(error.message ?? error.toString()));
    });
  }

  
}
