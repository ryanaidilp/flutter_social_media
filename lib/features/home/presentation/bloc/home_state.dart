part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loadingPosts({
    @Default(1) int nextPage,
  }) = LoadingPost;
  const factory HomeState.loadingPostsFailed({
    required int page,
    required Failure failure,
  }) = LoadingPostFailed;

  const factory HomeState.loadingPostsSuccess({
    required int page,
    required GraphQLResponse<List<Post>> data,
  }) = LoadingPostsSuccess;

  const factory HomeState.update() = PostUpdated;
  const factory HomeState.refresh() = PostRefreshed;
}
