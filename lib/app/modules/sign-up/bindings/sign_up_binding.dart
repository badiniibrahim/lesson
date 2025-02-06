import 'package:get/get.dart';
import 'package:lesson/app/core/di/service_locator.dart';
import 'package:lesson/domain/usecase/sign_up_usecase.dart';

import '../controllers/sign_up_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(
      () => SignUpController(
        signUpUseCase: getIt<SignUpUseCase>(),
      ),
    );
  }
}
