import 'package:equatable/equatable.dart';
import 'package:flutter_social/shared/domain/entities/pagination.dart';

class ApiResponse<T> extends Equatable {
  const ApiResponse({
    this.data,
    this.pagination,
  });
  final T? data;
  final Pagination? pagination;
  @override
  List<Object?> get props => [data, pagination];
}
