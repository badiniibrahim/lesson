import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson/data/models/course.dart';
import 'package:lesson/data/models/course_titles.dart';
import 'package:lesson/data/services/gemini_service.dart';
import 'package:lesson/domain/repository/generate_repositories.dart';

class GenerateRepositoriesImpl extends GenerateRepository {
  final Gemini gemini;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  GenerateRepositoriesImpl({
    required this.gemini,
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  @override
  Future<CourseTitles> generateTopic(String prompt) async {
    return await gemini.generateTopic(prompt);
  }

  @override
  Future<void> generateCourse(String prompt) async {
    final result = await gemini.generateCourse(prompt);
    for (var course in result.courses) {
      await firebaseFirestore.collection("courses").add({
        ...course.toJson(),
        "createdBy": firebaseAuth.currentUser?.email,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<List<Course>> getUserCourse() async {
    final querySnapshot = await firebaseFirestore
        .collection("courses")
        .where("createdBy", isEqualTo: firebaseAuth.currentUser?.email)
        .get();

    return querySnapshot.docs
        .map((doc) => Course.fromJson(doc.data()))
        .toList();
  }
}
