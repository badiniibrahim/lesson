import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson/domain/repository/sign_in_repositories.dart';

class SingInUseCase {
  final SignInRepository signInRepository;
  SingInUseCase({
    required this.signInRepository,
  });

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) {
    return signInRepository.signInWithEmailAndPassword(email, password);
  }

  Future<UserCredential> signInWithGoogle() {
    return signInRepository.signInWithGoogle();
  }

  Future<void> signOut() {
    return signInRepository.signOutInWithGoogle();
  }

  Future<bool> hasSessionValid() {
    return signInRepository.hasSessionValid();
  }
}
