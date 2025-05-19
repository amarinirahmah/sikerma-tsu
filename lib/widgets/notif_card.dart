import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final String description;
  final Color iconColor;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.description,
    this.iconColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 25),
            const SizedBox(width: 16),
            Expanded(
              child: Text(description, style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
