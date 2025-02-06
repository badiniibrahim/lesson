import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lesson/app/extensions/snackbar_helper.dart';
import 'package:lesson/app/modules/sign-in/state.dart';
import 'package:lesson/app/routes/app_pages.dart';
import 'package:lesson/domain/usecase/sign_in_usecase.dart';

import 'package:purchases_flutter/purchases_flutter.dart';

class SignInController extends GetxController {
  final SignInState state = SignInState();
  final SingInUseCase singInUseCase;

  final isLoading = false.obs;

  SignInController({
    required this.singInUseCase,
  });

  void signInWithEmailAndPassword() async {
    if (!validateFields()) return;

    isLoading.value = true;
    try {
      final credential = await singInUseCase.signInWithEmailAndPassword(
        state.emailTextController.text,
        state.passwordTextController.text,
      );
      /*if (await Purchases.isConfigured) {
        await Purchases.logIn(credential.user!.uid);
      } else {
        throw Exception(
            "Purchases is not configured. Please call Purchases.configure.");
      }*/

      if (credential.user != null && !credential.user!.emailVerified) {
        showCustomSnackbar(
          title: 'Error',
          message: "sign_up_auth_verification_email_sent".tr,
          isError: true,
        );
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final credential = await singInUseCase.signInWithGoogle();
      if (await Purchases.isConfigured) {
        await Purchases.logIn(credential.user!.uid);
      } else {
        throw Exception(
            "Purchases is not configured. Please call Purchases.configure.");
      }
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await singInUseCase.signOut();
      Get.offAllNamed(Routes.SIGN_IN);
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  bool validateFields() {
    if (state.emailTextController.text.isEmpty ||
        state.passwordTextController.text.isEmpty) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Email and password cannot be empty.'.tr,
        isError: true,
      );
      return false;
    }
    if (!GetUtils.isEmail(state.emailTextController.text)) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Invalid email format.'.tr,
        isError: true,
      );
      return false;
    }
    return true;
  }

  void handleError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          Get.snackbar('Alert', "signIn_user_not_found".tr);
          break;
        case 'wrong-password':
          Get.snackbar('Alert', "signIn_wrong_password".tr);
          break;
        default:
          Get.snackbar('Alert', error.message ?? 'Unknown error occurred.'.tr);
      }
    } else {
      Get.snackbar('Alert', error.toString());
    }
  }

  Future<bool> hasSessionValid() async {
    return await singInUseCase.hasSessionValid();
  }
}
