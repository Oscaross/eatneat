import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmationDialog {
  /// For actions that are important or consequential, such as data deletion, renders a nicely styled confirmation box. Contains a button bar with two buttons, confirm or cancel the action and then some text that describes what will happen.
  static Future<void> showConfirmationScreen(BuildContext context, String? title, String message, String cancelButton, String confirmButton, VoidCallback? onCancel, VoidCallback onConfirm) async {
    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: (title == null) ? Text("Are you sure?") : Text(title),
          content: Center(
            child: Text(message),
          ),
          actions: [
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () => (onCancel == null) ? Navigator.pop(context) : onCancel.call(),
                  child: Text(cancelButton),
                ),

                TextButton(
                  onPressed: () => onConfirm.call(),
                  child: Text(confirmButton),
                ),
              ]
            )
          ],
        );
      }
    );
  }
}