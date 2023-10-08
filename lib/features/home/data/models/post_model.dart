import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/features/splash/data/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  factory PostModel({
    @JsonKey() required String id,
    @JsonKey() required String image,
    @JsonKey() required String description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey() required UserModel user,
  }) = _PostModel;
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

extension PostModelX on PostModel {
  Post toEntity() => Post(
        id: id,
        image: image,
        description: description,
        createdAt: createdAt,
        user: user.toEntity(),
      );
}
