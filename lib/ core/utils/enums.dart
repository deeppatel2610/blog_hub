import 'package:flutter/material.dart';

enum HttpMethod { get, post, put, delete }

enum MessageType { success, error, warning, info }

extension MessageTypeExtension on MessageType {
  Color get backgroundColor {
    switch (this) {
      case MessageType.success:
        return const Color(0xFF22C55E);
      case MessageType.error:
        return const Color(0xFFEF4444);
      case MessageType.warning:
        return const Color(0xFFF59E0B);
      case MessageType.info:
        return const Color(0xFF3B82F6);
    }
  }

  IconData get icon {
    switch (this) {
      case MessageType.success:
        return Icons.check_circle_rounded;
      case MessageType.error:
        return Icons.error_rounded;
      case MessageType.warning:
        return Icons.warning_amber_rounded;
      case MessageType.info:
        return Icons.info_rounded;
    }
  }

  String get label {
    switch (this) {
      case MessageType.success:
        return 'Success';
      case MessageType.error:
        return 'Error';
      case MessageType.warning:
        return 'Warning';
      case MessageType.info:
        return 'Info';
    }
  }
}
