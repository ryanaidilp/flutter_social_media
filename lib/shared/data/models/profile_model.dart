import 'package:flutter_social/shared/domain/entities/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  factory ProfileModel({
    @JsonKey() required String id,
    @JsonKey() required String name,
    @JsonKey() required String email,
    @JsonKey() required String username,
    @JsonKey() String? photo,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.fromEntity(Profile profile) => ProfileModel(
        id: profile.id,
        name: profile.name,
        photo: profile.photo,
        email: profile.email,
        username: profile.username,
      );
}

extension ProfileModelX on ProfileModel {
  Profile toEntity() => Profile(
        id: id,
        name: name,
        email: email,
        username: username,
      );
}
