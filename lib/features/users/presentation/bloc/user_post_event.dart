part of 'user_post_bloc.dart';

@freezed
class UserPostEvent with _$UserPostEvent {
  const factory UserPostEvent.started() = _Started;

  const factory UserPostEvent.loadInitialPosts({
    required String username,
    @Default(10) int perPage,
  }) = _LoadInitialPosts;

  const factory UserPostEvent.loadMorePosts({
    required String username,
    @Default(10) int perPage,
    @Default(1) int page,
  }) = _LoadMorePosts;

  const factory UserPostEvent.update() = _PostsUpdatedEvent;
  const factory UserPostEvent.refresh() = _PostsRefreshEvent;
}
