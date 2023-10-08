part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loadingPosts({
    @Default(1) int nextPage,
  }) = HomePostLoading;
  const factory HomeState.loadingPostsFailed({
    required int page,
    required Failure failure,
  }) = HomePostFailed;

  const factory HomeState.loadingPostsSuccess({
    required int page,
    required GraphQLResponse<List<Post>> data,
  }) = HomePostSuccess;

  const factory HomeState.update() = HomePostUpdated;
  const factory HomeState.refresh() = HomePostRefreshed;
}
