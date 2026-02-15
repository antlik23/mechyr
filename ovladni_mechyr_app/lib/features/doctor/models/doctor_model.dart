class DoctorModel {
  DoctorModel({
    required this.id,
    required this.fullName,
    required this.workplace,
    required this.contactEmail,
    required this.contactPhone,
    required this.city,
    required this.postalCode,
    required this.streetAndNumber,
    required this.workingHours,
    required this.web,
    required this.specialization,
    required this.isContactable,
    required this.contactStatus,
    this.latitude,
    this.longitude,
  });

  final int id;
  final String? fullName;
  final String? workplace;
  final String? contactEmail;
  final String? contactPhone;
  final String? city;
  final int? postalCode;
  final String? streetAndNumber;
  final String? workingHours;
  final String? web;
  final DoctorSpecialization specialization;
  final bool isContactable;
  final ContactStatus? contactStatus;
  final double? latitude;
  final double? longitude;

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
        id: json['id'],
        fullName: json['full_name'],
        workplace: json['workplace'],
        contactEmail: json['contact_email'],
        contactPhone: json['contact_phone'],
        city: json['city'],
        postalCode: json['postal_code'] is int
            ? json['postal_code']
            : (json['postal_code'] != null
                ? int.tryParse(json['postal_code'].toString())
                : null),
        streetAndNumber: json['street_and_number'],
        workingHours: json['working_hours'],
        web: json['web'],
        specialization: DoctorSpecializationExtension.fromApiString(
          json['specialization'] ?? 'general',
        ),
        isContactable: json['is_contactable'] ?? false,
        contactStatus: json['contact_status'] != null
            ? ContactStatusExtension.fromString(json['contact_status'])
            : null,
        latitude: json['latitude']?.toDouble(),
        longitude: json['longitude']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'workplace': workplace,
        'contact_email': contactEmail,
        'contact_phone': contactPhone,
        'city': city,
        'postal_code': postalCode,
        'street_and_number': streetAndNumber,
        'working_hours': workingHours,
        'web': web,
        'specialization': specialization.toApiString(),
        'is_contactable': isContactable,
        'contact_status': contactStatus?.toApiString(),
        'latitude': latitude,
        'longitude': longitude,
      };

  String get fullAddress {
    final parts = <String>[];
    if (streetAndNumber != null && streetAndNumber!.isNotEmpty) {
      parts.add(streetAndNumber!);
    }
    if (city != null && city!.isNotEmpty) {
      if (postalCode != null) {
        parts.add('$postalCode $city');
      } else {
        parts.add(city!);
      }
    }
    return parts.join(', ');
  }

  String get specializationLabel {
    switch (specialization) {
      case DoctorSpecialization.general:
        return 'Praktický lékař';
      case DoctorSpecialization.urologist:
        return 'Urolog';
      case DoctorSpecialization.gynecologist:
        return 'Gynekolog';
      case DoctorSpecialization.urogynecologist:
        return 'Urogynekolog';
    }
  }
}

enum DoctorSpecialization {
  general,
  urologist,
  gynecologist,
  urogynecologist,
}

extension DoctorSpecializationExtension on DoctorSpecialization {
  static DoctorSpecialization fromApiString(String value) {
    switch (value.toLowerCase()) {
      case 'general':
        return DoctorSpecialization.general;
      case 'urologist':
        return DoctorSpecialization.urologist;
      case 'gynecologist':
        return DoctorSpecialization.gynecologist;
      case 'urogynecologist':
        return DoctorSpecialization.urogynecologist;
      default:
        return DoctorSpecialization.general;
    }
  }

  static DoctorSpecialization fromApiInt(int value) {
    switch (value) {
      case 0:
        return DoctorSpecialization.general;
      case 1:
        return DoctorSpecialization.urologist;
      case 2:
        return DoctorSpecialization.gynecologist;
      case 3:
        return DoctorSpecialization.urogynecologist;
      default:
        return DoctorSpecialization.general;
    }
  }

  String toApiString() {
    switch (this) {
      case DoctorSpecialization.general:
        return 'general';
      case DoctorSpecialization.urologist:
        return 'urologist';
      case DoctorSpecialization.gynecologist:
        return 'gynecologist';
      case DoctorSpecialization.urogynecologist:
        return 'urogynecologist';
    }
  }

  int toApiInt() {
    switch (this) {
      case DoctorSpecialization.general:
        return 0;
      case DoctorSpecialization.urologist:
        return 1;
      case DoctorSpecialization.gynecologist:
        return 2;
      case DoctorSpecialization.urogynecologist:
        return 3;
    }
  }
}

enum ContactStatus {
  allowed,
  forbidden,
  contacted,
  approved,
  rejected,
}

extension ContactStatusExtension on ContactStatus {
  static ContactStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'allowed':
        return ContactStatus.allowed;
      case 'forbidden':
        return ContactStatus.forbidden;
      case 'contacted':
        return ContactStatus.contacted;
      case 'approved':
        return ContactStatus.approved;
      case 'rejected':
        return ContactStatus.rejected;
      default:
        return ContactStatus.forbidden;
    }
  }

  String toApiString() {
    switch (this) {
      case ContactStatus.allowed:
        return 'allowed';
      case ContactStatus.forbidden:
        return 'forbidden';
      case ContactStatus.contacted:
        return 'contacted';
      case ContactStatus.approved:
        return 'approved';
      case ContactStatus.rejected:
        return 'rejected';
    }
  }
}
