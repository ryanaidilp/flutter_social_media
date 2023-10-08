part of 'app_data_bloc.dart';

@freezed
class AppDataEvent with _$AppDataEvent {
  const factory AppDataEvent.started() = _Started;
  const factory AppDataEvent.checkIfAuthenticated() =
      _CheckIfAuthenticatedEvent;
  const factory AppDataEvent.loadProfile({@Default(false) bool isUpdated}) =
      _LoadProfileEvent;
  const factory AppDataEvent.saveToken({required String token}) =
      _SaveTokenEvent;
  const factory AppDataEvent.saveProfile({required Profile profile}) =
      _SaveProfileEvent;

  const factory AppDataEvent.deleteToken() = _DeleteTokenEvent;
  const factory AppDataEvent.deleteProfile() = _DeleteProfileEvent;
}
