import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthorizationRepository {
  // bool appleSignInAvailable;
  String? socialEmail;

  AuthorizationRepository();

  Future<String?> signInSilently(
    String previousSocialEmail,
  ) async {
    if (previousSocialEmail == 'google') {
      final googleUser = await GoogleSignIn().signInSilently();
      socialEmail = googleUser?.email;
      return socialEmail;
    }

    if (previousSocialEmail == 'apple') {
      return _appleSignInSilently();
    }
    return socialEmail;
  }

  Future<void> signOut() async {
    if (socialEmail == null) {
      return;
    }
    if (socialEmail == 'google') {
      await GoogleSignIn().signOut();
      socialEmail == null;
      return;
    }
  }

  Future<String?> googleSignIn() async {
    final googleUser = await GoogleSignIn().signIn();
    socialEmail = googleUser?.email;
    return socialEmail;
  }

  Future<String?> _appleSignInSilently() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.getString(
      "appleUserId",
    );
    if (userId != null) {
      final credentialState = await TheAppleSignIn.getCredentialState(userId);
      if (credentialState.status == CredentialStatus.authorized) {
        return sharedPreferences.getString('appleEmail');
      }
    }
    sharedPreferences.setString("appleEmail", '');
    sharedPreferences.setString("appleUserId", '');
    return null;
  }

  Future<String?> appleSignIn() async {
    final result = await TheAppleSignIn.performRequests(
      [
        const AppleIdRequest(
          requestedScopes: [Scope.email, Scope.fullName],
        ),
      ],
    );
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final credential = result.credential;
        if (credential == null) {
          throw Exception('User authorization missing credential data.');
        }
        final sharedPreferences = await SharedPreferences.getInstance();
        if (credential.user != null) {
          sharedPreferences.setString("appleUserId", credential.user!);
        }

        if (credential.email == null) {
          return sharedPreferences.getString(
            "appleEmail",
          );
        }
        sharedPreferences.setString("appleEmail", credential.email!);
        return credential.email;

      case AuthorizationStatus.error:
        throw Exception(result.error?.localizedDescription ?? 'Unkown error');

      case AuthorizationStatus.cancelled:
        throw Exception('User authorization canceled');
    }
  }
}
