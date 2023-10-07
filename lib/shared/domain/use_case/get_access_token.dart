import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/shared/domain/repositories/access_token_repository.dart';

@LazySingleton()
class GetAccessToken
    implements UseCase<String, NoParams, AccessTokenRepository> {
  @override
  Future<Either<Failure, String>> call(NoParams param) async =>
      repo.getAccessToken();

  @override
  AccessTokenRepository get repo => getIt<AccessTokenRepository>();
}
