import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/users/domain/entities/user.dart';
import 'package:flutter_social/shared/domain/entities/api_response.dart';

abstract class UserRepository {
  Future<Either<Failure, ApiResponse<List<User>>>> getAllUsers({
    int page = 1,
    int perPage = 10,
  });
  Future<Either<Failure, ApiResponse<List<User>>>> getFollowers({
    required String username,
    int page = 1,
    int perPage = 10,
  });
  Future<Either<Failure, ApiResponse<List<User>>>> getFollowing({
    required String username,
    int page = 1,
    int perPage = 10,
  });

  Future<Either<Failure, User>> getUserDetail(String username);
  Future<Either<Failure, bool>> follow(String username);
  Future<Either<Failure, bool>> unfollow(String username);
}
