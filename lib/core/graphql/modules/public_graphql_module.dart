import 'package:flutter_social/core/graphql/graphql_module.dart';
import 'package:flutter_social/core/network/api_endpoint.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class PublicGraphQLModule extends GraphQLModule {
  PublicGraphQLModule() : super('${ApiEndpoint.baseUrl}/graphql');

  Future<GraphQLClient> get client async =>
      super.clientSetting(needAuthorization: false);
}
