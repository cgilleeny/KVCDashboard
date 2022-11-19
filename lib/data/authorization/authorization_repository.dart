import 'package:google_sign_in/google_sign_in.dart';

class AuthorizationRepository {
  String? socialEmail;

  Future<String?> signInSilently(String previousSocialEmail) async {
    if (previousSocialEmail == 'google') {
      final googleUser = await GoogleSignIn().signInSilently();
      socialEmail = googleUser?.email;
      return socialEmail;
    }
    if (previousSocialEmail == 'apple') {
      // return _appleSignInSilently();
    }
    return socialEmail;
  }

  Future<String?> googleSignIn() async {
    final googleUser = await GoogleSignIn().signIn();
    socialEmail = googleUser?.email;
    return socialEmail;
  }
}
