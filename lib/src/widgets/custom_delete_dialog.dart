import 'package:flutter/material.dart';

class CustomDeleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomDeleteDialog({
    super.key,
    this.title = 'Are you sure?',
    this.message =
        'Do you really want to delete this item? After deleting you can\'t undo.',
    this.cancelText = 'Cancel',
    this.confirmText = 'Delete',
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFF2F5FF),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.close, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF2E3A59),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFE5EAFC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: onCancel,
                    child: Text(
                      cancelText,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF2E3A59),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: onConfirm,
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w600,
                      ),
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
