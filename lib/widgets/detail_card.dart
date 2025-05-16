import 'package:flutter/material.dart';
import 'package:sikermatsu/styles/style.dart';

class DetailCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String)? onStatusChange;
  final String? currentStatus;
  final String? role;

  const DetailCard({
    super.key,
    required this.data,
    this.onEdit,
    this.onDelete,
    this.onStatusChange,
    this.currentStatus,
    this.role,
  });

  @override
  Widget build(BuildContext context) {
    // Contoh opsi status
    final statuses = ['Disetujui', 'Diproses', 'Ditolak'];

    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ...data.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        "${entry.key}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${entry.value}",
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tampilkan dropdown status jika role admin/user dan callback ada
            if ((role == 'admin' || role == 'user') && onStatusChange != null)
              Row(
                children: [
                  const Text(
                    'Status: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: currentStatus ?? statuses.first,
                    items:
                        statuses
                            .map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ),
                            )
                            .toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null) {
                        onStatusChange!(newStatus);
                      }
                    },
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Tampilkan tombol Edit dan Hapus hanya jika role admin/user dan callback tidak null
            if (onEdit != null &&
                onDelete != null &&
                (role == 'admin' || role == 'user'))
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: onEdit,
                    style: CustomStyle.getButtonStyleByLabel('Edit'),
                    child: const Text('Edit'),
                  ),

                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: onDelete,
                    style: CustomStyle.getButtonStyleByLabel('Hapus'),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
