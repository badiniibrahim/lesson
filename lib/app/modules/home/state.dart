import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:lesson/data/models/course.dart';
import 'package:lesson/data/models/course_titles.dart';

class HomeState {
  final RxBool _isLoading = RxBool(false);
  set isLoading(value) => _isLoading.value = value;
  bool get isLoading => _isLoading.value;

  final Rx<TextEditingController> _topicTextController =
      TextEditingController().obs;
  TextEditingController get topicTextController => _topicTextController.value;

  final Rxn<CourseTitles> _courseTitles = Rxn<CourseTitles>();
  set courseTitles(value) => _courseTitles.value = value;
  CourseTitles? get courseTitles => _courseTitles.value;

  final RxList<Course> _courseList = <Course>[].obs;
  set courseList(value) => _courseList.value = value;
  List<Course> get courseList => _courseList;

  final _selectedTopics = <String>{}.obs;
  Set<String> get selectedTopics => _selectedTopics;

  void toggleTopic(String topic) {
    if (_selectedTopics.contains(topic)) {
      _selectedTopics.remove(topic);
    } else {
      _selectedTopics.add(topic);
    }
  }
}
