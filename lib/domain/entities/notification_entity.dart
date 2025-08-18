import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final String type;
  final String userId;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.userId,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        type,
        userId,
        createdAt,
        isRead,
        data,
      ];

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? userId,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }
}