import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uzis_app/core/constants/app_config.dart';
import 'package:uzis_app/core/models/exception_model.dart';
import 'package:uzis_app/features/auth/usecases/get_valid_token.dart';
import 'package:uzis_app/features/doctor/models/doctor_model.dart';

class DoctorService {
  final baseUrl = AppConfig.baseUrl;

  Future<List<DoctorModel>> fetchAvailableDoctors({
    String? fullName,
    String? city,
    int page = 1,
    int itemsPerPage = 20,
  }) async {
    try {
      final token = await GetValidUserToken().execute();

      final queryParams = <String, String>{
        'page_param': page.toString(),
        'items_per_page': itemsPerPage.toString(),
      };

      if (fullName != null && fullName.isNotEmpty) {
        queryParams['full_name'] = fullName;
      }

      if (city != null && city.isNotEmpty) {
        queryParams['city'] = city;
      }

      final uri = Uri.parse(
        "$baseUrl/doctors/available_doctors",
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        final doctorsJson = responseJson['doctors'] as List<dynamic>?;

        if (doctorsJson == null) {
          return [];
        }

        final doctors = doctorsJson
            .map((json) => DoctorModel.fromJson(json))
            .toList();
        return doctors;
      } else {
        ExceptionModel exception = ExceptionModel.fromJson(
          json.decode(response.body),
        );
        throw exception.error;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DoctorModel> fetchDoctorDetail(int doctorId) async {
    try {
      final token = await GetValidUserToken().execute();
      final uri = Uri.parse("$baseUrl/doctors/$doctorId");

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        final doctor = DoctorModel.fromJson(responseJson['doctor']);
        return doctor;
      } else {
        ExceptionModel exception = ExceptionModel.fromJson(
          json.decode(response.body),
        );
        throw exception.error;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> requestAssignment({
    required int doctorId,
    required String message,
    required bool agreedToShareInfo,
    String? phoneNumber,
    String? preferredContact,
  }) async {
    try {
      final token = await GetValidUserToken().execute();

      final requestBody = {
        'patient': {
          'doctor_id': doctorId,
          'agreed_to_share_info': agreedToShareInfo,
        },
        'email': {
          'custom_message': message,
          if (phoneNumber != null) 'phone_number': phoneNumber,
          if (preferredContact != null) 'preferred_contact': preferredContact,
        },
      };

      final response = await http.put(
        Uri.parse("$baseUrl/patients/request_assignment"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 204) {
        return;
      }

      if (response.statusCode == 200) {
        return;
      }

      ExceptionModel exception = ExceptionModel.fromJson(
        json.decode(response.body),
      );
      throw exception.error;
    } catch (e) {
      rethrow;
    }
  }

  Future<ContactStatus?> checkAssignmentStatus() async {
    try {
      final token = await GetValidUserToken().execute();
      final response = await http.get(
        Uri.parse("$baseUrl/patients/current"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        final statusString = responseJson['patient']?['contact_status'];

        if (statusString != null) {
          return ContactStatusExtension.fromString(statusString);
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
