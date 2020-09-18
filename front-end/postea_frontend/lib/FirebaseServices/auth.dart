import 'package:firebase_auth/firebase_auth.dart';

import '../data_models/user.dart';

class AuthService {
  UserModel _FirebaseUser(FirebaseUser user) {
    if (user != null) {
      return UserModel(user.uid);
    } else {
      return null;
    }
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // sign in with email and password

  // register with email and password

  // sign out
}
