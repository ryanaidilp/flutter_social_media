import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/failures/failures.dart';


abstract class AuthRepository {
  Future<Either<Failure, String>> login({
    required String identifier,
    required String password,
  });

  Future<Either<Failure, bool>> register({
    required String name,
    required String email,
    required String username,
    required String password,
  });

  Future<Either<Failure, bool>> checkUsernameAvailability({
    required String username,
  });

  Future<Either<Failure, bool>> logout({
    required String id,
  });
}
