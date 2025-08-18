import 'package:safealert/core/constants/app_constants.dart';
import 'package:safealert/domain/entities/notification_entity.dart';
import 'package:safealert/domain/repositories/notification_repository.dart';
import 'package:safealert/services/firestore/firestore_service.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirestoreService _firestoreService;

  NotificationRepositoryImpl(this._firestoreService);

  @override
  Future<List<NotificationEntity>> getUserNotifications(String userId) async {
    try {
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des notifications: $e');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestoreService.updateDocument(
        AppConstants.notificationsCollection,
        notificationId,
        {
          'isRead': true,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      throw Exception('Erreur lors du marquage comme lu: $e');
    }
  }

  @override
  Future<void> sendNotification(String userId, String title, String body) async {
    try {
      final notificationId = DateTime.now().millisecondsSinceEpoch.toString();
      
      await _firestoreService.setDocument(
        AppConstants.notificationsCollection,
        notificationId,
        {
          'title': title,
          'body': body,
          'type': 'alert',
          'userId': userId,
          'createdAt': DateTime.now().toIso8601String(),
          'isRead': false,
        },
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi de la notification: $e');
    }
  }
}