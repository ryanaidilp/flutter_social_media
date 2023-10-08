import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/features/home/domain/repositories/post_repository.dart';
import 'package:flutter_social/shared/domain/entities/graphql_response.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GetUserPosts
    implements
        UseCase<GraphQLResponse<List<Post>>, GetUserPostsParam,
            PostRepository> {
  @override
  Future<Either<Failure, GraphQLResponse<List<Post>>>> call(
    GetUserPostsParam param,
  ) =>
      repo.getUserPosts(
        username: param.username,
        page: param.page,
        perPage: param.perPage,
      );

  @override
  PostRepository get repo => getIt<PostRepository>();
}

class GetUserPostsParam extends Equatable {
  const GetUserPostsParam({
    required this.username,
    this.page = 1,
    this.perPage = 10,
  });
  final int page;
  final int perPage;
  final String username;

  @override
  List<Object> get props => [page, perPage, username];
}
