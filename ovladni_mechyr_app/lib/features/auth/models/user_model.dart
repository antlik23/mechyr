import 'dart:convert';

class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.anamnesticFormIds,
    required this.roles,
    this.patientPublicId,
  });

  int id;
  String email;
  List<int> anamnesticFormIds;
  List<UserRole> roles;
  String? patientPublicId;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"],
        anamnesticFormIds: List<int>.from(json["anamnestic_form_ids"] ?? []),
        roles: List<UserRole>.from(
            json["roles"]?.map((x) => UserRoleExtension.fromString(x)) ?? []),
        patientPublicId: json["patient_public_id"],
      );

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "anamnestic_form_ids": List<dynamic>.from(anamnesticFormIds),
        "roles":
            List<dynamic>.from(roles.map((x) => UserRoleExtension.toJson(x))),
        "patient_public_id": patientPublicId,
      };
}

enum UserRole {
  admin,
  patient,
  doctor,
}

extension UserRoleExtension on UserRole {
  static UserRole fromString(String userRole) {
    switch (userRole) {
      case 'admin':
        return UserRole.admin;
      case 'patient':
        return UserRole.patient;
      case 'doctor':
        return UserRole.doctor;
      default:
        throw Exception('Unknown user role string: $userRole');
    }
  }

  static String toJson(UserRole userRole) {
    switch (userRole) {
      case UserRole.admin:
        return 'admin';
      case UserRole.patient:
        return 'patient';
      case UserRole.doctor:
        return 'doctor';
    }
  }
}
