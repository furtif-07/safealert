import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  Future<String> uploadFile(String path, File file) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Erreur lors de l\'upload: $e');
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression: $e');
    }
  }

  Future<String> getDownloadURL(String path) async {
    try {
      return await _storage.ref().child(path).getDownloadURL();
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'URL: $e');
    }
  }
}