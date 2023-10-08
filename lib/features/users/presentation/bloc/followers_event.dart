part of 'followers_bloc.dart';

@freezed
class FollowersEvent with _$FollowersEvent {
  const factory FollowersEvent.started() = _Started;
  const factory FollowersEvent.loadInitialFollowers({
    required String username,
    @Default(10) int perPage,
  }) = _LoadInitialFollowersEvent;

  const factory FollowersEvent.loadMoreFollowers({
    required String username,
    @Default(1) int page,
    @Default(10) int perPage,
  }) = _LoadMoreFollowersEvent;

  const factory FollowersEvent.refresh() = _RefreshFollowersEvent;
}
