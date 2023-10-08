part of 'user_detail_bloc.dart';

@freezed
class UserDetailState with _$UserDetailState {
  const factory UserDetailState.initial() = _Initial;
  const factory UserDetailState.loading() = UserDetailLoading;
  const factory UserDetailState.success({required User user}) =
      UserDetailLoaded;
  const factory UserDetailState.error({required Failure failure}) =
      UserDetailNotLoaded;
  
}
