import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/storage/user_storage_secure.dart';

class LoginController {
  final UserStorageSecure _storage = UserStorageSecure();

  Future<void> login(
    BuildContext context,
    TextEditingController loginController,
    TextEditingController passwordController,
    GlobalKey<FormState> formKey,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final Map<String, String> userData = await _storage.getUserData();
    if (!context.mounted) return;

    if (loginController.text == userData['login'] &&
        passwordController.text == userData['password']) {
      Navigator.pushReplacementNamed(context, '/home');
      await _storage.saveUserLoginStatus(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Невірний логін або пароль')),
      );
    }
  }
}
