import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/features/users/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class FollowUser implements UseCase<bool, String, UserRepository> {
  @override
  Future<Either<Failure, bool>> call(String param) => repo.follow(param);

  @override
  UserRepository get repo => getIt<UserRepository>();
}
