import 'package:safealert/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getUserNotifications(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> sendNotification(String userId, String title, String body);
}