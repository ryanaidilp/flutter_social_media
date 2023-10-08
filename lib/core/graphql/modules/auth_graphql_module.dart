import 'package:flutter_social/core/graphql/graphql_module.dart';
import 'package:flutter_social/core/network/api_endpoint.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthGraphQLModule extends GraphQLModule {
  AuthGraphQLModule() : super('${ApiEndpoint.baseUrl}/graphql');

  Future<GraphQLClient> get client async =>
      super.clientSetting(needAuthorization: true);
}
