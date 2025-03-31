import 'package:flutter/material.dart';

Widget buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
    ) {
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

Widget buildToggleRow({
  required IconData icon,
  required String label,
  required bool value,
  required String activeText,
  required String inactiveText,
  required Color activeColor,
  required Color inactiveColor,
  required VoidCallback onToggle,
}) {
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
