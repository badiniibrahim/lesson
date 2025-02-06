import 'package:firebase_auth/firebase_auth.dart';

abstract class SignInRepository {
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<void> signOutInWithGoogle();
  Future<void> upsertUser(User param);
  Future<bool> hasSessionValid();
}
