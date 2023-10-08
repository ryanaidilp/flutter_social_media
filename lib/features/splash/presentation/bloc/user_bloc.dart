import 'package:bloc/bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/users/domain/entities/user.dart';
import 'package:flutter_social/features/users/domain/usecases/get_all_users.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

@LazySingleton()
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const _Initial()) {
    on<UserEvent>(
      (event, emit) async {
        if (event is _LoadUserData) {
          emit(const UserState.loading());
          final usecase = getIt<GetAllUsers>();
          final result = await usecase.call(
            GetAllUsersParam(
              page: event.page,
              perPage: event.limit,
            ),
          );

          result.fold(
            (l) => emit(UserState.error(failure: l)),
            (r) => emit(UserState.loaded(data: r)),
          );
        }
      },
    );
  }
}
