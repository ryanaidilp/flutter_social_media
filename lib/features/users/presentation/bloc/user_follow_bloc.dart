import 'package:bloc/bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/users/domain/usecases/follow_user.dart';
import 'package:flutter_social/features/users/domain/usecases/unfollow_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_follow_event.dart';
part 'user_follow_state.dart';
part 'user_follow_bloc.freezed.dart';

class UserFollowBloc extends Bloc<UserFollowEvent, UserFollowState> {
  UserFollowBloc() : super(const _Initial()) {
    on<UserFollowEvent>((event, emit) async {
      if (event is _FollowEvent) {
        emit(const UserFollowState.following());
        final result = await getIt<FollowUser>().call(event.username);
        result.fold(
          (l) => emit(UserFollowState.followingFailed(failure: l)),
          (r) => emit(
            const UserFollowState.followingSuccess(),
          ),
        );
      } else if (event is _UnfollowEvent) {
        emit(const UserFollowState.unfollowing());
        final result = await getIt<UnfollowUser>().call(event.username);
        result.fold(
          (l) => emit(UserFollowState.unfollowingFailed(failure: l)),
          (r) => emit(
            const UserFollowState.unfollowingSuccess(),
          ),
        );
      }
    });
  }
}
