import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/elements/functions/home_controller.dart';

class HomeContent extends StatelessWidget {
  final HomeController controller;
  final bool hasConnection;
  final VoidCallback onToggleLock;
  final VoidCallback onToggleSmoke;

  const HomeContent({
    required this.controller,
    required this.hasConnection,
    required this.onToggleLock,
    required this.onToggleSmoke,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          'Ласкаво просимо до\nSMART LOCK',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 30),
        ValueListenableBuilder(
          valueListenable: controller.isLockActive,
          builder: (_, __, ___) {
            return ValueListenableBuilder(
              valueListenable: controller.isSmokeDetected,
              builder: (_, __, ___) {
                return AbsorbPointer(
                  absorbing: !hasConnection,
                  child: Opacity(
                    opacity: hasConnection ? 1 : 0.4,
                    child:
                        controller.buildInfoCard(onToggleLock, onToggleSmoke),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/profile'),
          style: ElevatedButton.styleFrom(
            backgroundColor: hasConnection ? Colors.orange : Colors.grey,
            padding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: isTablet ? 50 : 30,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            'Перейти до профілю',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => controller.logout(context),
          child: const Text(
            'Вийти',
            style: TextStyle(color: Colors.orange, fontSize: 16),
          ),
        ),
        if (!hasConnection)
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              '⚠ Немає з’єднання з Інтернетом',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
