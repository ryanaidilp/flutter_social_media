import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/extension/typedef.dart';
import 'package:flutter_social/core/graphql/modules/auth_graphql_module.dart';
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
}

@LazySingleton(as: PostRemoteDataSource)
class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final _graphQLAuthModule = getIt<AuthGraphQLModule>();

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
      throw Exception(result.exception);
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
}
