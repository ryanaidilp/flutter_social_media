import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/extension/typedef.dart';
import 'package:flutter_social/core/graphql/modules/auth_graphql_module.dart';
import 'package:flutter_social/core/network/api_endpoint.dart';
import 'package:flutter_social/core/network/http/modules/flutter_social_http_module.dart';
import 'package:flutter_social/features/home/data/models/post_model.dart';
import 'package:flutter_social/shared/data/models/graphql_response_model.dart';
import 'package:flutter_social/shared/data/models/pagination_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class PostRemoteDataSource {
  Future<GraphQLResponseModel<List<PostModel>>> getAllPosts({
    required int page,
    required int perPage,
  });

  Future<GraphQLResponseModel<List<PostModel>>> getMyPosts({
    required int page,
    required int perPage,
  });

  Future<GraphQLResponseModel<List<PostModel>>> getUserPosts({
    required String username,
    required int page,
    required int perPage,
  });

  Future<PostModel> createPost({
    required String userID,
    required String description,
    required File image,
  });
}

@LazySingleton(as: PostRemoteDataSource)
class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final _graphQLAuthModule = getIt<AuthGraphQLModule>();

  final _httpClient = getIt<FlutterSocialHttpModule>();

  @override
  Future<GraphQLResponseModel<List<PostModel>>> getAllPosts({
    required int page,
    required int perPage,
  }) async {
    final client = await _graphQLAuthModule.client;
    final result = await client.query(
      QueryOptions(
        document: gql(r'''
          query FollowingPosts($page: Int!, $perPage: Int!) {
            posts(first: $perPage, page: $page) {
              data {
                id
                image
                description
                created_at
                user {
                  id
                  name
                  username
                  email
                  followers_count
                  following_count
                  post_count
                  photo
                }
              }
              paginatorInfo {
                total
                currentPage
                perPage
                lastPage
                hasMorePages
              }
            }
          }'''),
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          'page': page,
          'perPage': perPage,
        },
      ),
    );

    final data = result.data;

    if (result.hasException || data == null) {
      throw Exception(result.exception?.graphqlErrors.first.message);
    }

    final pagination = data['posts']['paginatorInfo'] as JSON;
    final posts = data['posts']['data'] as List;

    final paginationData = PaginationModel.fromJson(pagination);

    final jsonData = {
      'pagination': paginationData.toJson(),
      'data': posts,
    };

    return GraphQLResponseModel<List<PostModel>>.fromJson(
      jsonData,
      (json) {
        if (json == null || json is! List) {
          return [];
        }

        return json.map((e) => PostModel.fromJson(e as JSON)).toList();
      },
    );
  }

  @override
  Future<GraphQLResponseModel<List<PostModel>>> getMyPosts({
    required int page,
    required int perPage,
  }) async {
    final client = await _graphQLAuthModule.client;
    final result = await client.query(
      QueryOptions(
        document: gql(r'''
          query FollowingPosts($page: Int!, $perPage: Int!) {
            myPosts(first: $perPage, page: $page) {
              data {
                id
                image
                description
                created_at
                user {
                  id
                  name
                  username
                  email
                  followers_count
                  following_count
                  post_count
                  photo
                }
              }
              paginatorInfo {
                total
                currentPage
                perPage
                lastPage
                hasMorePages
              }
            }
          }'''),
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          'page': page,
          'perPage': perPage,
        },
      ),
    );

    final data = result.data;

    if (result.hasException || data == null) {
      throw Exception(result.exception?.graphqlErrors.first.message);
    }

    final pagination = data['myPosts']['paginatorInfo'] as JSON;
    final posts = data['myPosts']['data'] as List;

    final paginationData = PaginationModel.fromJson(pagination);

    final jsonData = {
      'pagination': paginationData.toJson(),
      'data': posts,
    };

    return GraphQLResponseModel<List<PostModel>>.fromJson(
      jsonData,
      (json) {
        if (json == null || json is! List) {
          return [];
        }

        return json.map((e) => PostModel.fromJson(e as JSON)).toList();
      },
    );
  }

  @override
  Future<PostModel> createPost({
    required String userID,
    required String description,
    required File image,
  }) async {
    final file = await MultipartFile.fromFile(image.path);
    final result = await _httpClient.post(
      ApiEndpoint.createPost(),
      body: FormData.fromMap(
        {
          'user_id': userID,
          'description': description,
          'image': file,
        },
      ),
    );

    if (result.containsKey('status') && result['status'] != true) {
      throw Exception(result['message']);
    }

    return PostModel.fromJson(result['data'] as JSON);
  }

  @override
  Future<GraphQLResponseModel<List<PostModel>>> getUserPosts({
    required String username,
    required int page,
    required int perPage,
  }) async {
    log('username: $username, page: $page, perPage: $perPage');
    final client = await _graphQLAuthModule.client;
    final result = await client.query(
      QueryOptions(
        document: gql(r'''
          query UserPost($page: Int!, $perPage: Int!, $username: String!) {
            userPosts(first: $perPage, page: $page, username: $username) {
              data {
                id
                image
                description
                created_at
                user {
                  id
                  name
                  username
                  email
                  followers_count
                  following_count
                  post_count
                  photo
                }
              }
              paginatorInfo {
                total
                currentPage
                perPage
                lastPage
                hasMorePages
              }
            }
          }'''),
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          'page': page,
          'perPage': perPage,
          'username': username,
        },
      ),
    );

    final data = result.data;

    if (result.hasException || data == null) {
      throw Exception(result.exception?.graphqlErrors.first.message);
    }

    final pagination = data['userPosts']['paginatorInfo'] as JSON;
    final posts = data['userPosts']['data'] as List;

    final paginationData = PaginationModel.fromJson(pagination);

    final jsonData = {
      'pagination': paginationData.toJson(),
      'data': posts,
    };

    return GraphQLResponseModel<List<PostModel>>.fromJson(
      jsonData,
      (json) {
        if (json == null || json is! List) {
          return [];
        }

        return json.map((e) => PostModel.fromJson(e as JSON)).toList();
      },
    );
  }
}
