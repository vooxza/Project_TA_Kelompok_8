import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? textConfirm;
  final String? textCancel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? buttonColor;

  const CustomDialog({
    super.key,
    this.title = "Alert",
    this.message = "Dialog message",
    this.textConfirm,
    this.textCancel,
    this.onConfirm,
    this.onCancel,
    this.buttonColor,
  });

  static const Color primaryRed = Color(0xFFB71C1C);

  @override
  Widget build(BuildContext context) {
    final color = buttonColor ?? primaryRed;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          /// BUTTONS
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: [
              /// CANCEL BUTTON (OUTLINE)
              if (textCancel != null || onCancel != null)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: color, width: 2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onCancel?.call();
                  },
                  child: Text(
                    textCancel ?? "Cancel",
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              /// CONFIRM BUTTON (SOLID)
              if (textConfirm != null || onConfirm != null)
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm?.call();
                  },
                  child: Text(
                    textConfirm ?? "OK",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}