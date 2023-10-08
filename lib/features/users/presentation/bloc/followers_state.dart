part of 'followers_bloc.dart';

@freezed
class FollowersState with _$FollowersState {
  const factory FollowersState.initial() = _Initial;
  const factory FollowersState.loading() = FollowersLoading;
  const factory FollowersState.error({
    required int page,
    required Failure failure,
  }) = FollowersError;
  const factory FollowersState.success({
    required int page,
    required ApiResponse<List<User>> data,
  }) = FollowersLoaded;
  const factory FollowersState.refresh() = FollowersRefreshed;
}
