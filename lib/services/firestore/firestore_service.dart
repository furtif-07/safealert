import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  Future<void> setDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).set(data);
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde: $e');
    }
  }

  Future<Map<String, dynamic>?> getDocument(String collection, String docId) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération: $e');
    }
  }

  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour: $e');
    }
  }

  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression: $e');
    }
  }

  Stream<QuerySnapshot> getCollection(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  Future<List<Map<String, dynamic>>> getDocuments(String collection) async {
    try {
      final querySnapshot = await _firestore.collection(collection).get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des documents: $e');
    }
  }
}