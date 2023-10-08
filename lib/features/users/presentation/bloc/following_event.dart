part of 'following_bloc.dart';

@freezed
class FollowingEvent with _$FollowingEvent {
  const factory FollowingEvent.started() = _Started;
  const factory FollowingEvent.loadInitialFollowing({
    required String username,
    @Default(10) int perPage,
  }) = _LoadInitialFollowingEvent;

  const factory FollowingEvent.loadMoreFollowing({
    required String username,
    @Default(1) int page,
    @Default(10) int perPage,
  }) = _LoadMoreFollowingEvent;

  const factory FollowingEvent.refresh() = _RefreshFollowingEvent;
}
