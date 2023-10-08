import 'package:bloc/bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/extension/num_x.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/shared/domain/entities/profile.dart';
import 'package:flutter_social/shared/domain/use_case/delete_access_token.dart';
import 'package:flutter_social/shared/domain/use_case/delete_profile.dart';
import 'package:flutter_social/shared/domain/use_case/get_access_token.dart';
import 'package:flutter_social/shared/domain/use_case/get_profile.dart';
import 'package:flutter_social/shared/domain/use_case/save_access_token.dart';
import 'package:flutter_social/shared/domain/use_case/save_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'app_data_event.dart';
part 'app_data_state.dart';
part 'app_data_bloc.freezed.dart';

@LazySingleton()
class AppDataBloc extends Bloc<AppDataEvent, AppDataState> {
  AppDataBloc() : super(const AppDataInitial()) {
    on<AppDataEvent>(
      (event, emit) async {
        if (event is _CheckIfAuthenticatedEvent) {
          emit(const AppDataState.loading());
          await Future.delayed(5.seconds);
          final result = await getAccessToken(NoParams());

          result.fold(
            (l) => emit(const AppDataState.unauthenticated()),
            (r) => emit(const AppDataState.authenticated()),
          );
        } else if (event is _LoadProfileEvent) {
          emit(const AppDataState.loading());
          final result = await getProfile(
            GetProfileParam(isUpdated: event.isUpdated),
          );

          result.fold(
            (l) => emit(const AppDataState.unauthenticated()),
            (r) => emit(AppDataState.profileLoaded(profile: r)),
          );
        } else if (event is _SaveTokenEvent) {
          emit(const AppDataState.loading());
          final result = await saveAccessToken(event.token);
          result.fold(
            (l) => emit(AppDataState.tokenNotStored(failure: l)),
            (r) => emit(const AppDataState.tokenStored()),
          );
        } else if (event is _SaveProfileEvent) {
          emit(const AppDataState.loading());
          final result = await saveProfile(event.profile);
          result.fold(
            (l) => emit(AppDataState.profileNotStored(failure: l)),
            (r) => emit(const AppDataState.profileStored()),
          );
        } else if (event is _DeleteTokenEvent) {
          emit(const AppDataState.loading());
          final result = await deleteAccessToken(NoParams());
          result.fold(
            (l) => emit(AppDataState.tokenNotDeleted(failure: l)),
            (r) => emit(
              const AppDataState.tokenDeleted(),
            ),
          );
        } else if (event is _DeleteProfileEvent) {
          emit(const AppDataState.loading());
          final result = await deleteProfile(NoParams());
          result.fold(
            (l) => emit(AppDataState.profileNotDeleted(failure: l)),
            (r) => emit(
              const AppDataState.profileDeleted(),
            ),
          );
        }
      },
    );
  }
  final GetAccessToken getAccessToken = getIt<GetAccessToken>();
  final GetProfile getProfile = getIt<GetProfile>();
  final SaveAccessToken saveAccessToken = getIt<SaveAccessToken>();
  final SaveProfile saveProfile = getIt<SaveProfile>();
  final DeleteAccessToken deleteAccessToken = getIt<DeleteAccessToken>();
  final DeleteProfile deleteProfile = getIt<DeleteProfile>();
}
