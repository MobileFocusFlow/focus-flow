import 'package:focusflow/components/user_preferences.dart';
import 'package:focusflow/firebase_services/firebase_firestore_service.dart';

import 'routine_screen.dart';

class UserDatabase {
  static String activeEmail = "";
  static Routine lastSelectedRoutine = TempUserDB.getRoutines().isNotEmpty
      ? TempUserDB.getRoutines().first
      : Routine("", "", DateTime.now(), "", 0, 0, "", 0, 0, 0, "");

  static Map<String, UserPreferences> userPrefs = {};

  // Rutinleri Firestore üzerinden yükle ve TempUserDB'yi güncelle
  static Future<void> loadRoutines() async {
    await TempUserDB.loadRoutinesFromFirestore(activeEmail);
  }

  // TempUserDB'den rutinleri getir
  static List<Routine> getRoutines() {
    return TempUserDB.getRoutines();
  }

  // Yeni rutin ekle
  static void addRoutine(Routine newRoutine) {
    TempUserDB.addRoutine(newRoutine, activeEmail);
  }

  //PostitNote güncelleme
  static void updateValue(Routine updatedRoutine) {
    TempUserDB.updateValue(updatedRoutine, activeEmail);
  }

  // Rutin sil
  static void removeRoutine(String routineKey) {
    TempUserDB.removeRoutine(routineKey, activeEmail);
  }
}

class TempUserDB {
  static List<Routine> routines = [];
  static final FirestoreService _firestoreService = FirestoreService();

  // Rutinleri geçici depoya ekle
  static void addRoutine(Routine routine, String email) {
    // Firestore'a ekle
    _firestoreService.addData(
      'users/$email/routines',
      routine.toJson(),
    );
  }

  static void updateValue(Routine updatedRoutine, String email) async {
    // Yerel veriyi güncelle
    final index =
        routines.indexWhere((routine) => routine.key == updatedRoutine.key);
    if (index != -1) {
      routines[index] = updatedRoutine;
    }

    // Firestore'daki veriyi güncelle
    await _firestoreService.updateRoutineByKey(
      'users/$email/routines',
      updatedRoutine.key,
      updatedRoutine.toJson(),
    );
  }

  // Rutinleri geçici depodan sil
  static void removeRoutine(String routineKey, String email) {
    routines.removeWhere((routine) => routine.key == routineKey);

    // Firestore'dan sil
    _firestoreService.deleteRoutineByKey('users/$email/routines', routineKey);
  }

  // Firestore'dan rutinleri çek ve geçici depoya yükle
  static Future<void> loadRoutinesFromFirestore(String email) async {
    final fetchedData =
        await _firestoreService.fetchData('users/$email/routines');
    routines = fetchedData.map((data) => Routine.fromJson(data)).toList();
  }

  // Tüm rutinleri al
  static List<Routine> getRoutines() {
    return routines;
  }
}
