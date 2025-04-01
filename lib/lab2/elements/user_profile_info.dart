import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  final String label;
  final String value;

  const UserInfo({
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
