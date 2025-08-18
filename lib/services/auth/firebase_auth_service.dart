import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<User> registerWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } catch (e) {
      throw Exception('Erreur d\'inscription: $e');
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Connexion Google annulée');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user!;
    } catch (e) {
      throw Exception('Erreur de connexion Google: $e');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Erreur d\'envoi de l\'email: $e');
    }
  }

  Future<void> updateProfile(String displayName) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(displayName);
    } catch (e) {
      throw Exception('Erreur de mise à jour du profil: $e');
    }
  }
}