import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson/data/models/progress.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference get _progressCollection =>
      _firestore.collection('courseProgress');

  // Get current user progress for a course
  Future<CourseProgress?> getCourseProgress(String courseId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      final doc = await _progressCollection.doc('${userId}_$courseId').get();

      if (!doc.exists) return null;

      return CourseProgress.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting course progress: $e');
      return null;
    }
  }

  // Update chapter progress
  Future<void> updateChapterProgress(
    String courseId,
    String chapterId,
    double progress,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final docId = '${userId}_$courseId';
      final currentProgress = await getCourseProgress(courseId);

      final updatedChaptersProgress = Map<String, double>.from(
        currentProgress?.chaptersProgress ?? {},
      );
      updatedChaptersProgress[chapterId] = progress;

      await _progressCollection.doc(docId).set({
        'userId': userId,
        'courseId': courseId,
        'chaptersProgress': updatedChaptersProgress,
        'quizScore': currentProgress?.quizScore ?? 0,
        'completedFlashcards': currentProgress?.completedFlashcards ?? [],
        'lastUpdated': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating chapter progress: $e');
    }
  }

  // Update quiz score
  Future<void> updateQuizScore(String courseId, int score) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final docId = '${userId}_$courseId';
      await _progressCollection.doc(docId).set({
        'userId': userId,
        'courseId': courseId,
        'quizScore': score,
        'lastUpdated': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating quiz score: $e');
    }
  }

  // Mark flashcard as completed
  Future<void> markFlashcardCompleted(
    String courseId,
    String flashcardId,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final docId = '${userId}_$courseId';
      final currentProgress = await getCourseProgress(courseId);

      final completedFlashcards = List<String>.from(
        currentProgress?.completedFlashcards ?? [],
      );

      if (!completedFlashcards.contains(flashcardId)) {
        completedFlashcards.add(flashcardId);
      }

      await _progressCollection.doc(docId).set({
        'uid': userId,
        'courseId': courseId,
        'completedFlashcards': completedFlashcards,
        'lastUpdated': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error marking flashcard as completed: $e');
    }
  }

  // Get overall course progress
  Future<double> getOverallProgress(String courseId) async {
    try {
      final progress = await getCourseProgress(courseId);
      if (progress == null) return 0.0;

      final chaptersProgress = progress.chaptersProgress.values;
      if (chaptersProgress.isEmpty) return 0.0;

      return chaptersProgress.reduce((a, b) => a + b) / chaptersProgress.length;
    } catch (e) {
      print('Error calculating overall progress: $e');
      return 0.0;
    }
  }
}
