import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/network/api_exception.dart';
import 'package:flutter_social/features/home/data/datasources/post_remote_data_source.dart';
import 'package:flutter_social/features/home/data/models/post_model.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/features/home/domain/repositories/post_repository.dart';
import 'package:flutter_social/shared/data/models/pagination_model.dart';
import 'package:flutter_social/shared/domain/entities/graphql_response.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PostRepository)
class PostRepositoryImpl implements PostRepository {
  final _remoteDataSource = getIt<PostRemoteDataSource>();

  @override
  Future<Either<Failure, GraphQLResponse<List<Post>>>> getAllPosts({
    required int page,
    required int perPage,
  }) async {
    try {
      final result = await _remoteDataSource.getAllPosts(
        page: page,
        perPage: perPage,
      );
      final data = result.data?.map((e) => e.toEntity()).toList();
      final response = GraphQLResponse<List<Post>>(
        data: data,
        pagination: result.pagination?.toEntity(),
      );

      return Right(response);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GraphQLResponse<List<Post>>>> getMyPosts({
    required int page,
    required int perPage,
  }) async {
    try {
      final result = await _remoteDataSource.getMyPosts(
        page: page,
        perPage: perPage,
      );
      final data = result.data?.map((e) => e.toEntity()).toList();
      final response = GraphQLResponse<List<Post>>(
        data: data,
        pagination: result.pagination?.toEntity(),
      );

      return Right(response);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Post>> createPost({
    required String userID,
    required String description,
    required File image,
  }) async {
    try {
      final result = await _remoteDataSource.createPost(
        userID: userID,
        description: description,
        image: image,
      );

      return Right(result.toEntity());
    } on ErrorRequestException catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GraphQLResponse<List<Post>>>> getUserPosts({
    required String username,
    required int page,
    required int perPage,
  }) async {
    try {
      final result = await _remoteDataSource.getUserPosts(
        username: username,
        page: page,
        perPage: perPage,
      );
      final data = result.data?.map((e) => e.toEntity()).toList();
      final response = GraphQLResponse<List<Post>>(
        data: data,
        pagination: result.pagination?.toEntity(),
      );

      return Right(response);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }
}
