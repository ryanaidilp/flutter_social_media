import 'package:bloc/bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/auth/domain/usecases/login.dart';
import 'package:flutter_social/features/auth/domain/usecases/logout.dart';
import 'package:flutter_social/features/auth/domain/usecases/register.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@LazySingleton()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const _Initial()) {
    on<AuthEvent>((event, emit) async {
      if (event is _Login) {
        emit(const AuthState.loggingIn());
        final result = await login(
          LoginParam(
            identifier: event.identifier,
            password: event.password,
          ),
        );

        result.fold(
          (l) => emit(AuthState.loginFailed(failure: l)),
          (r) => emit(
            AuthState.loginSuccess(token: r),
          ),
        );
      } else if (event is _Logout) {
        emit(const AuthState.loggingOut());
        final result = await logout(event.id);
        result.fold(
          (l) => emit(AuthState.logoutFailed(failure: l)),
          (r) => r
              ? emit(
                  const AuthState.logoutSuccess(),
                )
              : emit(
                  AuthState.logoutFailed(
                    failure: ClientFailure(),
                  ),
                ),
        );
      } else if (event is _Register) {
        emit(const AuthState.registering());
        final result = await register(
          RegisterParam(
            name: event.name,
            email: event.email,
            password: event.password,
            username: event.username,
          ),
        );
        result.fold(
          (l) => emit(AuthState.registerFailed(failure: l)),
          (r) => r
              ? emit(
                  const AuthState.registerSuccess(),
                )
              : emit(
                  AuthState.registerFailed(
                    failure: ClientFailure(),
                  ),
                ),
        );
      }
    });
  }

  final login = getIt<Login>();
  final logout = getIt<Logout>();
  final register = getIt<Register>();
}
