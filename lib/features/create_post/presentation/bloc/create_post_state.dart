part of 'create_post_bloc.dart';

@freezed
class CreatePostState with _$CreatePostState {
  const factory CreatePostState.initial() = _Initial;
  const factory CreatePostState.creating() = UploadingPost;
  const factory CreatePostState.success({required Post post}) = PostCreated;
  const factory CreatePostState.failed({required Failure failure}) =
      PostNotCreated;
}
