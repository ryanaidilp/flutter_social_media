import 'package:equatable/equatable.dart';

import 'package:flutter_social/core/constants/json_constant.dart';
import 'package:flutter_social/core/extension/typedef.dart';
import 'package:flutter_social/core/network/api_error_type.dart';

abstract class ApiException implements Exception {
  ApiException(this._prefix, this._message);
  final String? _prefix;
  final String? _message;

  @override
  String toString() => '$_prefix: $_message';
}

class ErrorRequestException extends ApiException {
  ErrorRequestException(this.code, this.body, {this.errors})
      : super('Error $code', '$body');
  final List<ApiError>? errors;
  final int code;
  final dynamic body;

  String get errorMessage {
    if (body is String) return body.toString();
    if (body is JSON) {
      final errorMap = body as JSON;
      if (errorMap.containsKey(JsonConstant.message)) {
        return errorMap[JsonConstant.message].toString();
      } else if (errorMap.containsKey(JsonConstant.data)) {
        return errorMap['errors'][0]['message'].toString();
      }
    }

    throw UnimplementedError('Unhandled Error: $body');
  }

  String get errorType {
    if (body is JSON) {
      final errorMap = body as JSON;
      if (errorMap.containsKey('error_type')) {
        return body['error_type'].toString();
      } else if (errorMap.containsKey('errCode')) {
        return body['errCode'].toString();
      }
    }
    return ApiErrorType.unknown;
  }
}

class ApiError extends Equatable {
  const ApiError({
    required this.status,
    required this.title,
    this.id,
    this.code,
    this.detail,
    this.links,
    this.source,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        status: json[JsonConstant.status].toString(),
        title: json[JsonConstant.title].toString(),
        links: ErrorLinks.fromJson(
          json[JsonConstant.links] as Map<String, dynamic>,
        ),
        code: json[JsonConstant.code].toString(),
        detail: json[JsonConstant.detail].toString(),
        id: json[JsonConstant.id].toString(),
        source: json[JsonConstant.source] as ErrorSource?,
      );
  final String? id;
  final String status;
  final String title;
  final String? code;
  final String? detail;
  final ErrorLinks? links;
  final ErrorSource? source;

  @override
  List<Object?> get props => [
        id,
        status,
        title,
        code,
        detail,
        links,
        source,
      ];
}

class ErrorSource extends Equatable {
  const ErrorSource({required this.pointer, this.parameter, this.header});

  factory ErrorSource.fromJson(Map<String, dynamic> json) => ErrorSource(
        pointer: json[JsonConstant.pointer].toString(),
        parameter: json[JsonConstant.parameter].toString(),
        header: json[JsonConstant.header].toString(),
      );
  final String pointer;
  final String? parameter;
  final String? header;

  @override
  List<Object?> get props => [pointer, parameter, header];
}

class ErrorLinks extends Equatable {
  const ErrorLinks({
    required this.about,
    required this.type,
  });

  factory ErrorLinks.fromJson(Map<String, dynamic> json) => ErrorLinks(
        about: json[JsonConstant.about].toString(),
        type: json[JsonConstant.type].toString(),
      );
  final String about;
  final String type;

  @override
  List<Object?> get props => [about, type];
}
