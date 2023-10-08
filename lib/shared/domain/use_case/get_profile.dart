import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/shared/domain/entities/profile.dart';
import 'package:flutter_social/shared/domain/repositories/profile_repository.dart';

@LazySingleton()
class GetProfile
    implements UseCase<Profile, GetProfileParam, ProfileRepository> {
  GetProfile();

  @override
  Future<Either<Failure, Profile>> call(GetProfileParam param) =>
      repo.getProfile(isUpdated: param.isUpdated);

  @override
  ProfileRepository get repo => getIt<ProfileRepository>();
}

class GetProfileParam extends Equatable {
  const GetProfileParam({
     this.isUpdated = false,
  });
  final bool isUpdated;
  @override
  List<Object> get props => [isUpdated];
}
