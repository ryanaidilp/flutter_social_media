part of 'user_post_bloc.dart';

@freezed
class UserPostState with _$UserPostState {
  const factory UserPostState.initial() = _Initial;
  const factory UserPostState.loading() = UserPostLoading;
  const factory UserPostState.success({
    required int page,
    required GraphQLResponse<List<Post>> posts,
  }) = UserPostLoaded;
  const factory UserPostState.error({
    required int page,
    required Failure failure,
  }) = UserPostNotLoaded;

  const factory UserPostState.update() = UserPostUpdated;
  const factory UserPostState.refresh() = UserPostRefreshed;
}
