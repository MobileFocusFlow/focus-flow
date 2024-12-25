import 'package:focusflow/components/user_preferences.dart';

import 'routine_screen.dart';

class UserDatabase {
  static String activeEmail = "";
  static String emailIdentifier = "email";
  static String passwordIdentifier = "password";
  static String titleIdentifier = "title";
  static String reminderDateIdentifier = "reminderDate";
  static String workingTechniqueIdentifier = "workingTechnique";
  static String workingDurationIdentifier = "workingDuration";
  static String breakDurationIdentifier = "breakDuration";
  static Routine lastSelectedRoutine = getRoutines().first;

  static final Map<String, String> users = {};
  static Map<String, List<Routine>> userRoutines = {};
  static Map<String, UserPreferences> userPrefs = {};

  static Map<String, Map<String, List<Routine>>> customGroups = {};

  static List<Routine> getRoutines() {
    if (userRoutines.containsKey(activeEmail)) {
      return userRoutines[activeEmail]?.toList() ?? [];
    }
    return [];
  }

  static void addRoutine(Routine newRoutine) {
    if (userRoutines.containsKey(activeEmail)) {
      userRoutines[activeEmail]!.add(newRoutine);
    } else {
      userRoutines[activeEmail] = [newRoutine];
    }
  }

  static void removeRoutine(String routineKey) {
    if (userRoutines.containsKey(activeEmail)) {
      userRoutines[activeEmail]
          ?.removeWhere((routine) => routine.key == routineKey);
    }

    if (customGroups.containsKey(activeEmail)) {
      for (var group in customGroups[activeEmail]!.values) {
        group.removeWhere((routine) => routine.key == routineKey);
      }
    }
  }

  static Map<String, List<Routine>> getCustomGroups() {
    if (customGroups.containsKey(activeEmail)) {
      return customGroups[activeEmail]!;
    }
    return {};
  }

  static Map<String, List<Routine>> getCustomGroupsWithoutEisenhower() {
    if (customGroups.containsKey(activeEmail)) {
      Map<String, List<Routine>> filteredGroups = {};

      customGroups[activeEmail]!.forEach((key, value) {
        if ((!key.toLowerCase().contains("important") &&
                !key.toLowerCase().contains("urgent")) ||
            (!key.toLowerCase().contains("önemli") &&
                !key.toLowerCase().contains("acil"))) {
          filteredGroups[key] = value;
        }
      });

      return filteredGroups;
    }
    return {};
  }

  static void addCustomGroup(String groupName) {
    if (!customGroups.containsKey(activeEmail)) {
      customGroups[activeEmail] = {};
    }
    if (!customGroups[activeEmail]!.containsKey(groupName)) {
      customGroups[activeEmail]![groupName] = [];
    }
  }

  static void deleteCustomGroup(String groupName) {
    if (customGroups.containsKey(activeEmail)) {
      customGroups[activeEmail]!.remove(groupName);
    }
  }

  static void addRoutineToCustomGroup(String groupName, Routine routine) {
    if (customGroups.containsKey(activeEmail)) {
      if (customGroups[activeEmail]!.containsKey(groupName)) {
        customGroups[activeEmail]![groupName]!.add(routine);
      }
    }
  }

  static void removeRoutineFromCustomGroup(
      String groupName, String routineKey) {
    if (customGroups.containsKey(activeEmail)) {
      customGroups[activeEmail]![groupName]
          ?.removeWhere((routine) => routine.key == routineKey);
    }
  }

  static bool register(String email, String password) {
    if (users.containsKey(email)) {
      return false;
    }
    users[email] = password;
    userPrefs[email] = UserPreferences("English", 16, false);
    return true;
  }

  static bool login(String email, String password) {
    if (users[email] == password) {
      activeEmail = email;
    }
    return users[email] == password;
  }
}
