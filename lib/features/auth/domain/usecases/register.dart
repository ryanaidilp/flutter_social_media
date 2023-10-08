import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Register implements UseCase<bool, RegisterParam, AuthRepository> {
  @override
  Future<Either<Failure, bool>> call(RegisterParam param) => repo.register(
        name: param.name,
        email: param.email,
        password: param.password,
        username: param.username,
      );

  @override
  AuthRepository get repo => getIt<AuthRepository>();
}

class RegisterParam extends Equatable {
  const RegisterParam({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });
  final String name;
  final String username;
  final String email;
  final String password;
  @override
  List<Object> get props => [name, username, email, password];
}
