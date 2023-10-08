part of 'user_detail_bloc.dart';

@freezed
class UserDetailEvent with _$UserDetailEvent {
  const factory UserDetailEvent.started() = _Started;

  const factory UserDetailEvent.loadProfile({
    required String username,
    @Default(10) int perPage,
  }) = _LoadProfile;

 
}
