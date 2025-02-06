import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson/domain/repository/sign_up_repositories.dart';

class SignUpUseCase {
  final SignUpRepository signUpRepository;

  SignUpUseCase({required this.signUpRepository});

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password, String userName) {
    return signUpRepository.createUserWithEmailAndPassword(
        email, password, userName);
  }

  Future<void> upsertUser(User? param) async {
    signUpRepository.upsertUser(param);
  }
}
