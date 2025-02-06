class CourseTitles {
  final List<String> courseTitles;

  CourseTitles({required this.courseTitles});

  factory CourseTitles.fromJson(Map<String, dynamic> json) {
    return CourseTitles(
      courseTitles: List<String>.from(json['course_titles']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_titles': courseTitles,
    };
  }
}
