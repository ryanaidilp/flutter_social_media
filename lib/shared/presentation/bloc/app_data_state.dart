part of 'app_data_bloc.dart';

@freezed
class AppDataState with _$AppDataState {
  const factory AppDataState.initial() = AppDataInitial;

  const factory AppDataState.loading() = AppDataLoading;

  const factory AppDataState.authenticated({
    @Default(true) bool isAuthenticated,
  }) = AppDataAuthenticated;

  const factory AppDataState.unauthenticated({
    @Default(false) bool isAuthenticated,
  }) = AppDataUnauthenticated;

  const factory AppDataState.profileLoaded({
    required Profile profile,
  }) = AppDataProfileLoaded;

  const factory AppDataState.tokenStored() = AppDataTokenStored;

  const factory AppDataState.tokenNotStored({
    required Failure failure,
  }) = AppDataTokenNotStored;

   const factory AppDataState.profileStored() = AppDataProfileStored;

  const factory AppDataState.profileNotStored({
    required Failure failure,
  }) = AppDataProfileNotStored;


  const factory AppDataState.tokenDeleted() = AppDataTokenDeleted;

  const factory AppDataState.tokenNotDeleted({
    required Failure failure,
  }) = AppDataTokenNotDeleted;

  const factory AppDataState.profileDeleted() = AppDataProfileDeleted;

  const factory AppDataState.profileNotDeleted({
    required Failure failure,
  }) = AppDataProfileNotDeleted;
}
