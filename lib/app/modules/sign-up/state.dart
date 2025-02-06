import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpState {
  final RxBool _isObscureText = RxBool(true);
  set isObscureText(value) => _isObscureText.value = value;
  bool get isObscureText => _isObscureText.value;

  final _isLoading = RxBool(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final Rx<TextEditingController> _emailTextController =
      TextEditingController().obs;
  TextEditingController get emailTextController => _emailTextController.value;

  final Rx<TextEditingController> _passwordTextController =
      TextEditingController().obs;
  TextEditingController get passwordTextController =>
      _passwordTextController.value;

  final Rx<TextEditingController> _fullNameTextController =
      TextEditingController().obs;
  TextEditingController get fullNameTextController =>
      _fullNameTextController.value;
}
