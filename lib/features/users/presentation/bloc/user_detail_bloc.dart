import 'package:bloc/bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/users/domain/entities/user.dart';
import 'package:flutter_social/features/users/domain/usecases/get_user_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'user_detail_event.dart';
part 'user_detail_state.dart';
part 'user_detail_bloc.freezed.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  UserDetailBloc() : super(const _Initial()) {
    on<UserDetailEvent>((event, emit) async {
      if (event is _LoadProfile) {
        emit(const UserDetailState.loading());
        final result = await getIt<GetUserDetail>().call(
          GetUserDetailParam(username: event.username),
        );

        result.fold(
          (l) => emit(UserDetailState.error(failure: l)),
          (r) => emit(UserDetailState.success(user: r)),
        );
      }
    });
  }
}
