import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthorizationRepository {
  // bool appleSignInAvailable;
  String? socialEmail;
  String? socialPlatform;

  AuthorizationRepository();

  Future<String?> signInSilently(
    String previousSocialPlatform,
  ) async {
    if (previousSocialPlatform == 'google') {
      final googleUser = await GoogleSignIn().signInSilently();
      // socialEmail = googleUser?.email;
      if (googleUser?.email != null) {
        socialPlatform = 'google';
      }
      return googleUser?.email;
    }

    if (previousSocialPlatform == 'apple') {
      final appleUser = await _appleSignInSilently();
      if (appleUser != null) {
        socialPlatform = 'apple';
        return appleUser;
      }
    }
    return null;
  }

  Future<void> signOut() async {
    if (socialPlatform == null) {
      return;
    }
    if (socialPlatform == 'google') {
      await GoogleSignIn().signOut();
      socialPlatform == null;
      return;
    }
  }

  Future<String?> googleSignIn() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser?.email != null) {
      socialPlatform = 'google';
    }
    return googleUser?.email;
  }

  Future<String?> _appleSignInSilently() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.getString(
      "appleUserId",
    );
    if (userId != null) {
      final credentialState = await TheAppleSignIn.getCredentialState(userId);
      if (credentialState.status == CredentialStatus.authorized) {
        socialPlatform = 'apple';
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
          final appleEmail = sharedPreferences.getString(
            "appleEmail",
          );
          if (appleEmail != null && appleEmail.isNotEmpty) {
            socialPlatform = 'apple';
            return appleEmail;
          }
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
