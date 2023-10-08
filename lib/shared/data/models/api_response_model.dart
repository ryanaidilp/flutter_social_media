import 'package:flutter_social/shared/data/models/pagination_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response_model.freezed.dart';
part 'api_response_model.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class ApiResponseModel<T> with _$ApiResponseModel<T> {
  factory ApiResponseModel({
    @JsonKey() T? data,
    @JsonKey() PaginationModel? pagination,
  }) = _ApiResponseModel;

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJson,
  ) =>
      _$ApiResponseModelFromJson(json, fromJson);
}
