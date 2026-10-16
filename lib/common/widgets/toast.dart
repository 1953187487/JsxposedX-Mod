import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Toast {
  static void showToast(
    BuildContext context,
    String message, {
    String? buttonLabel,
    VoidCallback? onClick,
    Duration? duration,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark 
        ? const Color(0xFF2C2C2C) 
        : primaryColor;
    SmartDialog.showToast(
      '',
      displayTime: duration ?? const Duration(seconds: 2),
      alignment: Alignment.bottomCenter,
      builder: (_) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 50),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
