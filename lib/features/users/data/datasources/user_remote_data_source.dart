import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/extension/typedef.dart';
import 'package:flutter_social/core/network/api_endpoint.dart';
import 'package:flutter_social/core/network/http/modules/flutter_social_http_module.dart';
import 'package:flutter_social/features/users/data/models/user_model.dart';
import 'package:flutter_social/shared/data/models/api_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class UserRemoteDataSource {
  Future<ApiResponseModel<List<UserModel>>> getAllUsers({
    required int page,
    required int perPage,
  });
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final _httpClient = getIt<FlutterSocialHttpModule>();

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
}
