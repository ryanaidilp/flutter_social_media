import 'package:flutter_social/features/splash/domain/entities/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  factory UserModel({
    @JsonKey() required String id,
    @JsonKey() required String name,
    @JsonKey() required String username,
    @JsonKey() required String email,
    @JsonKey() String? photo,
  }) = _UserModel;
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  User toEntity() => User(
        id: id,
        name: name,
        username: username,
        email: email,
      );
}
