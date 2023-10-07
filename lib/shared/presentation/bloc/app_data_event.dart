part of 'app_data_bloc.dart';

@freezed
class AppDataEvent with _$AppDataEvent {
  const factory AppDataEvent.started() = _Started;
  const factory AppDataEvent.checkIfAuthenticated() = CheckIfAuthenticatedEvent;
  const factory AppDataEvent.loadProfile() = LoadProfileEvent;
  const factory AppDataEvent.saveToken({required String token}) = SaveTokenEvent;
  const factory AppDataEvent.saveProfile({required Profile profile}) =
      SaveProfileEvent;
}
