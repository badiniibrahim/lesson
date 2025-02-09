import 'package:get/get.dart';
import 'package:lesson/data/models/course.dart';
import 'package:lesson/data/models/course_stats.dart';
import 'package:lesson/data/models/progress.dart';
import 'package:lesson/data/services/progress_service.dart';

class ProgressController extends GetxController {
  final ProgressService _progressService = ProgressService();
  final RxList<Course> courses = <Course>[].obs;
  final RxMap<String, CourseProgress> progressMap =
      <String, CourseProgress>{}.obs;
  final RxDouble totalProgress = 0.0.obs;
  final RxInt totalQuizScore = 0.obs;
  final RxInt completedChapters = 0.obs;
  final RxInt completedFlashcards = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadProgress();
  }

  Future<void> loadProgress() async {
    try {
      print('Loading courses...');
      courses.value = await _progressService.getAllCourses();
      print('Loaded ${courses.length} courses');

      for (var course in courses) {
        print('Loading progress for course: ${course.courseTitle}');
        final progress = await _progressService.getCourseProgress(course.id);
        if (progress != null) {
          progressMap[course.id] = progress;
          print('Progress loaded successfully');
        }
      }

      _calculateStatistics();
    } catch (e) {
      print('Erreur lors du chargement de la progression : $e');
    }
  }

  void _calculateStatistics() {
    int totalChapters = 0;
    int totalCompleted = 0;
    int totalFlashcards = 0;
    int totalCompletedFlashcards = 0;
    double totalQuizScores = 0;
    int quizCount = 0;

    for (var course in courses) {
      final progress = progressMap[course.id];
      if (progress != null) {
        // Calculer les chapitres complétés
        progress.chaptersProgress.forEach((_, value) {
          if (value >= 1.0) totalCompleted++;
        });
        totalChapters += course.chapters.length;

        // Calculer les flashcards complétées
        totalFlashcards += course.flashcards.length;
        totalCompletedFlashcards += progress.completedFlashcards.length;

        // Calculer le score moyen des quiz
        if (progress.quizScore > 0) {
          totalQuizScores += progress.quizScore;
          quizCount++;
        }
      }
    }

    // Mettre à jour les statistiques
    completedChapters.value = totalCompleted;
    completedFlashcards.value = totalCompletedFlashcards;
    totalProgress.value =
        totalChapters > 0 ? totalCompleted / totalChapters : 0;
    totalQuizScore.value =
        quizCount > 0 ? (totalQuizScores / quizCount).round() : 0;
  }

  List<MapEntry<String, double>> getCourseProgressList() {
    return courses.map((course) {
      final progress = progressMap[course.id];
      if (progress == null) return MapEntry(course.courseTitle, 0.0);

      double totalProgress = 0;
      int count = 0;
      progress.chaptersProgress.forEach((_, value) {
        totalProgress += value;
        count++;
      });

      return MapEntry(
        course.courseTitle,
        count > 0 ? totalProgress / count : 0.0,
      );
    }).toList();
  }

  double getCourseProgress(String courseId) {
    final progress = progressMap[courseId];
    if (progress == null) return 0.0;

    double total = 0;
    int count = 0;
    progress.chaptersProgress.forEach((_, value) {
      total += value;
      count++;
    });

    return count > 0 ? total / count : 0.0;
  }

  List<MapEntry<String, int>> getQuizScores() {
    return courses.map((course) {
      final progress = progressMap[course.id];
      return MapEntry(course.courseTitle, progress?.quizScore ?? 0);
    }).toList();
  }

  CourseStats? getCourseStatsById(String courseId) {
    // Trouver le cours correspondant à l'ID
    final course = courses.firstWhereOrNull((c) => c.id == courseId);
    // Récupérer la progression pour ce cours
    final progress = progressMap[courseId];

    // Si le cours ou la progression n'existe pas, retourner null
    if (course == null || progress == null) return null;

    // Calculer le nombre de chapitres complétés
    int completedChapters = 0;
    progress.chaptersProgress.forEach((_, value) {
      if (value >= 1.0) completedChapters++;
    });

    // Calculer la progression globale
    double overallProgress = 0;
    if (course.chapters.isNotEmpty) {
      double totalProgress = 0;
      progress.chaptersProgress.forEach((_, value) {
        totalProgress += value;
      });
      overallProgress = totalProgress / course.chapters.length;
    }

    // Retourner les statistiques complètes du cours
    return CourseStats(
      completedChapters: completedChapters,
      totalChapters: course.chapters.length,
      quizScore: progress.quizScore,
      completedFlashcards: progress.completedFlashcards.length,
      totalFlashcards: course.flashcards.length,
      overallProgress: overallProgress,
    );
  }
}
