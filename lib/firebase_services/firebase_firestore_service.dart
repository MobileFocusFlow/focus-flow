import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Veri ekleme
  Future<void> addData(String collectionPath, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      print("Firestore Add Error: $e");
    }
  }

  // Veri güncelleme
  Future<void> updateData(
      String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update(data);
    } catch (e) {
      print("Firestore Update Error: $e");
    }
  }

  Future<void> updateRoutineByKey(String collectionPath, String key,
      Map<String, dynamic> updatedData) async {
    try {
      // Belgeyi `key` alanına göre sorgula
      QuerySnapshot snapshot = await _firestore
          .collection(collectionPath)
          .where('key', isEqualTo: key)
          .get();

      // Sorgu sonucundaki belgeler üzerinde güncelleme yap
      for (var doc in snapshot.docs) {
        await doc.reference.update(updatedData);
        print("Updated document with key: $key and ID: ${doc.id}");
      }
    } catch (e) {
      print("Error updating document with key $key: $e");
    }
  }

  // Veri silme
  Future<void> deleteData(String collectionPath, String docId) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      print("Firestore Delete Error: $e");
    }
  }

  Future<void> deleteRoutineByKey(String collectionPath, String key) async {
    try {
      // Belgeyi `key` alanına göre sorgula
      QuerySnapshot snapshot = await _firestore
          .collection(collectionPath)
          .where('key', isEqualTo: key)
          .get();

      // Belgeler arasında gezin ve sil
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
        print("Deleted document with key: $key and ID: ${doc.id}");
      }
    } catch (e) {
      print("Error deleting document with key $key: $e");
    }
  }

  // Veri çekme
  Future<List<Map<String, dynamic>>> fetchData(String collectionPath) async {
    try {
      final snapshot = await _firestore.collection(collectionPath).get();
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      print("Firestore Fetch Error: $e");
      return [];
    }
  }

  // Belirli bir alan üzerinden sorgulama
  Future<List<Map<String, dynamic>>> fetchFilteredData(
      String collectionPath, String field, dynamic value) async {
    try {
      final snapshot = await _firestore
          .collection(collectionPath)
          .where(field, isEqualTo: value)
          .get();
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      print("Firestore Filter Fetch Error: $e");
      return [];
    }
  }

  // Grup içindeki rutinleri çekme
  Future<List<Map<String, dynamic>>> fetchGroupRoutines(
      String groupName) async {
    try {
      final snapshot = await _firestore
          .collection('groupRoutines/$groupName/routines')
          .get();
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      print("Firestore Group Fetch Error: $e");
      return [];
    }
  }
}
