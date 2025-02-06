import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart' as generative;
import 'package:lesson/app/extensions/constant.dart';
import 'package:lesson/data/models/course.dart';
import 'package:lesson/data/models/course_titles.dart';

abstract class GeminiService {
  Future<CourseTitles> generateTopic(String prompt);
  Future<CourseData> generateCourse(String prompt);
}

class Gemini implements GeminiService {
  final generative.GenerativeModel generativeModel;

  Gemini({required this.generativeModel});

  @override
  Future<CourseTitles> generateTopic(String prompt) async {
    final chat = generativeModel.startChat(history: topicHistory);
    final content = generative.Content.text(prompt);
    final response = await chat.sendMessage(content);
    return CourseTitles.fromJson(jsonDecode(response.text!));
  }

  @override
  Future<CourseData> generateCourse(String prompt) async {
    final chat = generativeModel.startChat(history: courseHistory);
    final content = generative.Content.text(prompt);
    final response = await chat.sendMessage(content);
    return CourseData.fromJson(jsonDecode(response.text!));
  }
}
