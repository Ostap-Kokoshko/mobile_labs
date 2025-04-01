import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }
}

class ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final String activeText;
  final String inactiveText;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onToggle;

  const ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.activeText,
    required this.inactiveText,
    required this.activeColor,
    required this.inactiveColor,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.orange, size: 30),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        Text(
          value ? activeText : inactiveText,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        IconButton(
          icon: Icon(
            value ? Icons.check : Icons.cancel,
            color: value ? activeColor : inactiveColor,
          ),
          onPressed: onToggle,
        ),
      ],
    );
  }
}
