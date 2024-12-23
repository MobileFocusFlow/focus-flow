import 'package:flutter/material.dart';
import '../temp_user_db.dart';

class TextsInApp {
  static Map<String, Map<String, String>> texts = {
    'en': {
      "ok": "OK",
      "at": "at",
      "add": "Add",
      "save": "Save",
      "cancel": "Cancel",
      "delete": "Delete",
      "work_dur": "Work Duration (min.)",
      "break_dur": "Break Duration (min.)",
      "block_dur": "Block Duration (min.)",
      "start": "Start",
      "pause": "Pause",
      "reset": "Reset",
      "work": "Work",
      "break": "Break",
      "routines": "Routines",
      "add_group": "Add Group",
      "working_technique": "Working Technique",
      "scheduled": "Scheduled",
      "edit_routine": "Edit Routine",
      'home_page_welcome': 'Welcome to Focus Flow',
      'home_page_goto_routine_screen': 'Go To Routine Screen',
      'home_page_settings': 'Settings',
      'routine_screen_my_routines': "My Routines",
      "routine_screen_working_techniques": "Working Techniques",
      "routine_screen_task_handling": "Task/Routine Handling",
      "routine_screen_home": "Home",
      "routine_screen_calendar": "Calendar",
      "routine_screen_alerts": "Alerts",
      "routine_screen_profile": "Profile",
      "routine_screen_create_routine_for": "Technique: ",
      "routine_list_routines": "Current Routines",
      "routine_list_delete_routine": "Delete Routine",
      "routine_list_delete_routine_confirm":
          'Are you sure you want to delete this routine?',
      "routine_c_form_routine_title": "Routine Title",
      "routine_c_form_hint_routine_title": 'Enter your routine title',
      "routine_c_form_set_reminder": "Set Reminder",
      "routine_c_form_reminder": "Reminder:",
      "routine_c_form_add_routine": "Add Routine",
      "routine_details_routine_details": "Routine Details",
      "action_button_unsuported_technique": "Unsupported Technique",
      "action_button_start_pomodoro": "Start Pomodoro Session",
      "action_button_start_time_b": "Start Time Blocking Session",
      "action_button_start_zen": "Start Zen Session",
      "action_button_isnt_supported": "is not supported yet.",
      "edit_dialog_reminder_date_and_time": "Reminder Date and Time",
      "routine_header_scheduled_for": "Scheduled for",
      "calendar_routine_calendar": 'Routine Calendar',
      "calendar_no_routines_for_the_day": 'No tasks for this day.',
      "task_batching_add_custom_group": "Add Custom Group",
      "task_batching_hint_group_name": "Enter group name",
      "task_batching_add_to_custom_group": "Add to Custom Group",
      "task_batching_no_custom_group_available": "No custom groups available.",
      "time_block_complete": "Time Block Complete!",
      "time_block_complete_message":
          "You've successfully completed this time block.",
      "pomodoro_complete": "Pomodoro Complete!",
      "pomodoro_complete_message":
          "You've successfully completed this pomodoro.",
      "post_it_hint_text": 'Write something...',
      "post_it_saved": "Notes Saved"
    },
    'tr': {
      "ok": "Tamam",
      "at": "Saat",
      "add": "Ekle",
      "save": "Kaydet",
      "cancel": "İptal",
      "delete": "Sil",
      "work_dur": "Çalışma Süresi (dak.)",
      "break_dur": "Mola Süresi (dak.)",
      "block_dur": "Blok Süresi (dak.)",
      "start": "Başla",
      "pause": "Durdur",
      "reset": "Sıfırla",
      "work": "Çalış",
      "break": "Mola",
      "routines": "Rutinler",
      "add_group": "Grup Ekle",
      "working_technique": "Çalışma Tekniği",
      "scheduled": "Planlanmış",
      "edit_routine": "Rutini Düzenle",
      'home_page_welcome': 'Focus Flow\'a Hoşgeldiniz',
      'home_page_goto_routine_screen': 'Rutin Ekranına Git',
      'home_page_settings': 'Ayarlar',
      'routine_screen_my_routines': "Rutinlerim",
      "routine_screen_working_techniques": "Çalışma Teknikleri",
      "routine_screen_task_handling": "Görev/Rutin Yönetimi",
      "routine_screen_home": "Ana Sayfa",
      "routine_screen_calendar": "Takvim",
      "routine_screen_alerts": "Alarmlar",
      "routine_screen_profile": "Profil",
      "routine_screen_create_routine_for": "Teknik: ",
      "routine_list_routines": "Mevcut Rutinler",
      "routine_list_delete_routine": "Rutini Sil",
      "routine_list_delete_routine_confirm":
          'Bu rutini silmek istediğinizden emin misiniz?',
      "routine_c_form_routine_title": "Rutin Başlığı",
      "routine_c_form_hint_routine_title": "Rutin başlığınızı yazın",
      "routine_c_form_set_reminder": "Hatırlatıcı Ekle",
      "routine_c_form_reminder": "Hatırlatıcı:",
      "routine_c_form_add_routine": "Rutin Ekle",
      "routine_details_routine_details": "Rutin Detayları",
      "action_button_unsuported_technique": "Desteklenmeyen Teknik",
      "action_button_start_pomodoro": "Pomodoro Oturumuna Başla",
      "action_button_start_time_b": "Time Blocking Oturumuna Başla",
      "action_button_start_zen": "Zen Oturumuna Başla",
      "action_button_isnt_supported": "henüz desteklenmiyor.",
      "edit_dialog_reminder_date_and_time": "Hatırlatıcı Tarihi ve Zamanı",
      "routine_header_scheduled_for": "Planladı: ",
      "calendar_routine_calendar": 'Rutin Takvimi',
      "calendar_no_routines_for_the_day": 'Bugün için rutin yok.',
      "task_batching_add_custom_group": "Özel Grup Ekle",
      "task_batching_hint_group_name": "Grup adını girin",
      "task_batching_add_to_custom_group": "Özel Gruba Ekle",
      "task_batching_no_custom_group_available": "Uygun özel grup bulunumadı.",
      "time_block_complete": "Time Block Tamamlandı!",
      "time_block_complete_message": "Bu zaman bloğunu başarıyla tamamladın.",
      "pomodoro_complete": "Pomodoro Tamamlandı!",
      "pomodoro_complete_message": "Bu Pomodoroyu başarıyla tamamladın.",
      "post_it_hint_text": 'Bir şeyler yaz...',
      "post_it_saved": "Notlar Kaydedildi",
    },
  };

