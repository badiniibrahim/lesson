import 'package:get/get.dart';
import 'package:lesson/app/modules/sign-up/state.dart';
import 'package:lesson/app/routes/app_pages.dart';
import 'package:lesson/domain/errors/failure.dart';
import 'package:lesson/domain/usecase/sign_up_usecase.dart';

class SignUpController extends GetxController {
  final SignUpState state = SignUpState();
  final SignUpUseCase signUpUseCase;

  SignUpController({
    required this.signUpUseCase,
  });

  Future<void> createUser() async {
    if (state.fullNameTextController.text.isEmpty ||
        state.emailTextController.text.isEmpty ||
        state.passwordTextController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required.');
      return;
    }

    state.isLoading = true;

    try {
      final credential = await signUpUseCase.createUserWithEmailAndPassword(
        state.emailTextController.text,
        state.passwordTextController.text,
        state.fullNameTextController.text,
      );

      await credential.user!.sendEmailVerification();
      Get.snackbar('Alert', 'sign_up_auth_verification_email_sent'.tr);
      Get.offAndToNamed(Routes.SIGN_IN);
    } on Failure catch (failure) {
      Get.snackbar('Error', failure.message);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    } finally {
      state.isLoading = false;
    }
  }
}
