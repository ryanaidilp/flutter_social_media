part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.started() = _Started;
  const factory HomeEvent.loadInitialPost({

    required int perPage,
  }) = _LoadInitialPostEvent;

   const factory HomeEvent.loadMorePosts({
    required int page,
    required int perPage,
  }) = _LoadMorePostEvent;

  const factory HomeEvent.update() = _PostUpdatedEvent;
  const factory HomeEvent.refresh() = _PostRefreshEvent;
}
