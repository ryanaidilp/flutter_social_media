import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/extension/typedef.dart';
import 'package:flutter_social/core/graphql/modules/auth_graphql_module.dart';
import 'package:flutter_social/shared/data/models/profile_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final _graphQLModule = getIt<AuthGraphQLModule>();

  @override
  Future<ProfileModel> getProfile() async {
    final client = await _graphQLModule.client;
    final result = await client.query(
      QueryOptions(
        document: gql('''
          query {
            profile{
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
        '''),
        errorPolicy: ErrorPolicy.all,
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception?.graphqlErrors.first.message);
    }

    return ProfileModel.fromJson(result.data?['profile'] as JSON);
  }
}
