import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson/domain/repository/sign_up_repositories.dart';

class SignUpRepositoryImpl extends SignUpRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  SignUpRepositoryImpl({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password, String userName) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(userName);

    await firebaseFirestore.collection('users').doc(credential.user!.uid).set({
      'email': email,
      'displayName': userName,
      'subscription': false,
      "uid": credential.user?.uid,
      'photoURL': credential.user?.photoURL,
    });

    return credential;
  }

  @override
  Future<void> upsertUser(User? param) async {
    final userDoc = firebaseFirestore.collection('users').doc(param?.uid);
    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      await userDoc.set({
        'uid': param?.uid,
        'displayName': param?.displayName,
        'photoURL': param?.photoURL,
        'email': param?.email,
        'subscription': false,
      });
    }
  }
}
