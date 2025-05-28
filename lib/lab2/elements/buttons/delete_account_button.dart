import 'package:flutter/material.dart';

class DeleteAccountButton extends StatelessWidget {
  final double screenWidth;
  final VoidCallback onDelete;

  const DeleteAccountButton({
    required this.screenWidth,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onDelete,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: screenWidth * 0.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Видалити акаунт',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
