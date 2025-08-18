import 'package:flutter/foundation.dart';

class DebugHelper {
  static void log(String message, [String? tag]) {
    if (kDebugMode) {
      print('${tag ?? 'DEBUG'}: $message');
    }
  }

  static void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('ERROR: $message');
      if (error != null) print('Error details: $error');
      if (stackTrace != null) print('Stack trace: $stackTrace');
    }
  }
}