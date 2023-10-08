part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = _Started;

  const factory AuthEvent.register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) = _Register;

  const factory AuthEvent.login({
    required String password,
    required String identifier,
  }) = _Login;

  const factory AuthEvent.logout(String id) = _Logout;
}
