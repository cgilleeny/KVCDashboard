part of 'authorization_cubit.dart';

abstract class AuthorizationState extends Equatable {
  const AuthorizationState();

  @override
  List<Object> get props => [];
}

class AuthorizationInitial extends AuthorizationState {}

// class GoogleSilentlyAuthenticated extends AuthorizationInitial {
//   final GoogleSignInAccount googleUser;

//   GoogleSilentlyAuthenticated(this.googleUser);
// }

// class GoogleSilentlyAuthorizing extends AuthorizationState {}

// class GoogleSilentAuthorizationFailed extends AuthorizationState {}

// class GoogleAuthorizing extends AuthorizationState {}

class SilentlyAuthorized extends AuthorizationState {
  final String socialEmail;

  const SilentlyAuthorized(this.socialEmail);
}

class SilentlyAuthorizing extends AuthorizationState {}

class SilentAuthorizationFailed extends AuthorizationState {}

class Authorized extends AuthorizationState {
  final String socialEmail;

  const Authorized(this.socialEmail);
}

class Authorizing extends AuthorizationState {}

class AuthorizationFailed extends AuthorizationState {
  final String errorDescription;
  
  const AuthorizationFailed(this.errorDescription);
}

class SigningOut extends AuthorizationState {}
class SignedOut extends AuthorizationState {}