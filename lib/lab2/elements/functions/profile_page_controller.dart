import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/storage/user_storage_secure.dart';

class ProfileController {
  final UserStorageSecure _storage = UserStorageSecure();

  Future<Map<String, String>> loadUserData() async {
    return await _storage.getUserDataForChange();
  }

  Future<void> saveUserData(String email, String login) async {
    await _storage.saveUserDataForChange(email, login);
  }

  Future<void> deleteAccount(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Видалити акаунт'),
          content: const Text('Ви впевнені, що хочете видалити акаунт?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Скасувати'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                await _storage.clearUserData();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Видалити'),
            ),
          ],
        );
      },
    );
  }
}
