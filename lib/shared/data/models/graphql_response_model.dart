import 'package:flutter_social/shared/data/models/pagination_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'graphql_response_model.freezed.dart';
part 'graphql_response_model.g.dart';

@Freezed(genericArgumentFactories: true)
class GraphQLResponseModel<T> with _$GraphQLResponseModel<T> {
  factory GraphQLResponseModel({
    @JsonKey() T? data,
    @JsonKey() PaginationModel? pagination,
  }) = _GrapQLResponseModel;

  factory GraphQLResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJson,
  ) =>
      _$GraphQLResponseModelFromJson(
        json,
        fromJson,
      );
}
