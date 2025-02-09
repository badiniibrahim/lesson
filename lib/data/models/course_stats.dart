class CourseStats {
  final int completedChapters;
  final int totalChapters;
  final int quizScore;
  final int completedFlashcards;
  final int totalFlashcards;
  final double overallProgress;

  CourseStats({
    required this.completedChapters,
    required this.totalChapters,
    required this.quizScore,
    required this.completedFlashcards,
    required this.totalFlashcards,
    required this.overallProgress,
  });

  double get chapterCompletionRate =>
      totalChapters > 0 ? completedChapters / totalChapters : 0.0;

  double get flashcardCompletionRate =>
      totalFlashcards > 0 ? completedFlashcards / totalFlashcards : 0.0;
}
