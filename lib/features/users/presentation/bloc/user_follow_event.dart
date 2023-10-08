part of 'user_follow_bloc.dart';

@freezed
class UserFollowEvent with _$UserFollowEvent {
  const factory UserFollowEvent.started() = _Started;
  const factory UserFollowEvent.follow({required String username}) =
      _FollowEvent;
  const factory UserFollowEvent.unfollow({required String username}) =
      _UnfollowEvent;
}
