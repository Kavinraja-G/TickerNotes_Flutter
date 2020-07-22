import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String uid;
  User({@required this.uid});
}

abstract class BaseAuthentication {
  Stream<User> get onChangedAuthstate;
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<void> signOut();
}

class Auth implements BaseAuthentication {
  Auth();  
  User _UserFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(uid: user.uid);
  }

  @override
  Future<User> signInAnonymously() async {
    final userData = await FirebaseAuth.instance.signInAnonymously();
    return _UserFromFirebase(userData.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final authdata = await FirebaseAuth.instance.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return _UserFromFirebase(authdata.user);
      } else {
        throw PlatformException(
          code: 'ERROR_INVALID_GOOGLE_AUTH_TOKEN',
          message: 'Google Auth Token is missing',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'User aborted sigin',
      );
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
    return _UserFromFirebase(user);
  }

  @override
  Stream<User> get onChangedAuthstate
  {
    return FirebaseAuth.instance.onAuthStateChanged.map(
      (event) => _UserFromFirebase(event)
    );
  }
}
