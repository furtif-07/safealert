import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  final FirebaseMessaging _messaging;

  MessagingService(this._messaging);

  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      throw Exception('Erreur lors de la récupération du token: $e');
    }
  }

  Future<void> requestPermission() async {
    try {
      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } catch (e) {
      throw Exception('Erreur lors de la demande de permission: $e');
    }
  }

  void onMessage(Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessage.listen(handler);
  }

  void onMessageOpenedApp(Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessageOpenedApp.listen(handler);
  }
}