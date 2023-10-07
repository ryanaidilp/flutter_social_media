import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/splash/data/datasources/user_remote_data_source.dart';
import 'package:flutter_social/features/splash/data/models/user_model.dart';
import 'package:flutter_social/features/splash/domain/entities/user.dart';
import 'package:flutter_social/features/splash/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final _graphQlDataSource = getIt<UserRemoteDataSource>();

  @override
  Future<Either<Failure, List<User>>> getAllUsers({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final result = await _graphQlDataSource.getAllUsers(
        page: page,
        perPage: perPage,
      );

      return Right(result.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }
}
