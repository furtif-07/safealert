import 'package:equatable/equatable.dart';

class AlertEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String type;
  final String status;
  final double latitude;
  final double longitude;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String>? imageUrls;
  final List<String>? mediaUrls;
  final String? address;
  final String? location;
  final int priority;

  const AlertEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrls,
    this.mediaUrls,
    this.address,
    this.location,
    this.priority = 1,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        status,
        latitude,
        longitude,
        userId,
        createdAt,
        updatedAt,
        imageUrls,
        mediaUrls,
        address,
        location,
        priority,
      ];

  AlertEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? status,
    double? latitude,
    double? longitude,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? imageUrls,
    List<String>? mediaUrls,
    String? address,
    String? location,
    int? priority,
  }) {
    return AlertEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrls: imageUrls ?? this.imageUrls,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      address: address ?? this.address,
      location: location ?? this.location,
      priority: priority ?? this.priority,
    );
  }
}