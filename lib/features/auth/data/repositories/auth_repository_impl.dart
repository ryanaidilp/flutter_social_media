import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_social/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social/shared/domain/entities/profile.dart';
import 'package:flutter_social/utils/device_info_util.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final _remoteDataSource = getIt<AuthRemoteDataSource>();

  @override
  Future<Either<Failure, bool>> checkUsernameAvailability({
    required String username,
  }) {
    // TODO: implement checkUsernameAvailability
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final deviceInfo = getIt<DeviceInfoUtil>();
      final deviceName = await deviceInfo.name();

      final result = await _remoteDataSource.login(
        identifier: identifier,
        password: password,
        deviceName: deviceName,
      );

      return Right(result);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout({required String id}) async {
    try {
      final result = await _remoteDataSource.logout(id);

      return Right(result);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> register({
    required String name,
    required String email,
    required String username,
  }) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
