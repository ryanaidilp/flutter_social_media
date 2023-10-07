import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/extension/typedef.dart';
import 'package:flutter_social/core/graphql/modules/public_graphql_module.dart';
import 'package:flutter_social/features/splash/data/models/user_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getAllUsers({
    required int page,
    required int perPage,
  });
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final _graphQLModule =
      getIt<PublicGraphQLModule>();

  @override
  Future<List<UserModel>> getAllUsers({
    required int page,
    required int perPage,
  }) async {
    final client = await _graphQLModule.client;
    final result = await client.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.noCache,
        document: gql(r'''
          query Query($limit: Int!, $page: Int!){
            users(first: $limit, page: $page){
            	paginatorInfo {
                total
                currentPage
                perPage
                firstItem
                lastItem
                lastPage
                count
                hasMorePages
              }
              data {
                id
                name
                username
                email
                photo
              }

            }
          }
    '''),
        variables: {
          'limit': perPage,
          'page': page,
        },
        errorPolicy: ErrorPolicy.all,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception);
    }

    final data = result.data?['users']['data'] as List?;

    if (data == null) {
      return [];
    }

    return data.map((e) => UserModel.fromJson(e as JSON)).toList();
  }
}
