class UserDatabase {
  static final Map<String, String> _users = {};

  static bool register(String email, String password) {
    if (_users.containsKey(email)) {
      return false;
    }
    _users[email] = password;
    return true;
  }

  static bool login(String email, String password) {
    return _users[email] == password;
  }
}
 
 //email
 //password
 //user_name
 //routines-> routine_title,
 //           routine_technique,
 //           routine_durations,
 //           routine_reminder
 //           routine_tecnique_count
 