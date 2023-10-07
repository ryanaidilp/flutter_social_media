import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/shared/domain/entities/profile.dart';
import 'package:flutter_social/shared/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SaveProfile implements UseCase<bool, Profile, ProfileRepository> {
  @override
  Future<Either<Failure, bool>> call(Profile profile) async =>
      repo.saveProfile(profile);

  @override
  ProfileRepository get repo => getIt<ProfileRepository>();
}
