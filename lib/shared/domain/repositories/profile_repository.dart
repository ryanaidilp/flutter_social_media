import 'package:dartz/dartz.dart';

import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/shared/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile({bool isUpdated = false});
  Future<Either<Failure, bool>> deleteProfile();
  Future<Either<Failure, bool>> saveProfile(Profile profile);
}
