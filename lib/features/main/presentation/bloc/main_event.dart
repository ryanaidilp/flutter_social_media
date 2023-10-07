part of 'main_bloc.dart';

@freezed
class MainEvent with _$MainEvent {
  factory MainEvent.started() = _Started;
}
