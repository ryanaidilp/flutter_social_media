import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/exception/exceptions.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/shared/domain/repositories/access_token_repository.dart';
import 'package:flutter_social/shared/data/data_sources/access_token_local_data_source.dart';

@LazySingleton(as: AccessTokenRepository)
class AccessTokenRepositoryImpl implements AccessTokenRepository {

  AccessTokenRepositoryImpl();
  final dataSource = getIt<AccessTokenLocalDataSource>();

  @override
  Future<Either<Failure, bool>> deleteAccessToken() async {
    try {
      final result = await dataSource.deleteAccessToken();
      return Right(result);
    } catch (e) {
      return Left(ClientFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getAccessToken() async {
    try {
      final result = await dataSource.getAccessToken();
      return Right(result);
    } on NotFoundException {
      return Left(NotFoundFailure());
    } catch (e) {
      return Left(ClientFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> hasAccessToken() async {
    try {
      final result = await dataSource.hasAccessToken();
      return Right(result);
    } catch (e) {
      return Left(ClientFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveAccessToken(String token) async {
    try {
      final result = await dataSource.saveAccessToken(token);
      return Right(result);
    } catch (e) {
      return Left(ClientFailure());
    }
  }
}
