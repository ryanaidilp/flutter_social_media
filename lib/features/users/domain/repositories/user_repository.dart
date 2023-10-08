import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/users/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getAllUsers({
    int page = 1,
    int perPage = 10,
  });
}
