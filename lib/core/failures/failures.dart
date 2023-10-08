import 'package:equatable/equatable.dart';

import 'package:flutter_social/core/i18n/translations.g.dart';
import 'package:flutter_social/core/network/api_error_type.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class NetworkFailure extends Failure {

  NetworkFailure({this.message = 'Seems like you have a connection issues!'});
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

class ClientFailure extends Failure {

  ClientFailure({
    String? errorMessage,
  }) : message = errorMessage ?? translate.failures.client;
  final String message;

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  String toString() => message;
}

class ServerFailure extends Failure {

  ServerFailure({
    String? errorMessage,
    this.errorType = ApiErrorType.unknown,
    this.statusCode = 500,
  }) : message = errorMessage ?? translate.failures.server;
  final String message;
  final String errorType;
  final int? statusCode;

  @override
  List<Object?> get props => [
        message,
        errorType,
        statusCode,
      ];

  @override
  String toString() => '[$statusCode] - $message';
}

class NotFoundFailure extends Failure {

  NotFoundFailure({
    String? errorMessage,
    this.errorType = ApiErrorType.notFound,
    this.statusCode = 404,
  }) : message = errorMessage ?? translate.failures.not_found;
  final String message;
  final String errorType;
  final int? statusCode;

  @override
  List<Object?> get props => [
        message,
        errorType,
        statusCode,
      ];

  @override
  String toString() => '[$statusCode] - $message';
}

class UnauthorizedFailure extends Failure {

  UnauthorizedFailure({
    String? errorMessage,
    this.errorType = ApiErrorType.unauthorized,
    this.statusCode = 401,
  }) : message = errorMessage ?? translate.failures.unauthorized;
  final String message;
  final String errorType;
  final int? statusCode;

  @override
  List<Object?> get props => [
        message,
        errorType,
        statusCode,
      ];

  @override
  String toString() => '[$statusCode] - $message';
}

class TimeoutFailure extends Failure {}

class PermissionFailure extends Failure {

  PermissionFailure({
    this.message = 'Permission not granted!',
    this.permissionStatus = 'denied',
  });
  final String message;
  final String permissionStatus;

  @override
  List<Object?> get props => [
        message,
        permissionStatus,
      ];
}

class FormValidationFailure extends Failure {

  FormValidationFailure({
    required this.code,
    required this.message,
    this.errorBody,
  });
  final String message;
  final int code;
  final Map<String, dynamic>? errorBody;

  @override
  List<Object?> get props => [code, message, errorBody];

  @override
  String toString() => '$code - $message';

  String getValidationMessage(String key) {
    if (errorBody == null) return 'Invalid input';
    final value = errorBody![key];

    if (value is List) {
      return value.join(' ');
    }

    return value.toString();
  }
}
