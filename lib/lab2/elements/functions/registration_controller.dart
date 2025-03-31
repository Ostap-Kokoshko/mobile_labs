import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/storage/user_storage_secure.dart';
import 'package:mobile_labs/lab2/validation/registration_validation.dart';

class RegistrationController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserStorageSecure _storage = UserStorageSecure();

  Future<void> register(BuildContext context) async {
    final String? emailError =
    RegistrationValidation.validateEmail(emailController.text);
    final String? loginError =
    RegistrationValidation.validateLogin(loginController.text);
    final String? passwordError =
    RegistrationValidation.validatePassword(passwordController.text);

    if (emailError != null || loginError != null || passwordError != null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailError ?? loginError ?? passwordError!)),
      );
    } else {
      await _storage.saveUserData(
        emailController.text,
        loginController.text,
        passwordController.text,
      );

      await _storage.saveUserLoginStatus(true);

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void dispose() {
    emailController.dispose();
    loginController.dispose();
    passwordController.dispose();
  }
}
