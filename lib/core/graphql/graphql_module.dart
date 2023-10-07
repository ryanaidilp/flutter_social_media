import 'package:flutter/material.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/shared/domain/use_case/get_access_token.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class GraphQLModule {
  const GraphQLModule(this.baseUrl);

  final String baseUrl;

  @protected
  Future<GraphQLClient> clientSetting({required bool needAuthorization}) async {
    var httpLink = HttpLink(baseUrl);

    if (needAuthorization) {
      final result = await getIt<GetAccessToken>().call(NoParams());
      final token = result.fold((l) => '', (r) => r);

      httpLink = HttpLink(
        baseUrl,
        defaultHeaders: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    }

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }
}
