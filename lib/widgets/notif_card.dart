import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final IconData icon;
  // final String title;
  final String type;
  final String message;
  final DateTime date;
  final Color iconColor;
  final VoidCallback? onDelete;

  const NotificationCard({
    super.key,
    required this.icon,
    // required this.title,
    required this.type,
    required this.message,
    required this.date,
    this.iconColor = Colors.orange,
    this.onDelete,
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
                  // Text(
                  //   title,
                  //   style: const TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      if (onDelete != null) // Icon X untuk hapus
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          tooltip: 'Hapus Notifikasi',
                          onPressed: onDelete,
                        ),
                    ],
                  ),
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
