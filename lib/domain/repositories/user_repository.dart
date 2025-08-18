import 'package:safealert/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> registerWithEmailAndPassword(
    String firstName,
    String lastName,
    String email,
    String password,
    String phone,
  );
  Future<UserEntity> signInWithGoogle();
  // Future<UserEntity> signInWithFacebook(); // Supprimé - Facebook non implémenté
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<UserEntity> updateProfile(UserEntity user);
}