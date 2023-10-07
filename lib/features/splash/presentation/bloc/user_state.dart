part of 'user_bloc.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = UserLoading;
  const factory UserState.loaded({required List<User> data}) = UserLoaded;
  const factory UserState.error({required Failure failure}) = UserError;
}
