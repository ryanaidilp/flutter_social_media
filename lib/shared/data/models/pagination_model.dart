import 'package:flutter_social/shared/domain/entities/pagination.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_model.freezed.dart';
part 'pagination_model.g.dart';

@freezed
abstract class PaginationModel with _$PaginationModel {
  factory PaginationModel({
    @JsonKey(name: 'total') required int total,
    @JsonKey(name: 'currentPage') required int currentPage,
    @JsonKey(name: 'perPage') required int perPage,
    @JsonKey(name: 'lastPage') required int lastPage,
    @JsonKey(name: 'hasMorePages') required bool hasMorePages,
  }) = _PaginationModel;
  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
}

extension PaginationModelX on PaginationModel {
  Pagination toEntity() => Pagination(
        total: total,
        currentPage: currentPage,
        perPage: perPage,
        lastPage: lastPage,
        hasMorePages: hasMorePages,
      );
}
