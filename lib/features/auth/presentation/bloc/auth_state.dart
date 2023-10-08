part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;

  const factory AuthState.loggingIn() = LoggingIn;
  const factory AuthState.loginFailed({required Failure failure}) = LoginFailed;
  const factory AuthState.loginSuccess({required String token}) = LoginSuccess;

  const factory AuthState.loggingOut() = LoggingOut;
  const factory AuthState.logoutFailed({required Failure failure}) =
      LogoutFailed;
  const factory AuthState.logoutSuccess() = LogoutSuccess;

  const factory AuthState.registering() = Registering;
  const factory AuthState.registerFailed({required Failure failure}) =
      RegisterFailed;
  const factory AuthState.registerSuccess() =
      RegisterSuccess;
}
