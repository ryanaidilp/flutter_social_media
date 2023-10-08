import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/shared/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class DeleteProfile implements UseCase<bool, NoParams, ProfileRepository> {
  @override
  Future<Either<Failure, bool>> call(NoParams param) async =>
      repo.deleteProfile();

  @override
  ProfileRepository get repo => getIt<ProfileRepository>();
}
