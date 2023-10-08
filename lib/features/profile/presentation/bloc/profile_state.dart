part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loadingPosts() = ProfilePostLoading;
  const factory ProfileState.loadingPostsFailed({
    required int page,
    required Failure failure,
  }) = ProfilePostFailed;
  const factory ProfileState.loadingPostsSuccess({
    required int page,
    required GraphQLResponse<List<Post>> data,
  }) = ProfilePostSuccess;


  const factory ProfileState.update() = ProfilePostUpdated;
  const factory ProfileState.refresh() = ProfilePostRefreshed;
}
