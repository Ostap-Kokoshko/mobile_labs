import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/elements/functions/profile_page_controller.dart';

class DeleteAccountButton extends StatelessWidget {
  final ProfileController controller;
  final double screenWidth;

  const DeleteAccountButton({
    required this.controller,
    required this.screenWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => controller.deleteAccount(context),
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
