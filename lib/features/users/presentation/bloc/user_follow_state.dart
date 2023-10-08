part of 'user_follow_bloc.dart';

@freezed
class UserFollowState with _$UserFollowState {
  const factory UserFollowState.initial() = _Initial;
  const factory UserFollowState.following() = FollowingFollowState;
  const factory UserFollowState.followingSuccess() = FollowingSuccess;
  const factory UserFollowState.followingFailed({required Failure failure}) =
      FollowingFailed;
  const factory UserFollowState.unfollowing() = UnfollowingFollowState;
  const factory UserFollowState.unfollowingSuccess() = UnfollowingSuccess;
  const factory UserFollowState.unfollowingFailed({required Failure failure}) =
      UnfollowingFailed;
}
