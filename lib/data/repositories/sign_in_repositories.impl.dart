import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lesson/domain/repository/sign_in_repositories.dart';

class SignInRepositoriesImpl extends SignInRepository {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firebaseFirestore;

  SignInRepositoriesImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firebaseFirestore,
  });

  @override
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await upsertUser(userCredential.user);
      return userCredential;
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOutInWithGoogle() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      rethrow;
    } on Exception catch (e) {
      throw Exception(e);
    }
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
        'createdAt': DateTime.now(),
        'lastLogin': DateTime.now(),
        'subscription': false,
      });
      await firebaseFirestore.collection('user_settings').doc(param!.uid).set({
        'pushNotificationsEnabled': true,
        'emailNotificationsEnabled': true,
        'budgetAlertsEnabled': true,
        'goalAlertsEnabled': true,
        'billRemindersEnabled': true,
        'currency': '€',
        'language': 'fr',
        'darkModeEnabled': false,
        'createdAt': DateTime.now(),
      });
    } else {
      await userDoc.update({
        'displayName': param?.displayName,
        'photoURL': param?.photoURL,
        'email': param?.email,
      });
    }
  }

  @override
  Future<bool> hasSessionValid() async {
    User? currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      final userDoc = await firebaseFirestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
