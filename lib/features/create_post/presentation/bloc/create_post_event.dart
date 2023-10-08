part of 'create_post_bloc.dart';

@freezed
class CreatePostEvent with _$CreatePostEvent {
  const factory CreatePostEvent.started() = _Started;
  const factory CreatePostEvent.create({
    required String userID,
    required String description,
    required File image,
  }) = _Create;
}
