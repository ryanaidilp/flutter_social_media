import 'package:bloc/bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/users/domain/entities/user.dart';
import 'package:flutter_social/features/users/domain/usecases/get_followers.dart';
import 'package:flutter_social/shared/domain/entities/api_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'followers_event.dart';
part 'followers_state.dart';
part 'followers_bloc.freezed.dart';

class FollowersBloc extends Bloc<FollowersEvent, FollowersState> {
  FollowersBloc() : super(const _Initial()) {
    on<FollowersEvent>((event, emit) async {
      if (event is _$_LoadInitialFollowersEvent) {
        emit(const FollowersState.loading());
        final result = await getIt<GetFollowers>().call(
          GetFollowersParam(username: event.username),
        );
        result.fold(
          (l) => emit(FollowersState.error(page: 1, failure: l)),
          (r) => emit(FollowersState.success(page: 1, data: r)),
        );
      } else if (event is _LoadMoreFollowersEvent) {
        emit(const FollowersState.loading());
        final result = await getIt<GetFollowers>().call(
          GetFollowersParam(
            page: event.page,
            perPage: event.perPage,
            username: event.username,
          ),
        );
        result.fold(
          (l) => emit(FollowersState.error(page: event.page, failure: l)),
          (r) => emit(FollowersState.success(page: event.page, data: r)),
        );
      } else if(event is _RefreshFollowersEvent) {
        emit(const FollowersState.refresh());
      }
    });
  }
}
