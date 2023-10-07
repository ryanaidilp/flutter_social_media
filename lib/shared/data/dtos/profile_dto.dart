import 'package:flutter_social/core/constants/json_constant.dart';

class ProfileDto {

  ProfileDto({
    required this.id,
    required this.name,
    required this.isEmailVerified, required this.isPhoneVerified, required this.gender, this.avatar,
    this.phoneNumber,
    this.dateOfBirth,
    this.suspendedUntil,
    this.updatedAt,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    final attributes = json[JsonConstant.attributes] as Map<String, dynamic>;
    return ProfileDto(
      id: json[JsonConstant.id] as String,
      name: attributes['name'] as String,
      avatar: attributes['avatar'] as String?,
      isEmailVerified: attributes['is_email_verified'] as bool,
      isPhoneVerified: attributes['is_phone_verified'] as bool,
      gender: attributes['gender'] as String,
      phoneNumber: attributes['phone_number'] as String?,
      dateOfBirth: attributes['date_of_birth'] as String?,
      suspendedUntil: attributes['suspended_until'] as String?,
      updatedAt: attributes['updated_at'] as String?,
    );
  }
  final String id;
  final String name;
  final String? avatar;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String gender;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? suspendedUntil;
  final String? updatedAt;
}
