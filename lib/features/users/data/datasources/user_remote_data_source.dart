import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/extension/typedef.dart';
import 'package:flutter_social/core/graphql/modules/auth_graphql_module.dart';
import 'package:flutter_social/core/network/api_endpoint.dart';
import 'package:flutter_social/core/network/http/modules/flutter_social_http_module.dart';
import 'package:flutter_social/features/users/data/models/user_model.dart';
import 'package:flutter_social/shared/data/models/api_response_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class UserRemoteDataSource {
  Future<ApiResponseModel<List<UserModel>>> getAllUsers({
    required int page,
    required int perPage,
  });

  Future<UserModel> getUserDetail(String username);
  Future<bool> follow(String username);
  Future<bool> unfollow(String username);
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final _httpClient = getIt<FlutterSocialHttpModule>();
  final _graphQLModule = getIt<AuthGraphQLModule>();

  @override
  Future<ApiResponseModel<List<UserModel>>> getAllUsers({
    required int page,
    required int perPage,
  }) async {
    final result = await _httpClient.get(
      ApiEndpoint.users(),
      param: {
        'page': page,
        'per_page': perPage,
      },
    );

    if (result.containsKey('status') && result['status'] != true) {
      throw Exception(result['message']);
    }

    final pagination = result['meta']['pagination'] as JSON;
    final data = result['data'];

    final json = {
      'pagination': pagination,
      'data': data,
    };

    return ApiResponseModel<List<UserModel>>.fromJson(
      json,
      (json) {
        if (json == null || json is! List) {
          return [];
        }

        return json.map((e) => UserModel.fromJson(e as JSON)).toList();
      },
    );
  }

  @override
  Future<UserModel> getUserDetail(String username) async {
    final client = await _graphQLModule.client;
    final result = await client.query(
      QueryOptions(
        document: gql(r'''
          query User($username: String!){
            user(username: $username) {
              id
              name
              username
              photo
              email
              post_count
              followers_count
              following_count
	          }
          }

        '''),
        errorPolicy: ErrorPolicy.all,
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          'username': username,
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception?.graphqlErrors.first.message);
    }

    return UserModel.fromJson(result.data?['user'] as JSON);
  }

  @override
  Future<bool> follow(String username) async {
    final result = await _httpClient.post(
      ApiEndpoint.follow(),
      body: {
        'username': username,
      },
    );

    if (result.containsKey('status') && result['status'] != true) {
      throw Exception(result['message']);
    }

    return true;
  }

  @override
  Future<bool> unfollow(String username) async {
    final result = await _httpClient.post(
      ApiEndpoint.unfollow(),
      body: {
        'username': username,
      },
    );

    if (result.containsKey('status') && result['status'] != true) {
      throw Exception(result['message']);
    }

    return true;
  }
}
