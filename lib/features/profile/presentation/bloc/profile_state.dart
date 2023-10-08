part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loadingPosts() = LoadingPosts;
  const factory ProfileState.loadingPostsFailed({
    required Failure failure,
  }) = LoadingPostsFailed;
  const factory ProfileState.loadingPostsSuccess({
    required GraphQLResponse<List<Post>> data,
  }) = LoadingPostsSuccess;
  const factory ProfileState.loadingMorePosts() = LoadingMorePosts;
  const factory ProfileState.loadingMorePostsFailed({
    required Failure failure,
  }) = LoadingMorePostsFailed;
  const factory ProfileState.loadingMorePostsSuccess({
    required GraphQLResponse<List<Post>> data,
  }) = LoadingMorePostsSuccess;
}
