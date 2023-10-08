import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/features/home/domain/repositories/post_repository.dart';
import 'package:flutter_social/shared/domain/entities/graphql_response.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GetAllPosts
    implements
        UseCase<GraphQLResponse<List<Post>>, PaginationParam, PostRepository> {
  @override
  Future<Either<Failure, GraphQLResponse<List<Post>>>> call(
    PaginationParam param,
  ) =>
      repo.getAllPosts(
        page: param.page,
        perPage: param.perPage,
      );

  @override
  PostRepository get repo => getIt<PostRepository>();
}
