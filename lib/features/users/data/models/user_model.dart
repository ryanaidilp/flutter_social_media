import 'package:flutter_social/features/users/domain/entities/user.dart';
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
    @JsonKey(name: 'post_count') required int postCount,
    @JsonKey(name: 'following_count') required int followingCount,
    @JsonKey(name: 'followers_count') required int followersCount,
    @JsonKey() String? photo,
    @JsonKey() DateTime? followedAt,
  }) = _UserModel;
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  User toEntity() => User(
         id: id,
        name: name,
        email: email,
        photo: photo,
        username: username,
        postCount: postCount,
        followersCount: followersCount,
        followingCount: followingCount,
        followedAt: followedAt,
      );
}