  static String getSelectedLanguage() {
    return UserDatabase
            .userPrefs[UserDatabase.activeEmail]?.selectedLanguauge ??
        'English';
  }

  static void setSelectedLanguage(String language) {
    UserDatabase.userPrefs[UserDatabase.activeEmail]?.selectedLanguauge =
        language;
  }

  static String getText(String key) {
    String languageCode = getLanguageCode();
    return texts[languageCode]?[key] ?? key;
  }

  static String getLanguageCode() {
    switch (getSelectedLanguage()) {
      case 'English':
        return 'en';
      case 'Türkçe':
        return 'tr';
      default:
        return 'en';
    }
  }
}

class LanguageSelectionWidget extends StatefulWidget {
  const LanguageSelectionWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LanguageSelectionWidgetState createState() =>
      _LanguageSelectionWidgetState();
}

class _LanguageSelectionWidgetState extends State<LanguageSelectionWidget> {
  final List<String> _languages = ['English', 'Türkçe'];
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  _loadLanguage() {
    setState(() {
      _selectedLanguage =
          UserDatabase.userPrefs[UserDatabase.activeEmail]?.selectedLanguauge ??
              'English';
    });
  }

  _saveLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
      UserDatabase.userPrefs[UserDatabase.activeEmail]!.selectedLanguauge =
          language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Select Language:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: DropdownButton<String>(
        value: _selectedLanguage,
        onChanged: (String? newLanguage) {
          if (newLanguage != null) {
            _saveLanguage(newLanguage);
          }
        },
        items: _languages.map<DropdownMenuItem<String>>((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(language),
          );
        }).toList(),
      ),
    );
  }
}
