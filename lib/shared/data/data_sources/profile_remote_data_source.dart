import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/extension/typedef.dart';
import 'package:flutter_social/shared/data/models/profile_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final _graphQlClient = getIt<GraphQLClient>(
    instanceName: 'authGraphQLClient',
  );

  @override
  Future<ProfileModel> getProfile() async {
    final result = await _graphQlClient.query(
      QueryOptions(
        document: gql('''
          query {
            profile{
              id
              name
              email
              photo
              username
            }
          }
        '''),
        errorPolicy: ErrorPolicy.all,
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception);
    }

    return ProfileModel.fromJson(result.data?['profile'] as JSON);
  }
}
