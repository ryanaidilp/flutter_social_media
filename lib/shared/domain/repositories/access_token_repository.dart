import 'package:dartz/dartz.dart';

import 'package:flutter_social/core/failures/failures.dart';

abstract class AccessTokenRepository {
  Future<Either<Failure, String>> getAccessToken();
  Future<Either<Failure, bool>> saveAccessToken(String token);
  Future<Either<Failure, bool>> hasAccessToken();
  Future<Either<Failure, bool>> deleteAccessToken();
}
