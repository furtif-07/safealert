import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safealert/domain/entities/alert_entity.dart';
import 'package:safealert/domain/repositories/alert_repository.dart';

// Events
abstract class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlertsEvent extends AlertEvent {}

class CreateAlertEvent extends AlertEvent {
  final String title;
  final String description;
  final String type;
  final double latitude;
  final double longitude;

  const CreateAlertEvent({
    required this.title,
    required this.description,
    required this.type,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [title, description, type, latitude, longitude];
}

class LoadAlertDetailsEvent extends AlertEvent {
  final String alertId;

  const LoadAlertDetailsEvent(this.alertId);

  @override
  List<Object> get props => [alertId];
}

// States
abstract class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object?> get props => [];
}

class AlertInitial extends AlertState {}

class AlertLoading extends AlertState {}

class AlertsLoaded extends AlertState {
  final List<AlertEntity> alerts;

  const AlertsLoaded(this.alerts);

  @override
  List<Object> get props => [alerts];
}

class AlertCreated extends AlertState {
  final AlertEntity alert;

  const AlertCreated(this.alert);

  @override
  List<Object> get props => [alert];
}

class AlertDetailsLoaded extends AlertState {
  final AlertEntity alert;

  const AlertDetailsLoaded(this.alert);

  @override
  List<Object> get props => [alert];
}

class AlertError extends AlertState {
  final String message;

  const AlertError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final AlertRepository _alertRepository;

  AlertBloc(this._alertRepository) : super(AlertInitial()) {
    on<LoadAlertsEvent>(_onLoadAlerts);
    on<CreateAlertEvent>(_onCreateAlert);
    on<LoadAlertDetailsEvent>(_onLoadAlertDetails);
  }

  Future<void> _onLoadAlerts(
    LoadAlertsEvent event,
    Emitter<AlertState> emit,
  ) async {
    emit(AlertLoading());
    try {
      final alerts = await _alertRepository.getNearbyAlerts(0.0, 0.0, 10000);
      emit(AlertsLoaded(alerts));
    } catch (e) {
      emit(AlertError(e.toString()));
    }
  }

  Future<void> _onCreateAlert(
    CreateAlertEvent event,
    Emitter<AlertState> emit,
  ) async {
    emit(AlertLoading());
    try {
      final alert = await _alertRepository.createAlert(
        event.title,
        event.description,
        event.type,
        event.latitude,
        event.longitude,
      );
      emit(AlertCreated(alert));
    } catch (e) {
      emit(AlertError(e.toString()));
    }
  }

  Future<void> _onLoadAlertDetails(
    LoadAlertDetailsEvent event,
    Emitter<AlertState> emit,
  ) async {
    emit(AlertLoading());
    try {
      final alert = await _alertRepository.getAlertById(event.alertId);
      emit(AlertDetailsLoaded(alert));
    } catch (e) {
      emit(AlertError(e.toString()));
    }
  }
}