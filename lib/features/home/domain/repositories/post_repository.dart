import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/shared/domain/entities/graphql_response.dart';

abstract class PostRepository {
  Future<Either<Failure, GraphQLResponse<List<Post>>>> getAllPosts({
    required int page,
    required int perPage,
  });

  Future<Either<Failure, GraphQLResponse<List<Post>>>> getMyPosts({
    required int page,
    required int perPage,
  });

  Future<Either<Failure, Post>> createPost({
    required String userID,
    required String description,
    required File image,
  });
}
