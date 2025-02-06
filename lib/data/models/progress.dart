class CourseProgress {
  final String userId;
  final String courseId;
  final Map<String, double> chaptersProgress;
  final int quizScore;
  final List<String> completedFlashcards;
  final DateTime lastUpdated;

  CourseProgress({
    required this.userId,
    required this.courseId,
    required this.chaptersProgress,
    this.quizScore = 0,
    this.completedFlashcards = const [],
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'courseId': courseId,
      'chaptersProgress': chaptersProgress,
      'quizScore': quizScore,
      'completedFlashcards': completedFlashcards,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      userId: json['userId'],
      courseId: json['courseId'],
      chaptersProgress: Map<String, double>.from(json['chaptersProgress']),
      quizScore: json['quizScore'],
      completedFlashcards: List<String>.from(json['completedFlashcards']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  CourseProgress copyWith({
    String? userId,
    String? courseId,
    Map<String, double>? chaptersProgress,
    int? quizScore,
    List<String>? completedFlashcards,
    DateTime? lastUpdated,
  }) {
    return CourseProgress(
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      chaptersProgress: chaptersProgress ?? this.chaptersProgress,
      quizScore: quizScore ?? this.quizScore,
      completedFlashcards: completedFlashcards ?? this.completedFlashcards,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
