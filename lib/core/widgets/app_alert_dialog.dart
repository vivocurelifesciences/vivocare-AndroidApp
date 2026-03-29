import 'package:flutter/material.dart';

enum AppAlertType { info, success, error }

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    required this.message,
    required this.title,
    required this.type,
    this.okLabel = 'OK',
  });

  final String message;
  final String title;
  final AppAlertType type;
  final String okLabel;

  static Future<void> show({
    required BuildContext context,
    required String message,
    AppAlertType type = AppAlertType.info,
    String? title,
    String okLabel = 'OK',
  }) {
    final String resolvedMessage = message.trim();
    if (resolvedMessage.isEmpty) {
      return Future<void>.value();
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AppAlertDialog(
          message: resolvedMessage,
          title: title ?? _defaultTitle(type),
          type: type,
          okLabel: okLabel,
        );
      },
    );
  }

  static Future<void> showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    String okLabel = 'OK',
  }) {
    return show(
      context: context,
      message: message,
      type: AppAlertType.success,
      title: title,
      okLabel: okLabel,
    );
  }

  static Future<void> showError({
    required BuildContext context,
    required String message,
    String? title,
    String okLabel = 'OK',
  }) {
    return show(
      context: context,
      message: message,
      type: AppAlertType.error,
      title: title,
      okLabel: okLabel,
    );
  }

  static Future<void> showInfo({
    required BuildContext context,
    required String message,
    String? title,
    String okLabel = 'OK',
  }) {
    return show(
      context: context,
      message: message,
      type: AppAlertType.info,
      title: title,
      okLabel: okLabel,
    );
  }

  static String _defaultTitle(AppAlertType type) {
    switch (type) {
      case AppAlertType.success:
        return 'Success';
      case AppAlertType.error:
        return 'Error';
      case AppAlertType.info:
        return 'Alert';
    }
  }

  (IconData, Color, Color) _appearance(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case AppAlertType.success:
        return (
          Icons.check_circle_rounded,
          const Color(0xFF1E8E5A),
          const Color(0xFFEAF8F0),
        );
      case AppAlertType.error:
        return (
          Icons.error_rounded,
          colorScheme.error,
          const Color(0xFFFFF1F1),
        );
      case AppAlertType.info:
        return (
          Icons.info_rounded,
          colorScheme.primary,
          const Color(0xFFEFF5FF),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color accentColor, Color surfaceColor) = _appearance(
      context,
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(24, 22, 24, 12),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: surfaceColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: accentColor),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1D3557),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF52606D)),
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(okLabel),
          ),
        ),
      ],
    );
  }
}
