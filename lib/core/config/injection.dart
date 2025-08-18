import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

import 'package:safealert/services/auth/firebase_auth_service.dart';
import 'package:safealert/services/firestore/firestore_service.dart';
import 'package:safealert/services/storage/storage_service.dart';
import 'package:safealert/services/messaging/messaging_service.dart';
import 'package:safealert/services/functions/functions_service.dart';

import 'package:safealert/data/repositories/user_repository_impl.dart';
import 'package:safealert/data/repositories/alert_repository_impl.dart';
import 'package:safealert/data/repositories/notification_repository_impl.dart';

import 'package:safealert/domain/repositories/user_repository.dart';
import 'package:safealert/domain/repositories/alert_repository.dart';
import 'package:safealert/domain/repositories/notification_repository.dart';

import 'package:safealert/presentation/bloc/auth/auth_bloc.dart';
import 'package:safealert/presentation/bloc/alert/alert_bloc.dart';
import 'package:safealert/presentation/bloc/notification/notification_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (getIt.isRegistered<FirebaseAuth>()) return;

  try {
    // Firebase services - register as lazy singletons
    getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    getIt.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance);
    getIt
        .registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
    getIt.registerLazySingleton<FirebaseMessaging>(
        () => FirebaseMessaging.instance);
    getIt.registerLazySingleton<FirebaseFunctions>(
        () => FirebaseFunctions.instance);

    // Google Sign-In
    if (!kIsWeb) {
      getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn(
            scopes: ['email', 'profile'],
          ));
    }

    // App services
    getIt.registerLazySingleton<FirebaseAuthService>(
        () => FirebaseAuthService(getIt<FirebaseAuth>()));
    getIt.registerLazySingleton<FirestoreService>(
        () => FirestoreService(getIt<FirebaseFirestore>()));
    getIt.registerLazySingleton<StorageService>(
        () => StorageService(getIt<FirebaseStorage>()));
    getIt.registerLazySingleton<MessagingService>(
        () => MessagingService(getIt<FirebaseMessaging>()));
    getIt.registerLazySingleton<FunctionsService>(
        () => FunctionsService(getIt<FirebaseFunctions>()));

    // Repositories
    getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
        getIt<FirebaseAuthService>(), getIt<FirestoreService>()));

    getIt.registerLazySingleton<AlertRepository>(
        () => AlertRepositoryImpl(getIt<FirestoreService>()));

    getIt.registerLazySingleton<NotificationRepository>(
        () => NotificationRepositoryImpl(getIt<FirestoreService>()));

    // BLoCs - factories for state management
    getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<UserRepository>()));
    getIt.registerFactory<AlertBloc>(() => AlertBloc(getIt<AlertRepository>()));
    getIt.registerFactory<NotificationBloc>(
        () => NotificationBloc(getIt<NotificationRepository>()));
  } catch (e) {
    debugPrint('Dependency injection error: $e');
    rethrow;
  }
}
