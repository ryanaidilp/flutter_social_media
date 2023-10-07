import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  const Pagination({
    required this.total,
    required this.currentPage,
    required this.perPage,
    required this.lastPage,
    required this.hasMorePages,
  });
  final int total;
  final int currentPage;
  final int perPage;
  final int lastPage;
  final bool hasMorePages;

  @override
  List<Object> get props {
    return [
      total,
      currentPage,
      perPage,
      lastPage,
      hasMorePages,
    ];
  }
}
