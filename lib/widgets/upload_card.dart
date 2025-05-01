import 'package:flutter/material.dart';

class UploadCard extends StatelessWidget {
  final List<Widget> fields;
  final VoidCallback onSubmit;

  const UploadCard({super.key, required this.fields, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ...fields.map(
              (field) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: field,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: onSubmit,
                  label: const Text("Upload"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
