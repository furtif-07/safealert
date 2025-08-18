import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safealert/domain/entities/notification_entity.dart';
import 'package:safealert/domain/repositories/notification_repository.dart';

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {}

class MarkAsReadEvent extends NotificationEvent {
  final String notificationId;

  const MarkAsReadEvent(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

// States
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<NotificationEntity> notifications;

  const NotificationsLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc(this._notificationRepository) : super(NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<MarkAsReadEvent>(_onMarkAsRead);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final notifications = await _notificationRepository.getUserNotifications('');
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _notificationRepository.markAsRead(event.notificationId);
      add(LoadNotificationsEvent());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}