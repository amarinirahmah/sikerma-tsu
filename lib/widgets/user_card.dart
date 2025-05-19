import 'package:flutter/material.dart';
import 'package:sikermatsu/styles/style.dart';

class UserCard extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final String buttonLabel;
  final bool isLoading;
  final VoidCallback onSubmit;
  final Widget? footer;

  const UserCard({
    super.key,
    required this.title,
    required this.formKey,
    required this.fields,
    required this.buttonLabel,
    required this.isLoading,
    required this.onSubmit,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: CustomStyle.headline3),

              const SizedBox(height: 24),
              ...fields.map(
                (field) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: field,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : onSubmit,
                style: CustomStyle.getButtonStyleByLabel(buttonLabel),
                child:
                    isLoading
                        ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Text(buttonLabel),
                // child: Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Text(buttonLabel),
                //     if (isLoading) ...[
                //       const SizedBox(width: 12),
                //       SizedBox(
                //         width: 16,
                //         height: 16,
                //         child: CircularProgressIndicator(
                //           strokeWidth: 2,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ],
                //   ],
                // ),
              ),

              // ElevatedButton(
              //   onPressed: isLoading ? null : onSubmit,
              //   style: CustomStyle.getButtonStyleByLabel(buttonLabel),
              //   child:
              //       isLoading
              //           ? const CircularProgressIndicator(strokeWidth: 2)
              //           : Text(buttonLabel),
              // ),
              if (footer != null) ...[const SizedBox(height: 16), footer!],
            ],
          ),
        ),
      ),
    );
  }
}
