import 'package:lesson/data/models/course.dart';
import 'package:lesson/data/models/course_titles.dart';
import 'package:lesson/domain/repository/generate_repositories.dart';

class GenerateTopicUsecase {
  final GenerateRepository generateTopicRepositories;

  GenerateTopicUsecase({required this.generateTopicRepositories});

  Future<CourseTitles> generateTopic(String prompt) async {
    return await generateTopicRepositories.generateTopic(prompt);
  }

  Future<void> generateCourse(String prompt) async {
    await generateTopicRepositories.generateCourse(prompt);
  }

  Future<List<Course>> getUserCourse() async {
    return await generateTopicRepositories.getUserCourse();
  }
}
