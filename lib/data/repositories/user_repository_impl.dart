import 'package:safealert/core/constants/app_constants.dart';
import 'package:safealert/domain/entities/user_entity.dart';
import 'package:safealert/domain/repositories/user_repository.dart';
import 'package:safealert/services/auth/firebase_auth_service.dart';
import 'package:safealert/services/firestore/firestore_service.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  UserRepositoryImpl(
    this._authService,
    this._firestoreService,
  );

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        return UserEntity(
          id: user.uid,
          firstName: user.displayName?.split(' ').first ?? '',
          lastName: user.displayName?.split(' ').skip(1).join(' ') ?? '',
          email: user.email ?? '',
          phone: user.phoneNumber,
          role: AppConstants.citizenRole,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'utilisateur: $e');
    }
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) async {
    try {
      final user = await _authService.signInWithEmailAndPassword(email, password);
      return UserEntity(
        id: user.uid,
        firstName: user.displayName?.split(' ').first ?? '',
        lastName: user.displayName?.split(' ').skip(1).join(' ') ?? '',
        email: user.email ?? '',
        phone: user.phoneNumber,
        role: AppConstants.citizenRole,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword(
    String firstName,
    String lastName,
    String email,
    String password,
    String phone,
  ) async {
    try {
      final user = await _authService.registerWithEmailAndPassword(email, password);
      
      // Mettre à jour le profil
      await _authService.updateProfile('$firstName $lastName');
      
      final userEntity = UserEntity(
        id: user.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        role: AppConstants.citizenRole,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Sauvegarder dans Firestore
      await _firestoreService.setDocument(
        AppConstants.usersCollection,
        user.uid,
        {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phone': phone,
          'role': AppConstants.citizenRole,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'isActive': true,
        },
      );

      return userEntity;
    } catch (e) {
      throw Exception('Erreur d\'inscription: $e');
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      return UserEntity(
        id: user.uid,
        firstName: user.displayName?.split(' ').first ?? '',
        lastName: user.displayName?.split(' ').skip(1).join(' ') ?? '',
        email: user.email ?? '',
        phone: user.phoneNumber,
        role: AppConstants.citizenRole,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Erreur de connexion Google: $e');
    }
  }

  // Méthode Facebook supprimée - fonctionnalité non implémentée

  @override
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw Exception('Erreur de déconnexion: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      throw Exception('Erreur d\'envoi de l\'email de réinitialisation: $e');
    }
  }

  @override
  Future<UserEntity> updateProfile(UserEntity user) async {
    try {
      await _firestoreService.updateDocument(
        AppConstants.usersCollection,
        user.id,
        {
          'firstName': user.firstName,
          'lastName': user.lastName,
          'phone': user.phone,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
      return user.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      throw Exception('Erreur de mise à jour du profil: $e');
    }
  }
}