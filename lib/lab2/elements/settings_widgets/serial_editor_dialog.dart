import 'package:flutter/material.dart';

void showSerialEditorDialog(
  BuildContext context, {
  required void Function(String) onSubmitted,
}) {
  String serialNumber = '';
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Зміна серійного номера'),
      content: TextField(
        onChanged: (value) => serialNumber = value,
        decoration: const InputDecoration(labelText: 'Новий серійник'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onSubmitted(serialNumber);
          },
          child: const Text('Зберегти'),
        ),
      ],
    ),
  );
}
