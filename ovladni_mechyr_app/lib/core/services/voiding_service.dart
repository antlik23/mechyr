import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uzis_app/core/constants/app_config.dart';
import 'package:uzis_app/core/models/exception_model.dart';
import 'package:uzis_app/features/auth/usecases/get_valid_token.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_diary_model.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_record_model.dart';

class VoidingService {
  final baseUrl = AppConfig.baseUrl;

  Future<VoidingDiary> fetchVoidingDiary(String diaryId) async {
    try {
      final token = await GetValidUserToken().execute();
      final response = await http.get(
        Uri.parse("$baseUrl/voiding_diaries/$diaryId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        VoidingDiary voidingDiary =
            VoidingDiary.fromJson(json.decode(response.body)["voiding_diary"]);

        return voidingDiary;
      } else {
        ExceptionModel exception =
            ExceptionModel.fromJson(json.decode(response.body));
        throw exception.error;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<VoidingDiary?> fetchLatestVoidingDiary() async {
    try {
      final token = await GetValidUserToken().execute();
      final response = await http.get(
        Uri.parse("$baseUrl/voiding_diaries/latest_diary"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        if (responseJson["voiding_diary"] == null) return null;

        VoidingDiary voidingDiary =
            VoidingDiary.fromJson(responseJson["voiding_diary"]);

        return voidingDiary;
      } else {
        ExceptionModel exception =
            ExceptionModel.fromJson(json.decode(response.body));
        throw exception.error;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<VoidingDiary> createVoidingDiary(Map<String, dynamic> body) async {
    try {
      final token = await GetValidUserToken().execute();
      final response = await http.post(
        Uri.parse("$baseUrl/voiding_diaries"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        VoidingDiary voidingDiary =
            VoidingDiary.fromJson(json.decode(response.body)["voiding_diary"]);

        return voidingDiary;
      } else {
        ExceptionModel exception =
            ExceptionModel.fromJson(json.decode(response.body));
        throw exception.error;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<VoidingDiary> updateVoidingDiary(
      int diaryId, Map<String, dynamic> body) async {
    try {
      final token = await GetValidUserToken().execute();
      final response = await http.put(
        Uri.parse("$baseUrl/voiding_diaries/$diaryId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        VoidingDiary voidingDiary =
            VoidingDiary.fromJson(json.decode(response.body)["voiding_diary"]);

        return voidingDiary;
      } else {
        ExceptionModel exception =
            ExceptionModel.fromJson(json.decode(response.body));
        throw exception.error;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<VoidingRecords> fetchVoidingRecords(String diaryId,
      [Map<String, dynamic>? params]) async {
    try {
      final token = await GetValidUserToken().execute();
      final response = await http.get(
        Uri.parse("$baseUrl/voiding_diaries/$diaryId/voiding_records").replace(
          queryParameters: params,
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        VoidingRecords voidingRecords =
            VoidingRecords.fromJson(json.decode(response.body));

        return voidingRecords;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<VoidingRecord> createVoidingRecord(
      String diaryId, Map<String, dynamic> body) async {
    try {
      final token = await GetValidUserToken().execute();
      final response = await http.post(
        Uri.parse("$baseUrl/voiding_diaries/$diaryId/voiding_records"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        VoidingRecord voidingRecord = VoidingRecord.fromJson(
            json.decode(response.body)["voiding_record"]);
        return voidingRecord;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<VoidingRecord> fetchVoidingRecord(
      String diaryId, String recordId) async {
    try {
      final token = await GetValidUserToken().execute();
      final response = await http.get(
        Uri.parse(
            "$baseUrl/voiding_diaries/$diaryId/voiding_records/$recordId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        VoidingRecord voidingRecord = VoidingRecord.fromJson(
            json.decode(response.body)["voiding_record"]);

        return voidingRecord;
      } else {
        ExceptionModel exception =
            ExceptionModel.fromJson(json.decode(response.body));
        throw exception.error;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<VoidingRecord> updateVoidingRecord(
      String diaryId, String recordId, Map<String, dynamic> body) async {
    try {
      final token = await GetValidUserToken().execute();
      final response = await http.put(
        Uri.parse(
            "$baseUrl/voiding_diaries/$diaryId/voiding_records/$recordId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({"voiding_record": body}),
      );

      if (response.statusCode == 200) {
        VoidingRecord voidingRecord = VoidingRecord.fromJson(
            json.decode(response.body)["voiding_record"]);
        return voidingRecord;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteVoidingRecord(String diaryId, String recordId) async {
    try {
      final token = await GetValidUserToken().execute();
      final response = await http.delete(
        Uri.parse(
            "$baseUrl/voiding_diaries/$diaryId/voiding_records/$recordId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
