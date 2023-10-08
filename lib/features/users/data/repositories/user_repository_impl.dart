import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/users/data/datasources/user_remote_data_source.dart';
import 'package:flutter_social/features/users/data/models/user_model.dart';
import 'package:flutter_social/features/users/domain/entities/user.dart';
import 'package:flutter_social/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_social/shared/data/models/pagination_model.dart';
import 'package:flutter_social/shared/domain/entities/api_response.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final _remoteDataSource = getIt<UserRemoteDataSource>();

  @override
  Future<Either<Failure, ApiResponse<List<User>>>> getAllUsers({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final result = await _remoteDataSource.getAllUsers(
        page: page,
        perPage: perPage,
      );

      return Right(
        ApiResponse<List<User>>(
          pagination: result.pagination?.toEntity(),
          data: result.data?.map((e) => e.toEntity()).toList(),
        ),
      );
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserDetail(String username) async {
    try {
      final result = await _remoteDataSource.getUserDetail(username);

      return Right(
        result.toEntity(),
      );
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }
}
