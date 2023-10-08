part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.started() = _Started;
  const factory HomeEvent.loadInitialPost({

    required int perPage,
  }) = LoadInitialPostEvent;

   const factory HomeEvent.loadMorePosts({
    required int page,
    required int perPage,
  }) = LoadMorePostsEvent;

  const factory HomeEvent.update() = PostsUpdatedEvent;
  const factory HomeEvent.refresh() = PostsRefreshEvent;
}
