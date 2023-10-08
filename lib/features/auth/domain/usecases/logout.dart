import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/di/service_locator.dart';

import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Logout implements UseCase<bool, String, AuthRepository> {
  @override
  Future<Either<Failure, bool>> call(String param) => repo.logout(id: param);

  @override
  AuthRepository get repo => getIt<AuthRepository>();
}
