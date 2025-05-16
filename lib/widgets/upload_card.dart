import 'package:flutter/material.dart';
import 'package:sikermatsu/styles/style.dart';

class UploadCard extends StatelessWidget {
  final String? title;
  final List<Widget> fields;
  final VoidCallback onSubmit;

  const UploadCard({
    super.key,
    this.title,
    required this.fields,
    required this.onSubmit,
  });

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
            if (title != null) ...[
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ],
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
                  style: CustomStyle.getButtonStyleByLabel('Upload'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
