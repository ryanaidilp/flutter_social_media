part of 'following_bloc.dart';

@freezed
class FollowingState with _$FollowingState {
  const factory FollowingState.initial() = _Initial;
  const factory FollowingState.loading() = FollowingLoading;
  const factory FollowingState.error({
    required int page,
    required Failure failure,
  }) = FollowingError;
  const factory FollowingState.success({
    required int page,
    required ApiResponse<List<User>> data,
  }) = FollowingLoaded;
  const factory FollowingState.refresh() = FollowingRefreshed;
}
