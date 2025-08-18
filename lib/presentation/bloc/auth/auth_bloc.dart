import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safealert/domain/entities/user_entity.dart';
import 'package:safealert/domain/repositories/user_repository.dart';

// Événements
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;

  const SignUpEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
  });

  @override
  List<Object> get props => [firstName, lastName, email, password, phone];
}

class SignOutEvent extends AuthEvent {}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class SignInWithGoogleEvent extends AuthEvent {}

// class SignInWithFacebookEvent extends AuthEvent {} // Supprimé - Facebook non implémenté

// États
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthenticatedState extends AuthState {
  final UserEntity user;

  const AuthenticatedState(this.user);

  @override
  List<Object> get props => [user];
}

class UnauthenticatedState extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class PasswordResetSent extends AuthState {
  final String email;

  const PasswordResetSent(this.email);

  @override
  List<Object> get props => [email];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc(this._userRepository) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    // on<SignInWithFacebookEvent>(_onSignInWithFacebook); // Supprimé - Facebook non implémenté
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _userRepository.getCurrentUser();
      if (user != null) {
        emit(AuthenticatedState(user));
      } else {
        emit(UnauthenticatedState());
      }
    } catch (e) {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onSignIn(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _userRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _userRepository.registerWithEmailAndPassword(
        event.firstName,
        event.lastName,
        event.email,
        event.password,
        event.phone,
      );
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _userRepository.signOut();
      emit(UnauthenticatedState());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _userRepository.sendPasswordResetEmail(event.email);
      emit(PasswordResetSent(event.email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _userRepository.signInWithGoogle();
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Méthode Facebook supprimée - fonctionnalité non implémentée
}
