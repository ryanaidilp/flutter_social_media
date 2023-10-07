import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/shared/domain/repositories/access_token_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SaveAccessToken implements UseCase<bool, String, AccessTokenRepository> {
  @override
  Future<Either<Failure, bool>> call(String token) async =>
      repo.saveAccessToken(token);

  @override
  AccessTokenRepository get repo => getIt<AccessTokenRepository>();
}
