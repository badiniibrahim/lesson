import 'package:lesson/data/models/course.dart';
import 'package:lesson/data/models/course_titles.dart';

abstract class GenerateRepository {
  Future<CourseTitles> generateTopic(String prompt);
  Future<void> generateCourse(String prompt);
  Future<List<Course>> getUserCourse();
}
