import 'package:firebase_auth/firebase_auth.dart';

abstract class SignUpRepository {
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password, String userName);
  Future<void> upsertUser(User? param);
}
