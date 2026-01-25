import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/core/services/voiding_service.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_record_model.dart';

class PendingVoidingRecordsRepository {
  PendingVoidingRecordsRepository(
    this.prefs,
  );

  final SharedPreferences prefs;

  Future<List<VoidingRecord>> getPendingVoidingRecordsData() async {
    final pendingRecordsData = prefs.getString('pending_voiding_records');
    if (pendingRecordsData == null) return [];

    return List<VoidingRecord>.from(
      jsonDecode(pendingRecordsData).map((x) => VoidingRecord.fromJson(x)),
    );
  }

  Future<void> savePendingRecordsData(
      List<VoidingRecord> pendingRecords) async {
    await prefs.setString("pending_voiding_records",
        json.encode(pendingRecords.map((e) => e.toJson()).toList()));
  }

  Future<void> addPendingRecord(VoidingRecord newRecord) async {
    final records = await getPendingVoidingRecordsData();
    records.add(newRecord);
    await savePendingRecordsData(records);
  }

  Future<void> removePendingRecord(int recordId) async {
    final records = await getPendingVoidingRecordsData();
    records.removeWhere((record) => record.id == recordId);
    await savePendingRecordsData(records);
  }

  Future<void> clearData() async {
    await prefs.remove('pending_voiding_records');
  }

  Future<void> sendRecordById(int recordId, String diaryId) async {
    final records = await getPendingVoidingRecordsData();

    final record = records.firstWhere((r) => r.id == recordId);

    final recordJson = record.toJson();
    recordJson.remove("id");
    recordJson.remove("record_type");

    try {
      await VoidingService().createVoidingRecord(diaryId, record.toJson());

      await removePendingRecord(recordId);
    } catch (e) {
      rethrow;
    }
  }
}
