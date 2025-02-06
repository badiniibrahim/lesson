import 'package:lesson/data/models/progress.dart';

class Course {
  String courseTitle;
  String description;
  String bannerImage;
  String category;
  List<Chapter> chapters;
  List<Quiz> quiz;
  List<Flashcard> flashcards;
  List<QA> qa;
  CourseProgress? progress;

  // Getter pour générer un ID unique basé sur le titre du cours
  String get id =>
      courseTitle.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');

  Course({
    required this.courseTitle,
    required this.description,
    required this.bannerImage,
    required this.category,
    required this.chapters,
    required this.quiz,
    required this.flashcards,
    required this.qa,
    this.progress,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseTitle: json["courseTitle"],
      description: json["description"],
      bannerImage: json["banner_image"],
      category: json["category"],
      chapters: (json["chapters"] as List)
          .map((chapter) => Chapter.fromJson(chapter))
          .toList(),
      quiz: (json["quiz"] as List).map((q) => Quiz.fromJson(q)).toList(),
      flashcards: (json["flashcards"] as List)
          .map((f) => Flashcard.fromJson(f))
          .toList(),
      qa: (json["qa"] as List).map((q) => QA.fromJson(q)).toList(),
      progress: json["progress"] != null
          ? CourseProgress.fromJson(json["progress"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "courseTitle": courseTitle,
      "description": description,
      "banner_image": bannerImage,
      "category": category,
      "chapters": chapters.map((c) => c.toJson()).toList(),
      "quiz": quiz.map((q) => q.toJson()).toList(),
      "flashcards": flashcards.map((f) => f.toJson()).toList(),
      "qa": qa.map((q) => q.toJson()).toList(),
      "progress": progress?.toJson(),
    };
  }

  Course copyWithProgress(CourseProgress? newProgress) {
    return Course(
      courseTitle: courseTitle,
      description: description,
      bannerImage: bannerImage,
      category: category,
      chapters: chapters,
      quiz: quiz,
      flashcards: flashcards,
      qa: qa,
      progress: newProgress,
    );
  }
}

class Chapter {
  String chapterName;
  List<Content> content;
  double? progress;

  // Getter pour générer un ID unique basé sur le nom du chapitre
  String get id =>
      chapterName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');

  Chapter({
    required this.chapterName,
    required this.content,
    this.progress,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterName: json["chapterName"],
      content:
          (json["content"] as List).map((c) => Content.fromJson(c)).toList(),
      progress: json["progress"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chapterName": chapterName,
      "content": content.map((c) => c.toJson()).toList(),
      "progress": progress,
    };
  }
}

class Content {
  String topic;
  String explain;
  String? code;
  String? example;
  bool isCompleted;

  // Getter pour générer un ID unique basé sur le sujet
  String get id => topic.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');

  Content({
    required this.topic,
    required this.explain,
    this.code,
    this.example,
    this.isCompleted = false,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      topic: json["topic"],
      explain: json["explain"],
      code: json["code"],
      example: json["example"],
      isCompleted: json["isCompleted"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "topic": topic,
      "explain": explain,
      "code": code,
      "example": example,
      "isCompleted": isCompleted,
    };
  }
}

class Quiz {
  String question;
  List<String> options;
  String correctAns;
  bool isCompleted;
  String? userAnswer;

  // Getter pour générer un ID unique basé sur la question
  String get id => question.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');

  Quiz({
    required this.question,
    required this.options,
    required this.correctAns,
    this.isCompleted = false,
    this.userAnswer,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json["question"],
      options: List<String>.from(json["options"]),
      correctAns: json["correctAns"],
      isCompleted: json["isCompleted"] ?? false,
      userAnswer: json["userAnswer"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "options": options,
      "correctAns": correctAns,
      "isCompleted": isCompleted,
      "userAnswer": userAnswer,
    };
  }
}

class Flashcard {
  String front;
  String back;
  bool isCompleted;

  // Getter pour générer un ID unique basé sur le front de la carte
  String get id => front.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');

  Flashcard({
    required this.front,
    required this.back,
    this.isCompleted = false,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      front: json["front"],
      back: json["back"],
      isCompleted: json["isCompleted"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "front": front,
      "back": back,
      "isCompleted": isCompleted,
    };
  }
}

class QA {
  String question;
  String answer;

  // Getter pour générer un ID unique basé sur la question
  String get id => question.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');

  QA({
    required this.question,
    required this.answer,
  });

  factory QA.fromJson(Map<String, dynamic> json) {
    return QA(
      question: json["question"],
      answer: json["answer"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "answer": answer,
    };
  }
}

class CourseData {
  List<Course> courses;

  CourseData({required this.courses});

  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      courses: (json["courses"] as List)
          .map((course) => Course.fromJson(course))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "courses": courses.map((c) => c.toJson()).toList(),
    };
  }
}
