import 'package:flutter/foundation.dart';

class ErrorHandler {
  ErrorHandler._();

  static void logError(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('Error: $error');
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }

  static String getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return error.toString();
  }

  static String getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'weak-password':
        return 'Le mot de passe est trop faible';
      case 'invalid-email':
        return 'Email invalide';
      case 'network-request-failed':
        return 'Erreur de connexion réseau';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard';
      default:
        return 'Une erreur est survenue';
    }
  }
}