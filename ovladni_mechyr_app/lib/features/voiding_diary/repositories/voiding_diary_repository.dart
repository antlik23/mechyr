import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_diary_model.dart';

class VoidingDiaryRepository {
  VoidingDiaryRepository(
    this.prefs,
  );

  final SharedPreferences prefs;

  Future<VoidingDiary?> getVoidingDiaryData() async {
    final diaryData = prefs.getString('voiding_diary');
    if (diaryData == null) return null;

    return VoidingDiary.fromRawJson(diaryData);
  }

  Future<void> saveVoidingDiaryData(VoidingDiary diaryData) async {
    await prefs.setString('voiding_diary', json.encode(diaryData.toJson()));
  }
}
