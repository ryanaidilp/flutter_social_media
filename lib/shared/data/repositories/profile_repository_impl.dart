import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/network/api_exception.dart';
import 'package:flutter_social/shared/data/data_sources/profile_local_data_source.dart';
import 'package:flutter_social/shared/data/data_sources/profile_remote_data_source.dart';
import 'package:flutter_social/shared/data/models/profile_model.dart';
import 'package:flutter_social/shared/domain/entities/profile.dart';
import 'package:flutter_social/shared/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final _localDataSource = getIt<ProfileLocalDataSource>();
  final _remoteDataSource = getIt<ProfileRemoteDataSource>();

  @override
  Future<Either<Failure, bool>> deleteProfile() async {
    try {
      final result = await _localDataSource.deleteProfile();
      return Right(result);
    } catch (e) {
      return Left(ClientFailure());
    }
  }

  @override
  Future<Either<Failure, Profile>> getProfile({bool isUpdated = false}) async {
    ProfileModel? result;
    try {
      result = await _localDataSource.getProfile();
      final expiredAt = await _localDataSource.getExpiredAt();
      final difference = DateTime.now().difference(expiredAt);
      final isExpired = difference.inMinutes > 60;

      if (result == null || isExpired || isUpdated) {
        final remoteProfile = await _remoteDataSource.getProfile();
        await _localDataSource.updateExpiredAt();
        if (result != remoteProfile) {
          await _localDataSource.deleteProfile();
          await _localDataSource.saveProfile(remoteProfile.toEntity());
        }
        result = remoteProfile;
      }

      return Right(result.toEntity());
    } on ErrorRequestException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ClientFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveProfile(Profile profile) async {
    try {
      final result = await _localDataSource.saveProfile(
        profile,
      );
      return Right(result);
    } catch (e) {
      return Left(ClientFailure());
    }
  }
}
