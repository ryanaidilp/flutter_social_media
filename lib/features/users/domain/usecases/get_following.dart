import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/features/users/domain/entities/user.dart';
import 'package:flutter_social/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_social/shared/domain/entities/api_response.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GetFollowing
    implements
        UseCase<ApiResponse<List<User>>, GetFollowingParam, UserRepository> {
  @override
  Future<Either<Failure, ApiResponse<List<User>>>> call(
    GetFollowingParam param,
  ) =>
      repo.getFollowing(
        username: param.username,
        page: param.page,
        perPage: param.perPage,
      );

  @override
  UserRepository get repo => getIt<UserRepository>();
}

class GetFollowingParam extends Equatable {
  const GetFollowingParam({
    required this.username,
    this.page = 1,
    this.perPage = 10,
  });
  final String username;
  final int page;
  final int perPage;

  @override
  List<Object> get props => [username, page, perPage];
}
