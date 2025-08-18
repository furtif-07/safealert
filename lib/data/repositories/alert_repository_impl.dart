import 'package:safealert/core/constants/app_constants.dart';
import 'package:safealert/domain/entities/alert_entity.dart';
import 'package:safealert/domain/repositories/alert_repository.dart';
import 'package:safealert/services/firestore/firestore_service.dart';

class AlertRepositoryImpl implements AlertRepository {
  final FirestoreService _firestoreService;

  AlertRepositoryImpl(this._firestoreService);

  @override
  Future<List<AlertEntity>> getNearbyAlerts(double latitude, double longitude, double radius) async {
    try {
      // Pour l'instant, retourner une liste vide
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des alertes: $e');
    }
  }

  @override
  Future<AlertEntity> createAlert(
    String title,
    String description,
    String type,
    double latitude,
    double longitude,
  ) async {
    try {
      final alertId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();
      
      final alertData = {
        'title': title,
        'description': description,
        'type': type,
        'status': AppConstants.pendingStatus,
        'latitude': latitude,
        'longitude': longitude,
        'userId': 'current_user_id', 
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
        'priority': 1,
      };

      await _firestoreService.setDocument(
        AppConstants.alertsCollection,
        alertId,
        alertData,
      );

      return AlertEntity(
        id: alertId,
        title: title,
        description: description,
        type: type,
        status: AppConstants.pendingStatus,
        latitude: latitude,
        longitude: longitude,
        userId: 'current_user_id',
        createdAt: now,
        updatedAt: now,
        priority: 1,
      );
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'alerte: $e');
    }
  }

  @override
  Future<AlertEntity> getAlertById(String id) async {
    try {
      final doc = await _firestoreService.getDocument(AppConstants.alertsCollection, id);
      if (doc == null) {
        throw Exception('Alerte non trouvée');
      }

      return AlertEntity(
        id: id,
        title: doc['title'] ?? '',
        description: doc['description'] ?? '',
        type: doc['type'] ?? '',
        status: doc['status'] ?? '',
        latitude: doc['latitude']?.toDouble() ?? 0.0,
        longitude: doc['longitude']?.toDouble() ?? 0.0,
        userId: doc['userId'] ?? '',
        createdAt: DateTime.parse(doc['createdAt'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(doc['updatedAt'] ?? DateTime.now().toIso8601String()),
        priority: doc['priority'] ?? 1,
      );
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'alerte: $e');
    }
  }

  @override
  Future<void> updateAlertStatus(String id, String status) async {
    try {
      await _firestoreService.updateDocument(
        AppConstants.alertsCollection,
        id,
        {
          'status': status,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du statut: $e');
    }
  }

  @override
  Future<List<AlertEntity>> getUserAlerts(String userId) async {
    try {
      return [];
    } catch (e) {
      throw Exception('Erreur lors de la récupération des alertes utilisateur: $e');
    }
  }
}