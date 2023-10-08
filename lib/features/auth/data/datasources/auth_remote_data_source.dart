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

  Future<bool> register({
    required String name,
    required String username,
    required String email,
    required String password,
  });

  Future<bool> logout(String id);
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
      throw Exception(result.exception?.graphqlErrors.first.message);
    }

    final data = result.data?['login'];

    if (data == null) {
      throw Exception('Failed to login!');
    }

    return data.toString();
  }

  @override
  Future<bool> logout(String id) async {
    final client = await _publicGraphQLModule.client;
    final result = await client.mutate(
      MutationOptions(
        document: gql(r'''
        mutation Logout($id: ID!) {
          logout(id: $id)
        }

      '''),
        variables: {
          'id': id,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception?.graphqlErrors.first.message);
    }

    final data = result.data?['logout'];

    if (data == null) {
      throw Exception('Failed to logout!');
    }

    return data as bool;
  }

  @override
  Future<bool> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    final client = await _publicGraphQLModule.client;
    final result = await client.mutate(
      MutationOptions(
        document: gql(r'''
       mutation Register(
         $name: String!
         $username: String!
         $email: String!
         $password: String!
       ) {
         createUser(
           name: $name
           username: $username
           email: $email
           password: $password
         ) {
          id
          name
          email
          username 
         }
       }
      '''),
        variables: {
          'name': name,
          'username': username,
          'email': email,
          'password': password,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception?.graphqlErrors.first.message);
    }

    final data = result.data?['createUser'];

    if (data == null) {
      throw Exception('Failed to register!');
    }

    return true;
  }
}
