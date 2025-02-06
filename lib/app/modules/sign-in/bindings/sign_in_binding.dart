import 'package:get/get.dart';
import 'package:lesson/app/core/di/service_locator.dart';
import 'package:lesson/domain/usecase/sign_in_usecase.dart';

import '../controllers/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(
      () => SignInController(singInUseCase: getIt<SingInUseCase>()),
    );
  }
}
