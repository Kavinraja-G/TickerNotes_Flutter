import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String uid;
  User({@required this.uid});
}

abstract class BaseAuthentication {
  Stream<User> get onAuthStateChanged;
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<void> signOut();
  Future<User> currentUser();
  Stream<FirebaseUser> get currentFirebaseUser;
}

class Auth implements BaseAuthentication{
  User _userFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(uid: user.uid);
  }

  Stream<User> get onAuthStateChanged {
    return FirebaseAuth.instance.onAuthStateChanged
        .map((event) => _userFromFirebase(event));
  }

  @override
  Future<User> signInAnonymously() async {
    final result = await FirebaseAuth.instance.signInAnonymously();
    return _userFromFirebase(result.user);
  }

  //Google SignIn
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final authResult = await FirebaseAuth.instance.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Tokens');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORT_BY_USER', message: 'Sign in was Aborted');
    }
  }

  @override
  Future<void> signOut() async {
    final googleAccount = GoogleSignIn();
    await googleAccount.signOut();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<User> currentUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    return _userFromFirebase(user);
  }

  Stream<FirebaseUser> get currentFirebaseUser {
    return FirebaseAuth.instance.onAuthStateChanged
        .map((event) => (event));
  }
}
