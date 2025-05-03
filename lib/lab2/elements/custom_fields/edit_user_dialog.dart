import 'package:flutter/material.dart';

class EditUserDialog extends StatelessWidget {
  final String login;
  final String email;
  final void Function(String login, String email) onSave;

  const EditUserDialog({
    required this.login, required this.email, required this.onSave, super.key,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: login);
    final emailController = TextEditingController(text: email);

    return AlertDialog(
      title: const Text('Редагувати профіль'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Ім\'я користувача'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Скасувати'),
        ),
        ElevatedButton(
          onPressed: () {
            onSave(nameController.text, emailController.text);
            Navigator.pop(context);
          },
          child: const Text('Зберегти'),
        ),
      ],
    );
  }
}
