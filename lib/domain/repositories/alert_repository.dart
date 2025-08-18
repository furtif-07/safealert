import 'package:safealert/domain/entities/alert_entity.dart';

abstract class AlertRepository {
  Future<List<AlertEntity>> getNearbyAlerts(double latitude, double longitude, double radius);
  Future<AlertEntity> createAlert(
    String title,
    String description,
    String type,
    double latitude,
    double longitude,
  );
  Future<AlertEntity> getAlertById(String id);
  Future<void> updateAlertStatus(String id, String status);
  Future<List<AlertEntity>> getUserAlerts(String userId);
}