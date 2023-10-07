part of 'user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.started() = _Started;
  const factory UserEvent.loadUserData({
    @Default(1) int page,
    @Default(10) int limit,
  }) = _LoadUserData;
}
