import 'package:focusflow/components/user_preferences.dart';
import 'package:focusflow/firebase_services/firebase_firestore_service.dart';

import 'routine_screen.dart';

class UserDatabase {
  static String activeEmail = "";
  static Routine lastSelectedRoutine = TempUserDB.getRoutines().isNotEmpty
      ? TempUserDB.getRoutines().first
      : Routine("", "", DateTime.now(), "", 0, 0, "", 0, 0, 0);

  static final Map<String, String> users = {};
  static Map<String, List<Routine>> userRoutines = {};
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

  // Rutin sil
  static void removeRoutine(String routineKey) {
    TempUserDB.removeRoutine(routineKey, activeEmail);
  }

  // Özel gruplarla çalışmak için mevcut yöntemler...
  static Map<String, List<Routine>> getCustomGroups() {
    return TempUserDB.getCustomGroups(activeEmail);
  }

  static void addCustomGroup(String groupName) {
    TempUserDB.addCustomGroup(groupName, activeEmail);
  }

  static void deleteCustomGroup(String groupName) {
    TempUserDB.removeCustomGroup(groupName, activeEmail);
  }

  static void addRoutineToCustomGroup(String groupName, Routine routine) {
    TempUserDB.addRoutineToGroup(groupName, routine, activeEmail);
  }

  static void removeRoutineFromCustomGroup(
      String groupName, String routineKey) {
    TempUserDB.removeRoutineFromGroup(groupName, routineKey, activeEmail);
  }
}

class TempUserDB {
  static List<Routine> routines = [];
  static Map<String, Map<String, List<Routine>>> customGroups = {};
  static final FirestoreService _firestoreService = FirestoreService();

  // Rutinleri geçici depoya ekle
  static void addRoutine(Routine routine, String email) {
    routines.add(routine);

    // Firestore'a ekle
    _firestoreService.addData(
      'users/$email/routines',
      routine.toJson(),
    );
  }

  // Rutinleri geçici depodan sil
  static void removeRoutine(String routineKey, String email) {
    routines.removeWhere((routine) => routine.key == routineKey);

    // Firestore'dan sil
    _firestoreService.deleteData('users/$email/routines', routineKey);
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

  // Grup ekle
  static void addCustomGroup(String groupName, String email) {
    if (!customGroups.containsKey(email)) {
      customGroups[email] = {};
    }
    if (!customGroups[email]!.containsKey(groupName)) {
      customGroups[email]![groupName] = [];
    }

    // Firestore'a grup bilgisi ekle
    _firestoreService.addData('users/$email/groups', {'groupName': groupName});
  }

  // Grup sil
  static void removeCustomGroup(String groupName, String email) {
    if (customGroups.containsKey(email)) {
      customGroups[email]!.remove(groupName);
    }

    // Firestore'dan grup sil
    //_firestoreService.deleteData('users/$email/groups', docId: groupName);
  }

  // Rutinleri bir gruba ekle
  static void addRoutineToGroup(
      String groupName, Routine routine, String email) {
    if (customGroups.containsKey(email)) {
      if (!customGroups[email]!.containsKey(groupName)) {
        addCustomGroup(groupName, email);
      }
      customGroups[email]![groupName]!.add(routine);
    }

    // Firestore'da gruba rutin ekle
    _firestoreService.addData(
      'users/$email/groupRoutines/$groupName',
      routine.toJson(),
    );
  }

  // Rutinleri bir gruptan çıkar
  static void removeRoutineFromGroup(
      String groupName, String routineKey, String email) {
    if (customGroups.containsKey(email)) {
      customGroups[email]![groupName]
          ?.removeWhere((routine) => routine.key == routineKey);
    }

    // Firestore'dan gruptaki rutini sil
    _firestoreService.deleteData(
        'users/$email/groupRoutines/$groupName', groupName);
  }

  // Firestore'dan grupları yükle
  static Future<void> loadGroupsFromFirestore(String email) async {
    final fetchedGroups =
        await _firestoreService.fetchData('users/$email/groups');
    final fetchedGroupRoutines =
        await _firestoreService.fetchData('users/$email/groupRoutines');

    customGroups[email] = {};
    for (var group in fetchedGroups) {
      final groupName = group['groupName'];
      customGroups[email]![groupName] = fetchedGroupRoutines
          .where((routine) => routine['groupName'] == groupName)
          .map((routineData) => Routine.fromJson(routineData))
          .toList();
    }
  }

  // Grupları al
  static Map<String, List<Routine>> getCustomGroups(String email) {
    if (customGroups.containsKey(email)) {
      return customGroups[email]!;
    }
    return {};
  }
}
