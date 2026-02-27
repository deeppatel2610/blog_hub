import 'dart:ui';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:flutter/material.dart';

/// A single utility class to show various types of UI messages.
/// Usage: AppMessenger.showSnackBar(context, message: 'Hello!')
class AppMessenger {
  AppMessenger._();

  // ─────────────────────────────────────────────
  // SNACK BAR
  // ─────────────────────────────────────────────

  /// Show a styled SnackBar.
  static void showSnackBar(
    BuildContext context, {
    required String message,
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: type.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(type.icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ALERT DIALOG
  // ─────────────────────────────────────────────

  /// Show a styled AlertDialog.
  static Future<bool?> showAlertDialog(
    BuildContext context, {
    required String title,
    required String message,
    MessageType type = MessageType.info,
    String confirmLabel = 'OK',
    String? cancelLabel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        actionsPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: type.backgroundColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(type.icon, color: type.backgroundColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: type.backgroundColor,
                ),
              ),
            ),
          ],
        ),
        content:
            Text(message, style: const TextStyle(fontSize: 14, height: 1.5)),
        actions: [
          if (cancelLabel != null)
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(cancelLabel),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: type.backgroundColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM SHEET
  // ─────────────────────────────────────────────

  /// Show a styled modal bottom sheet message.
  static Future<void> showBottomSheet(
    BuildContext context, {
    required String title,
    required String message,
    MessageType type = MessageType.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: type.backgroundColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(type.icon, size: 36, color: type.backgroundColor),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: type.backgroundColor,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 24),
            if (actionLabel != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: type.backgroundColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      onAction?.call();
                    },
                    child: Text(actionLabel),
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TOAST OVERLAY (custom, no external package)
  // ─────────────────────────────────────────────

  /// Show a lightweight toast overlay at the top of the screen.
  static void showToast(
    BuildContext context, {
    required String message,
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastWidget(
        message: message,
        type: type,
        duration: duration,
        onDismiss: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }

  // ─────────────────────────────────────────────
  // LOADING DIALOG
  // ─────────────────────────────────────────────

  /// Show a loading overlay dialog. Call [hideLoading] to dismiss.
  static void showLoading(
    BuildContext context, {
    String message = 'Please wait...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.all(28),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(message, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Dismiss the loading dialog.
  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  // ─────────────────────────────────────────────
  // INLINE BANNER (returns a Widget, not shown directly)
  // ─────────────────────────────────────────────

  /// Returns a styled inline banner widget to embed in your UI.
  static Widget inlineBanner({
    required String message,
    required MessageType type,
    String? title,
    VoidCallback? onDismiss,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: type.backgroundColor.withOpacity(0.1),
        border: Border(left: BorderSide(color: type.backgroundColor, width: 4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(type.icon, color: type.backgroundColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: type.backgroundColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(message,
                    style: const TextStyle(fontSize: 13, height: 1.4)),
              ],
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close, size: 18, color: Colors.grey.shade600),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MESSAGE TYPE ENUM
// ─────────────────────────────────────────────


// ─────────────────────────────────────────────
// PRIVATE: TOAST WIDGET
// ─────────────────────────────────────────────

class _ToastWidget extends StatefulWidget {
  final String message;
  final MessageType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    Future.delayed(widget.duration, () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 24,
      right: 24,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _opacity,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.type.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.type.backgroundColor.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(widget.type.icon, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// EXAMPLE USAGE (remove in production)
// ─────────────────────────────────────────────
//
// AppMessenger.showSnackBar(context, message: 'Saved!', type: MessageType.success);
//
// await AppMessenger.showAlertDialog(
//   context,
//   title: 'Delete item?',
//   message: 'This action cannot be undone.',
//   type: MessageType.error,
//   confirmLabel: 'Delete',
//   cancelLabel: 'Cancel',
// );
//
// AppMessenger.showBottomSheet(
//   context,
//   title: 'No internet',
//   message: 'Check your connection and try again.',
//   type: MessageType.warning,
//   actionLabel: 'Retry',
//   onAction: () => fetchData(),
// );
//
// AppMessenger.showToast(context, message: 'Copied!', type: MessageType.success);
//
// AppMessenger.showLoading(context);
// await doSomething();
// AppMessenger.hideLoading(context);
//
// // Inline widget inside build():
// AppMessenger.inlineBanner(
//   title: 'Heads up',
//   message: 'Your session will expire in 5 minutes.',
//   type: MessageType.warning,
//   onDismiss: () => setState(() => _showBanner = false),
// )
