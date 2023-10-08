part of 'user_bloc.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading({
    @Default(1) int nextPage,
  }) = UserLoading;
  const factory UserState.loaded({
    required int page,
    required ApiResponse<List<User>> data,
  }) = UserLoaded;
  const factory UserState.error({
    required int page,
    required Failure failure,
  }) = UserError;

  const factory UserState.update() = UserListUpdated;
  const factory UserState.refresh() = UserListRefreshed;
}
