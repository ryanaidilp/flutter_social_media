import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/features/users/domain/entities/user.dart';
import 'package:flutter_social/features/users/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GetUserDetail
    implements UseCase<User, GetUserDetailParam, UserRepository> {
  @override
  Future<Either<Failure, User>> call(GetUserDetailParam param) =>
      repo.getUserDetail(param.username);

  @override
  UserRepository get repo => getIt<UserRepository>();
}

class GetUserDetailParam extends Equatable {
  const GetUserDetailParam({
    required this.username,
  });
  final String username;
  @override
  List<Object> get props => [username];
}
