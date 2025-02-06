import 'package:get/get.dart';
import 'package:lesson/app/extensions/constant.dart';
import 'package:lesson/app/extensions/snackbar_helper.dart';
import 'package:lesson/app/modules/home/state.dart';
import 'package:lesson/app/modules/home/widgets/select_topic_widget.dart';
import 'package:lesson/data/models/progress.dart';
import 'package:lesson/data/services/progress_service.dart';
import 'package:lesson/domain/usecase/generate_usecase.dart';

class HomeController extends GetxController {
  final HomeState state = HomeState();
  final GenerateTopicUsecase generateTopicUsecase;
  final ProgressService _progressService = ProgressService();
  final Rx<CourseProgress?> courseProgress = Rx<CourseProgress?>(null);
  final RxDouble overallProgress = 0.0.obs;
  final RxMap<String, double> chaptersProgress = <String, double>{}.obs;
  final RxMap<String, int> quizScores = <String, int>{}.obs;

  HomeController({required this.generateTopicUsecase});

  Future<void> generateTopic() async {
    if (state.isLoading) return;

    state.isLoading = true;
    update();
    try {
      final result = await generateTopicUsecase.generateTopic(
        "${state.topicTextController.text} $topicPrompt",
      );
      Get.to(
        transition: Transition.fade,
        () => SelectTopicWidget(
          courseTitles: result.courseTitles,
        ),
      );
    } on Exception catch (e) {
      _handleError('Erreur lors de la récupération des voyages', e);
    } finally {
      state.isLoading = false;
      update();
    }
  }

  Future<void> generateCourse() async {
    if (state.isLoading) return;
    state.isLoading = true;
    update();
    try {
      await generateTopicUsecase.generateCourse(
        "${state.selectedTopics.toList()} $coursePrompt",
      );
      //TODO Goto home screen
    } on Exception catch (e) {
      _handleError('Erreur lors de la génération du cours', e);
    } finally {
      state.isLoading = false;
      update();
    }
  }

  Future<void> getUserCourse() async {
    if (state.isLoading) return;
    state.isLoading = true;
    update();
    try {
      final result = await generateTopicUsecase.getUserCourse();
      state.courseList = result;
    } on Exception catch (e) {
      _handleError('Erreur lors de la génération du cours', e);
    } finally {
      state.isLoading = false;
      update();
    }
  }

  void toggleTopicSelection(String topic) {
    state.toggleTopic(topic);
    update();
  }

  void _handleError(String message, Exception error) {
    showCustomSnackbar(
      title: 'Erreur',
      message: '$message: ${error.toString()}',
      isError: true,
    );
  }

  Future<void> loadCourseProgress(String courseId) async {
    courseProgress.value = await _progressService.getCourseProgress(courseId);
    overallProgress.value = await _progressService.getOverallProgress(courseId);
  }

  Future<void> updateChapterProgress(
    String courseId,
    String chapterId,
    double progress,
  ) async {
    await _progressService.updateChapterProgress(courseId, chapterId, progress);
    await loadCourseProgress(courseId);
  }

  Future<void> updateQuizScore(String courseId, int score) async {
    await _progressService.updateQuizScore(courseId, score);
    await loadCourseProgress(courseId);
  }

  Future<void> markFlashcardCompleted(
    String courseId,
    String flashcardId,
  ) async {
    await _progressService.markFlashcardCompleted(courseId, flashcardId);
    await loadCourseProgress(courseId);
  }

  double getChapterProgress(String chapterId) {
    return courseProgress.value?.chaptersProgress[chapterId] ?? 0.0;
  }

  double getQuizProgress(String courseId) {
    print(courseId);
    final score = quizScores[courseId] ?? 0;
    // Convertir le score en progression (0.0 à 1.0)
    return score / 100;
  }

  @override
  void onInit() {
    super.onInit();
    getUserCourse();
    chaptersProgress.value = {};
    quizScores.value = {};
  }
}
