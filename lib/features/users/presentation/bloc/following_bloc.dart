import 'package:bloc/bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/users/domain/entities/user.dart';
import 'package:flutter_social/features/users/domain/usecases/get_following.dart';
import 'package:flutter_social/shared/domain/entities/api_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'following_event.dart';
part 'following_state.dart';
part 'following_bloc.freezed.dart';

class FollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  FollowingBloc() : super(const _Initial()) {
    on<FollowingEvent>((event, emit) async {
      if (event is _$_LoadInitialFollowingEvent) {
        emit(const FollowingState.loading());
        final result = await getIt<GetFollowing>().call(
          GetFollowingParam(username: event.username),
        );
        result.fold(
          (l) => emit(FollowingState.error(page: 1, failure: l)),
          (r) => emit(FollowingState.success(page: 1, data: r)),
        );
      } else if (event is _LoadMoreFollowingEvent) {
        emit(const FollowingState.loading());
        final result = await getIt<GetFollowing>().call(
          GetFollowingParam(
            page: event.page,
            perPage: event.perPage,
            username: event.username,
          ),
        );
        result.fold(
          (l) => emit(FollowingState.error(page: event.page, failure: l)),
          (r) => emit(FollowingState.success(page: event.page, data: r)),
        );
      } else if (event is _RefreshFollowingEvent) {
        emit(const FollowingState.refresh());
      }
    });
  }
}
