import 'package:get/get.dart';
import 'package:lesson/app/core/di/service_locator.dart';
import 'package:lesson/domain/usecase/generate_usecase.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(generateTopicUsecase: getIt<GenerateTopicUsecase>()),
    );
  }
}
