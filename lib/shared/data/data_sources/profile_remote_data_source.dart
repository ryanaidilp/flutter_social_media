import 'package:injectable/injectable.dart';

import 'package:flutter_social/core/constants/json_constant.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/network/api_endpoint.dart';
import 'package:flutter_social/core/network/http/modules/flutter_social_http_module.dart';

import 'package:flutter_social/shared/data/dtos/profile_dto.dart';
import 'package:flutter_social/shared/data/mapper/profile_mapper.dart';
import 'package:flutter_social/shared/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final _httpClient = getIt<FlutterSocialHttpModule>();

  @override
  Future<ProfileModel> getProfile() async {
    final response = await _httpClient.get(ApiEndpoint.baseUrl);

    if(response.containsKey(JsonConstant.attributes)) {
      final profileDto = ProfileDto.fromJson(response); 
      return ProfileMapper.fromDto(profileDto);
    }

    return ProfileModel.fromJson(response);
  }
}
