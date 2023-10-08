part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = _Started;
  const factory ProfileEvent.loadInitialPosts({@Default(10) int perPage}) =
      LoadInitialPosts;
  const factory ProfileEvent.loadMorePosts({
    @Default(10) int perPage,
    @Default(1) int page,
  }) = LoadMorePosts;
}
