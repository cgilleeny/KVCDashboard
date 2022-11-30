import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  GoogleSignInAccount? _currentUser;


  Future<GoogleSignInAccount?> signInSilently() async {
    _currentUser = await GoogleSignIn().signInSilently();
    return _currentUser;
  }
}
