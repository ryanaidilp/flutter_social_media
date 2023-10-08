part of 'user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.started() = _Started;
  const factory UserEvent.loadInitialUsers({
    @Default(10) int perPage,
  }) = _LoadInitialUsersEvent;

  const factory UserEvent.loadMoreUsers({
    @Default(1) int page,
    @Default(10) int limit,
  }) = _LoadMoreUserEvent;

  const factory UserEvent.update() = _UsersUpdatedEvent;
  const factory UserEvent.refresh() = _UsersRefreshEvent;
}
