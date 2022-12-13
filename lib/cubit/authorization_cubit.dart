import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/authorization/authorization_repository.dart';

part 'authorization_state.dart';

class AuthorizationCubit extends Cubit<AuthorizationState> {
  final AuthorizationRepository repository;
  AuthorizationCubit(this.repository) : super(AuthorizationInitial());

  void signInSilently(
      String? previousSocialPlatform, bool appleSignInAvailable) {
    if (previousSocialPlatform == null) {
      return emit(SilentAuthorizationFailed());
    }
    if (previousSocialPlatform == 'apple' && !appleSignInAvailable) {
      return emit(SilentAuthorizationFailed());
    }
    emit(SilentlyAuthorizing());
    repository.signInSilently(previousSocialPlatform).then((socialEmail) {
      if (socialEmail == null) {
        return emit(SilentAuthorizationFailed());
      }
      emit(SilentlyAuthorized(socialEmail));
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
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
      if (kDebugMode) {
        print(error);
      }
      emit(AuthorizationFailed(error.message ?? error.toString()));
    });
  }

  void appleSignIn() {
    emit(Authorizing());
    repository.appleSignIn().then((socialEmail) {
      if (socialEmail == null) {
        return emit(const AuthorizationFailed('Null user'));
      }
      emit(Authorized(socialEmail));
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      emit(AuthorizationFailed(error.message ?? error.toString()));
    });
  }

  void signOut() {
    emit(SigningOut());
    repository.signOut().then((_) {
      emit(
        SignedOut(),
      );
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      emit(AuthorizationFailed(error.message ?? error.toString()));
    });
  }
}
