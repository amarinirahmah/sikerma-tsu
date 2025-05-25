import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String type;
  final DateTime date;
  final Color iconColor;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.type,
    required this.date,
    this.iconColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: Text(type),
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        '${date.day}/${date.month}/${date.year}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
