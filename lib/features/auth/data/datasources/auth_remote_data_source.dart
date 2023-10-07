import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/graphql/modules/public_graphql_module.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Future<String> login({
    required String identifier,
    required String password,
    required String deviceName,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final _publicGraphQLModule = getIt<PublicGraphQLModule>();

  @override
  Future<String> login({
    required String identifier,
    required String password,
    required String deviceName,
  }) async {
    final client = await _publicGraphQLModule.client;
    final result = await client.mutate(
      MutationOptions(
        document: gql(r'''
        mutation Login($identifier: String!, $password: String!, $deviceName: String!) {
          login(identifier: $identifier, password: $password, device_name: $deviceName)
        }
  '''),
        variables: {
          'identifier': identifier,
          'password': password,
          'deviceName': deviceName,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception);
    }

    final data = result.data?['login'];

    if (data == null) {
      throw Exception('Failed to login!');
    }

    return data.toString();
  }
}
